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

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
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

- (NSMutableArray<SYBeforeStoryResult *> *)storyGroup {
    if (!_storyGroup) {
        _storyGroup = [@[] mutableCopy];
    }
    return _storyGroup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    White_StatusBar;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    [self.view addSubview:self.picturesView];
    [self.view addSubview:self.headerView];
    [self leftButton];
    [self titleLabel];
    
    
}

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



- (void)didClickedMenuButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:ToggleDrawer object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.storyGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SYBeforeStoryResult *result = self.storyGroup[section];
    return result.stories.count;
    
}

- (SYTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid forIndexPath:indexPath];
    if (!cell) {
        cell = [[SYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
    }
    
    SYBeforeStoryResult *result = self.storyGroup[indexPath.section];
    cell.story = result.stories[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.currentIndexPath = indexPath;
    
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

// top story 轮播器的代理方法
- (void)pictureView:(SYPicturesView *)picturesView clickedIndex:(NSInteger)index {

    if (index < 0 || index >= self.topStory.count) return;

    SYStory *story = self.topStory[index];
    SYBeforeStoryResult *result = self.storyGroup[0];
    for (NSUInteger i = 0; result.stories.count; i++) {
        if ([story.title isEqualToString:[result.stories[i] title]]) {
            self.currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    [self gotoDetailControllerWithStory:story];
}

- (void)gotoDetailControllerWithStory:(SYStory *)story {
    
    SYDetailController *dc = [[SYDetailController alloc] initWithStory:story];
    
    dc.delegate =self;
    if (self.currentIndexPath.row == 0 && self.currentIndexPath.section == 0) {
        dc.position = 0;
    } else {
        dc.position = 1;
    }
    [self.navigationController pushViewController:dc animated:YES];
}



// 下一篇永远都会有
- (SYStory *)nextStoryForDetailController:(SYDetailController *)detailController {
    NSInteger row = self.currentIndexPath.row;
    NSInteger section = self.currentIndexPath.section;
    
    if (section == self.storyGroup.count-1) {
        [self loadMoreBefore];
    }
    
    
    SYBeforeStoryResult *result = self.storyGroup[section];
    if (row == result.stories.count-1) {
        section += 1;
        result = self.storyGroup[section];
        row = 0;
    } else {
        row += 1;
    }
    SYStory *story = result.stories[row];
    detailController.position = 1;
    self.currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return story;
}

- (SYStory *)prevStoryForDetailController:(SYDetailController *)detailController {
    
    NSInteger row = self.currentIndexPath.row;
    NSInteger section = self.currentIndexPath.section;
    
    if (row == 0 && section ==0) return nil;

    if (row == 0) {
        section -= 1;
        row = self.storyGroup[section].stories.count-1;
    } else {
        row -= 1;
    }
    
    SYBeforeStoryResult *result = self.storyGroup[section];
    if (row == 0 && section ==0) {
        detailController.position = 0;
    } else {
        detailController.position = 1;
    }
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return result.stories[row];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -80) {
        [self reload];
    }
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
