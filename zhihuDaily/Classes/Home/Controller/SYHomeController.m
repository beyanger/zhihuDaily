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

@interface SYHomeController () <SYDetailControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSMutableArray<SYLastestGroup *> *storyGroup;
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

- (NSMutableArray *)allAritcle {
    if (!_storyGroup) {
        _storyGroup = [@[] mutableCopy];
    }
    return _storyGroup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    [self.view addSubview:self.picturesView];
    [self.view addSubview:self.headerView];
    [self leftButton];
    [self titleLabel];
    
    
    
    [SYZhihuTool getBeforeStroyWithDate:[NSDate date] completed:^(id obj) {
        SYBeforeStoryResult *result = obj;
        NSLog(@"----> %lu", result.stories.count);
    }];
  
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"SYTableViewCell" bundle:nil] forCellReuseIdentifier:@"useid"];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [self reload];
}

- (void)reload {
    [SYZhihuTool getLastestStoryWithCompleted:^(id obj) {
        SYLastestParamResult *result = (SYLastestParamResult *)obj;
        
        SYLastestGroup *group = [[SYLastestGroup alloc] init];
        group.stories = result.stories;
        
        self.storyGroup = [@[group] mutableCopy];
        self.topStory = [result.top_stories mutableCopy];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.picturesView.topStroies = result.top_stories;
            [self.tableView reloadData];
            [self.refreshView endRefresh];
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
    
    SYLastestGroup *group = self.storyGroup[section];
    return group.stories.count;
    
}

- (SYTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid forIndexPath:indexPath];
    if (!cell) {
        cell = [[SYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
    }
    
    SYLastestGroup *group = self.storyGroup[indexPath.section];
    cell.story = group.stories[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.currentIndexPath = indexPath;
    
    SYLastestGroup *group = self.storyGroup[indexPath.section];
    SYStory *story = group.stories[indexPath.row];
    
    
    SYDetailController *dc = [[SYDetailController alloc] initWithStory:story];
    dc.delegate = self;
    dc.position = indexPath.row==(group.stories.count-1) ? -1 : indexPath.row;
    
    //[self presentViewController:dc animated:YES completion:nil];
    
    [self.navigationController pushViewController:dc animated:YES];
    
}

- (SYStory *)nextStoryForDetailController:(SYDetailController *)detailController {
    SYLastestGroup *group = self.storyGroup[self.currentIndexPath.section];
    if (self.currentIndexPath.row >= group.stories.count-1) {
        return nil;
    }
    
    SYStory *story = group.stories[self.currentIndexPath.row+1];
    detailController.story = story;
    self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row+1 inSection:self.currentIndexPath.section];
    detailController.position = self.currentIndexPath.row==(group.stories.count-1) ? -1 : self.currentIndexPath.row;
    
    return story;
}

- (SYStory *)prevStoryForDetailController:(SYDetailController *)detailController {
    SYLastestGroup *group = self.storyGroup[self.currentIndexPath.section];
    if (self.currentIndexPath.row <= 0) {
        return nil;
    }
    SYStory *story = group.stories[self.currentIndexPath.row-1];
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row-1 inSection:self.currentIndexPath.section];
    
    detailController.position = self.currentIndexPath.row==(group.stories.count-1) ? -1 : self.currentIndexPath.row;
    return story;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -80) {
        [self reload];
    }
}




- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-20) style:UITableViewStyleGrouped];
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
        refresh.bounds = CGRectMake(0, 0, 24, 24);
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
