//
//  SYLeftDrawerController.m
//  zhihuDaily
//
//  Created by yang on 16/2/24.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYLeftDrawerController.h"
#import "SYZhihuTool.h"
#import "SYLeftDrawerCell.h"
#import "SYSettingController.h"
#import "AppDelegate.h"
#import "SYThemeController.h"
#import "SYHomeController.h"
#import "SYNavigationController.h"
#import "SYLoginViewController.h"


@interface SYLeftDrawerController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<SYTheme *> *dataSource;


@property (weak, nonatomic) IBOutlet UIButton *offlineButton;
@property (weak, nonatomic) IBOutlet UIButton *dayNightButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
@property (nonatomic, strong) SYNavigationController *naviTheme;

@property (nonatomic, strong)  SYThemeController *themeController;

@end

@implementation SYLeftDrawerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupDataSource];
}

- (void)setupSubviews {
    
 
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.bottomContainer.layer.shadowColor = SYColor(26, 31, 36, 1.0).CGColor;
    self.bottomContainer.layer.shadowOffset = CGSizeMake(0, -30);
    self.bottomContainer.layer.shadowOpacity = 0;
    self.bottomContainer.layer.shadowRadius = 5.;
}


- (IBAction)login {
    SYLoginViewController *lvc = [[SYLoginViewController alloc] init];
    [self presentViewController:lvc animated:YES completion:nil];
}

- (void)setupDataSource {
    [SYZhihuTool getThemesWithCompleted:^(id obj) {
        SYTheme *home = [[SYTheme alloc] init];
        home.name = @"首页";
        self.dataSource = [obj mutableCopy];
        [self.dataSource insertObject:home atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (IBAction)didClickedMenuButton:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"设置"]) {
        SYSettingController *sc = [[SYSettingController alloc] init];
        SYNavigationController *navi = [[SYNavigationController alloc] initWithRootViewController:sc];
        navi.navigationBar.hidden = YES;
        [self.mainController setCenterViewController:navi withCloseAnimation:YES completion:nil];
        return;
    }
}


#pragma mark toolBox中tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (SYLeftDrawerCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse_id = @"main_reuseid";
    SYLeftDrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_id];
    if (!cell) {
        cell = [[SYLeftDrawerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse_id];
        UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
        bgView.backgroundColor = SYColor(21, 26, 31, 1.0);
        cell.selectedBackgroundView = bgView;
        cell.backgroundColor = SYColor(26, 31, 36, 1.0);
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.theme = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self.mainController setCenterViewController:self.naviHome withCloseAnimation:YES completion:nil];
    } else {
        self.themeController.themeid = self.dataSource[indexPath.row].id;
        [self.mainController setCenterViewController:self.naviTheme withCloseAnimation:YES completion:nil];
    }
}

- (SYNavigationController *)naviHome {
    if (!_naviHome) {
        SYHomeController *home = [[SYHomeController alloc] init];
        _naviHome = [[SYNavigationController alloc] initWithRootViewController:home];
        _naviHome.navigationBar.hidden = YES;
    }
    return _naviHome;
}

- (SYNavigationController *)naviTheme {
    if (!_naviTheme) {
        _naviTheme = [[SYNavigationController alloc] initWithRootViewController:self.themeController];
        _naviTheme.navigationBar.hidden = YES;
    }
    return _naviTheme;
}

- (SYThemeController *)themeController {
    if (!_themeController) {
        _themeController = [[SYThemeController alloc] init];
        _themeController.view.backgroundColor = [UIColor whiteColor];
    }
    return _themeController;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"sdfasdfas");
}


@end
