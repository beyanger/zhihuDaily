//
//  SYChannelController.m
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYThemeController.h"
#import "SYRefreshView.h"
#import "SYThemeItem.h"
#import "SYZhihuTool.h"
#import "SYStory.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "MBProgressHUD+YS.h"
#import "SYTableHeader.h"
#import "SYEditorController.h"
#import "SYTableViewCell.h"
#import "SYDetailController.h"


@interface SYThemeController () <UITableViewDataSource, UITableViewDelegate, SYDetailControllerDelegate>

@property (nonatomic, strong) NSArray<SYStory *> *stories;
@property (nonatomic, strong) SYThemeItem *themeItem;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) SYTableHeader *tableHeader;

@end

static NSString *theme_reuseid = @"useid";

@implementation SYThemeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    
    [self.sy_header addSubview:self.collectBtn];
    [self.view bringSubviewToFront:self.sy_header];
    
    self.sy_attachScrollView = self.tableView;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stories.count;
}

- (SYTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:theme_reuseid forIndexPath:indexPath];

   cell.story = self.stories[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYDetailController *dvc = [[SYDetailController alloc] init];
    dvc.delegate = self;
    dvc.story = self.stories[indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.stories.count-18) {
        [self loadMoreData];
    }
}

- (NSInteger)loacateStory:(SYStory *)story {
    for (NSInteger i = 0; i < self.stories.count; i++) {
        if (self.stories[i].id == story.id) {
            return i;
        }
    }
    return -1;
}

- (SYStory *)nextStoryForDetailController:(SYDetailController *)detailController story:(SYStory *)story {
    NSInteger location = [self loacateStory:story];
    if (location == self.stories.count-1) {
        return nil;
    }
    return self.stories[location+1];
}
- (SYStory *)prevStoryForDetailController:(SYDetailController *)detailController story:(SYStory *)story {
    NSInteger location = [self loacateStory:story];
    if (location == 0) {
        return nil;
    }
    return self.stories[location-1];
}
- (SYStoryPositionType)detailController:(SYDetailController *)detailController story:(SYStory *)story {
    if (self.stories.firstObject.id == story.id) {
        return SYStoryPositionTypeFirst;
    } else if ( self.stories.lastObject.id == story.id) {
        return SYStoryPositionTypeLast;
    }
    return SYStoryPositionTypeOther;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.frame = CGRectMake(0, 60, kScreenWidth, kScreenHeight-60);
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.tableHeader;
        _tableView.rowHeight = 80;
        [_tableView registerNib:[UINib nibWithNibName:@"SYTableViewCell" bundle:nil] forCellReuseIdentifier:theme_reuseid];
    }
    return _tableView;
}

- (SYTableHeader *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [SYTableHeader headerViewWitTitle:@"编辑" hidenRight:NO];
        _tableHeader.bounds = CGRectMake(0, 0, kScreenWidth, 48);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedHeader)];
        [_tableHeader addGestureRecognizer:tap];
    }
    return _tableHeader;
}

- (void)clickedHeader {
    SYEditorController *evc = [[SYEditorController alloc] init];
    evc.editors = self.themeItem.editors;
    [self.navigationController pushViewController:evc animated:YES];
}

- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [[UIButton alloc] init];
        
        _collectBtn.size = CGSizeMake(44, 44);
        _collectBtn.center = CGPointMake(kScreenWidth-20, 40);
        [_collectBtn addTarget:self action:@selector(didClickedCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_collectBtn setImage:[UIImage imageNamed:@"Field_Follow"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"Field_Unfollow"] forState:UIControlStateSelected];
        
    }
    return _collectBtn;
}
- (void)didClickedCollectBtn:(UIButton *)sender {
    sender.selected ? [MBProgressHUD showError:@"已经取消关注"] : [MBProgressHUD showSuccess:@"成功关注"];
    sender.selected = !sender.selected;
}


- (void)setThemeid:(int)themeid {
    _themeid = themeid;
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];

    UIView *view = [[UIView alloc] initWithFrame:kScreenBounds];
    view.backgroundColor = SYColor(255, 255, 255, 0);
    [self.view addSubview:view];
    [UIView animateWithDuration:0.25 animations:^{
        view.backgroundColor = SYColor(255, 255, 255, 0.8);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    
    [self reload];
}

- (void)reload {
    [SYZhihuTool getThemeWithId:self.themeid completed:^(id obj) {
        self.themeItem = obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = self.themeItem.name;
            [self.sy_backgoundImageView sd_setImageWithURL:[NSURL URLWithString:self.themeItem.image]];
            NSMutableArray *avatarArray = [@[] mutableCopy];
            [self.themeItem.editors enumerateObjectsUsingBlock:^(SYEditor *obj, NSUInteger idx, BOOL *stop) {
                [avatarArray addObject:obj.avatar];
            }];
            self.tableHeader.avatars = avatarArray;
            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.sy_refreshView endRefresh];
            });
        });
    }];
}


- (void)loadMoreData {
    long long storyid = self.stories.lastObject.id;
    int themeid = self.themeid;
    [SYZhihuTool getBeforeThemeStoryWithId:themeid storyId:storyid completed:^(id obj) {
        [self.themeItem.stories addObjectsFromArray:obj];
        [self.tableView reloadData];
    }];
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -80) {
        [self reload];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yoffset = scrollView.contentOffset.y;
    if (yoffset <= 0 && yoffset >= -90) {
        self.sy_header.height = 60-yoffset;
    } else if (yoffset < -90) {
        self.tableView.contentOffset = CGPointMake(0, -90);
    }
}

- (NSArray<SYStory *> *)stories {
    return self.themeItem.stories;
}
@end
