//
//  SYHomeController.m
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYHomeController.h"
#import "SYStory.h"
#import "SYLastestGroup.h"
#import "YSHttpTool.h"
#import "MJExtension.h"
#import "SYLastestParamResult.h"
#import "SYTableViewCell.h"
#import "SYDetailController.h"
#import "SYZhihuTool.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "SYRefreshView.h"
#import "SYPicturesView.h"
#import "UIView+Extension.h"
#import "SYBeforeStoryResult.h"
#import "SYHomeHeaderView.h"


@interface SYHomeController () <SYDetailControllerDelegate, UITableViewDataSource, UITableViewDelegate, SYPicturesViewDelegate>

@property (nonatomic, strong) NSMutableArray<SYBeforeStoryResult *> *storyGroup;
@property (nonatomic, strong) NSMutableArray<SYStory *> *topStory;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIButton *leftButton;

@property (nonatomic, strong) SYPicturesView *picturesView;

@property (nonatomic, weak) SYRefreshView *refreshView;

@end


static NSString *reuseid = @"useid";
@implementation SYHomeController


#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    White_StatusBar;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kWhiteColor;

    [self setupTableView];
    [self.view addSubview:self.picturesView];
    [self.view addSubview:self.headerView];
    [self leftButton];
    [self titleLabel];
}

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark private method
- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"SYTableViewCell" bundle:nil] forCellReuseIdentifier:@"useid"];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self reload];
}

- (void)reload {
    [SYZhihuTool getLastestStoryWithCompleted:^(id obj) {
        SYLastestParamResult *result = obj;
        if (self.storyGroup.count > 0) {
            [self.storyGroup removeObjectAtIndex:0];
        }
        [self.storyGroup insertObject:result atIndex:0];
        self.topStory = [result.top_stories mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.picturesView.topStroies = result.top_stories;
            [self.tableView reloadData];
            [self.refreshView endRefresh];
        });
    }];
}

- (void)loadMoreBefore {
    SYBeforeStoryResult *result = self.storyGroup.lastObject;
    [SYZhihuTool getBeforeStroyWithDateString:result.date completed:^(id obj) {
        SYBeforeStoryResult *result = obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.storyGroup addObject:result];
            [self.tableView reloadData];
        });
    }];
}

#pragma mark event action
- (void)didClickedMenuButton:(UIButton *)sender {
    [kNotificationCenter postNotificationName:ToggleDrawer object:nil];
}


#pragma mark - Table view  delegate & data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.storyGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SYBeforeStoryResult *result = self.storyGroup[section];
    return result.stories.count;
    
}

- (SYTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid forIndexPath:indexPath];

    SYBeforeStoryResult *result = self.storyGroup[indexPath.section];
    cell.story = result.stories[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYBeforeStoryResult *result = self.storyGroup[indexPath.section];
    SYStory *story = result.stories[indexPath.row];

    [self gotoDetailControllerWithStory:story];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SYHomeHeaderView *headerView = [SYHomeHeaderView headerViewWithTableView:tableView];
    SYBeforeStoryResult *result = self.storyGroup[section];
    headerView.date = result.date;
    return section ? headerView : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    // 这里的 section == 0 时，不能返回0
    return section ? 36 : CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == 0) {
        self.headerView.height = 55;
        self.titleLabel.alpha = 1;
    }
    // 当显示最后一组时，加载更早之前的数据
    if (section == self.storyGroup.count-1) {
        [self loadMoreBefore];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == 0) {
        self.headerView.height = 20;
        self.titleLabel.alpha = 0;
    }
}

#pragma mark scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -80) {
        [self reload];
    }
}



#pragma mark  图片轮播器 delegate
- (void)pictureView:(SYPicturesView *)picturesView clickedIndex:(NSInteger)index {

    if (index < 0 || index >= self.topStory.count) return;

    SYStory *story = self.topStory[index];
    [self gotoDetailControllerWithStory:story];
}

#pragma mark detailController delegate
struct SYPoint {
    NSInteger x;
    NSInteger y;
};

typedef struct SYPoint SYPoint;

// 下一篇永远都会有
- (SYStory *)nextStoryForDetailController:(SYDetailController *)detailController story:(SYStory *)story {

    if([self detailController:nil story:story] == SYStoryPositionTypeLast) return nil;
    SYPoint location = [self locationStory:story];
    if (location.x == (self.storyGroup[location.y].stories.count-1)) {
        return self.storyGroup[location.y+1].stories.firstObject;
    } else {
        return self.storyGroup[location.y].stories[location.x+1];
    }
}



