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
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "MBProgressHUD+YS.h"
#import "SYTableHeader.h"
#import "SYEditorController.h"
#import "SYTableViewCell.h"
#import "SYDetailController.h"


@interface SYThemeController () 


@property (nonatomic, strong) SYThemeItem *themeItem;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) SYTableHeader *tableHeader;

@end


@implementation SYThemeController


#pragma mark life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.sy_header addSubview:self.collectBtn];
    [self.view bringSubviewToFront:self.sy_header];
    self.sy_attachScrollView = self.tableView;
    self.tableView.tableHeaderView = self.tableHeader;
}


#pragma mark event hander
- (void)clickedHeader {
    SYEditorController *evc = [[SYEditorController alloc] init];
    evc.editors = self.themeItem.editors;
    [self.navigationController pushViewController:evc animated:YES];
}

- (void)didClickedCollectBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.theme.isCollected = sender.selected;
    sender.selected ? [MBProgressHUD showSuccess:@"已经成功关注"] :[MBProgressHUD showError:@"已经取消关注"];
        
    
    if ([self.delegate respondsToSelector:@selector(themeController:theme:actionType:)]) {
        [self.delegate themeController:self theme:self.theme actionType:sender.selected];
    }
}




#pragma mark private method
- (void)reload {
    [SYZhihuTool getThemeWithId:self.theme.id completed:^(id obj) {
        self.themeItem = obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = self.themeItem.name;
            [self.sy_backgoundImageView sd_setImageWithURL:[NSURL URLWithString:self.themeItem.image]];
            NSMutableArray *avatarArray = [@[] mutableCopy];
            
            for (SYEditor *obj in self.themeItem.editors) {
                [avatarArray addObject:obj.avatar];
            }
            
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
    int themeid = self.theme.id;
    [SYZhihuTool getBeforeThemeStoryWithId:themeid storyId:storyid completed:^(id obj) {
        [self.themeItem.stories addObjectsFromArray:obj];
        [self.tableView reloadData];
    }];
}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.stories.count-18) {
        [self loadMoreData];
    }
}

#pragma mark scrollView delegate

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


#pragma mark setter & getter
- (void)setTheme:(SYTheme *)theme {
    _theme = theme;
    
    self.collectBtn.selected = theme.isCollected;
    
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

- (SYTableHeader *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [SYTableHeader headerViewWitTitle:@"编辑" rightViewType:SYRightViewTypeArrow];
        _tableHeader.bounds = CGRectMake(0, 0, kScreenWidth, 48);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedHeader)];
        [_tableHeader addGestureRecognizer:tap];
    }
    return _tableHeader;
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

- (NSArray<SYStory *> *)stories {
    return self.themeItem.stories;
}
@end
