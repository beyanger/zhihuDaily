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


@interface SYThemeController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<SYStory *> *stories;
@property (nonatomic, strong) SYThemeItem *themeItem;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) SYRefreshView *refreshView;
@end

static NSString *theme_reuseid = @"theme_reuseid";

@implementation SYThemeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headerView];
   
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.collectBtn];
    [self.view addSubview:self.refreshView];
    [self.view addSubview:self.titleLabel];
    WEAKSELF;
  
    [self.refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.titleLabel);
        make.right.mas_equalTo(ws.titleLabel.mas_left).offset(-12);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [self reload];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:theme_reuseid];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:theme_reuseid];
    }
    
    cell.textLabel.text = self.stories[indexPath.row].title;
    return cell;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.frame = CGRectMake(0, 60, kScreenWidth, kScreenHeight-60);
        _tableView.delegate =self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.contentMode = UIViewContentModeCenter;
        _headerView.clipsToBounds = YES;
        _headerView.frame = CGRectMake(-40, -40, kScreenWidth+80, 100);
        
    }
    return _headerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}

- (SYRefreshView *)refreshView {
    if (!_refreshView) {
        _refreshView = [SYRefreshView refreshViewWithScrollView:self.tableView];
    }
    return _refreshView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.size = CGSizeMake(22, 22);
        _backBtn.center = CGPointMake(20, 40);
        
        [_backBtn addTarget:self action:@selector(didClickedBackBtn) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed:@"News_Arrow"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (void)didClickedBackBtn {
    [[NSNotificationCenter defaultCenter] postNotificationName:ToggleDrawer object:nil];
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
    if (sender.selected) {
        [MBProgressHUD showError:@"已经取消关注"];
    } else {
        [MBProgressHUD showSuccess:@"成功关注"];
    }
    sender.selected = !sender.selected;
}




- (void)setThemeid:(int)themeid {
    _themeid = themeid;
}

- (void)reload {
    [SYZhihuTool getThemeWithThemeId:self.themeid completed:^(id obj) {
        self.themeItem = obj;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.titleLabel.text = self.themeItem.name;
            self.titleLabel.size = [self.themeItem.name sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
            
            _titleLabel.center = CGPointMake(kScreenWidth*0.5, 40);
            self.refreshView.centerY = self.titleLabel.centerY;
            self.refreshView.x = self.titleLabel.x-30;
            [self.headerView sd_setImageWithURL:[NSURL URLWithString:self.themeItem.image]];
            
            [self.tableView reloadData];
            [self.refreshView endRefresh];
        });
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
        self.headerView.height = 100-yoffset;
    } else if (yoffset < -90) {
        self.tableView.contentOffset = CGPointMake(0, -90);
    }

}



- (NSArray<SYStory *> *)stories {
    return self.themeItem.stories;
}




@end