- (SYStory *)prevStoryForDetailController:(SYDetailController *)detailController story:(SYStory *)story {
    
    if ([self detailController:nil story:story] == SYStoryPositionTypeFirst) return nil;
    SYPoint location = [self locationStory:story];
    if (location.x == 0) {
        return self.storyGroup[location.y-1].stories.lastObject;
    } else {
        return self.storyGroup[location.y].stories[location.x-1];
    }
}
// 查找story在数组中的位置
- (SYPoint)locationStory:(SYStory *)story {
    for (NSUInteger y = 0; y < self.storyGroup.count; y++) {
        NSArray<SYStory *> *stories = self.storyGroup[y].stories;
        for (NSUInteger x = 0; x < stories.count; x++) {
            if (story.id == stories[x].id) {
                return (SYPoint){x, y};
            }
        }
    }
    return (SYPoint){-1, -1};
}


- (SYStoryPositionType)detailController:(SYDetailController *)detailController story:(SYStory *)story {
    if (story.id == self.storyGroup.firstObject.stories.firstObject.id) {
        return SYStoryPositionTypeFirst;
    } else if (story.id == self.storyGroup.lastObject.stories.lastObject.id) {
        return SYStoryPositionTypeLast;
    }
    return SYStoryPositionTypeOther;
}


- (void)gotoDetailControllerWithStory:(SYStory *)story {
    
    SYDetailController *dc = [[SYDetailController alloc] init];
    dc.delegate =self;
    dc.story = story;
    [self.navigationController pushViewController:dc animated:YES];
}


#pragma mark setter & getter

- (NSMutableArray<SYBeforeStoryResult *> *)storyGroup {
    if (!_storyGroup) {
        _storyGroup = [@[] mutableCopy];
    }
    return _storyGroup;
}


- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-20) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 80;
        tableView.showsVerticalScrollIndicator = NO;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        tableView.tableHeaderView = view;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}


- (UIView *)headerView {
    if (!_headerView) {
        
        UIView *headerView = [[UIView alloc] init];
        headerView.frame = CGRectMake(0, 0, kScreenWidth, 56);
        headerView.backgroundColor = SYColor(23, 144, 211, 0.);
        _headerView = headerView;
    }
    return _headerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        
        NSDictionary *attr = @{
            NSFontAttributeName:[UIFont systemFontOfSize:18],
            NSForegroundColorAttributeName:[UIColor whiteColor]};
        
        titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"今日要闻" attributes:attr];
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(kScreenWidth*0.5, 35);
        _titleLabel = titleLabel;
        [self.view addSubview:titleLabel];
        
        SYRefreshView *refresh = [SYRefreshView refreshViewWithScrollView:self.tableView];
        refresh.center = CGPointMake(kScreenWidth*0.5 - 60, 35);
        [self.view addSubview:refresh];
        _refreshView = refresh;
        
    }
    return _titleLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        UIButton *leftButton = [[UIButton alloc] init];
        leftButton.frame = CGRectMake(10, 20, 30, 30);
        [leftButton addTarget:self action:@selector(didClickedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
        [self.view addSubview:leftButton];
        _leftButton = leftButton;
    }
    return _leftButton;
}

- (SYPicturesView *)picturesView {
    if (!_picturesView) {
        _picturesView = [[SYPicturesView alloc] init];
        _picturesView.frame = CGRectMake(0, -45, kScreenWidth, 265);
        _picturesView.delegate = self;
    }
    return _picturesView;
}


#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat yoffset = self.tableView.contentOffset.y;
        if (yoffset <= 0) {
            self.picturesView.height = 265-yoffset;
            self.picturesView.y = -45;
        } else {
            self.picturesView.height = 265;
            self.picturesView.y = -45- yoffset;
        }
        
        CGFloat alpha = 0;
        if (yoffset <= 75.) {
            alpha = 0;
        } else if (yoffset < 165.) {
            alpha = (yoffset-75.) / (165.-75);
        } else {
            alpha = 1.;
        }
        self.headerView.backgroundColor = SYColor(23, 144, 211, alpha);
    }

}


@end
