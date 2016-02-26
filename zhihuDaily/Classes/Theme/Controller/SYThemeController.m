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
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.collectBtn];
    [self.view addSubview:self.refreshView];
    
    WEAKSELF;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(kScreenWidth*0.5, 40));
    }];
    
    [self.refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.titleLabel);
        make.right.mas_equalTo(ws.titleLabel.mas_left).offset(-16);
    }];
    
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
        _tableView.frame = CGRectMake(0, 60, kScreenWidth, kScreenHeight-60);
        _tableView.delegate =self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 60);
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
        _backBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        _backBtn.center = CGPointMake(20, 40);
    }
    return _backBtn;
}

- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _collectBtn.center = CGPointMake(kScreenWidth-20, 40);
    }
    return _collectBtn;
}



- (void)setThemeid:(int)themeid {
    _themeid = themeid;
    [SYZhihuTool getThemeWithThemeId:themeid completed:^(id obj) {
        self.themeItem = obj;
        
        [self.tableView reloadData];
        
        self.titleLabel.text = self.themeItem.name;
        [self.titleLabel sizeToFit];
        
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:self.themeItem.image]];
        
    }];
}

- (NSArray<SYStory *> *)stories {
    return self.themeItem.stories;
}




@end
