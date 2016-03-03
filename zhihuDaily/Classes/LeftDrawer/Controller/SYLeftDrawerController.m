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
#import "SYAccount.h"
#import "UIButton+WebCache.h"
#import "SYCollectionController.h"
#import "UIImageView+WebCache.h"
#import "SYProfileController.h"

@interface SYLeftDrawerController () <UITableViewDelegate, UITableViewDataSource, SYLeftDrawerCellDelegate, SYThemeControllerDelegate>
@property (nonatomic, strong) NSMutableArray<SYTheme *> *dataSource;

@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login)];
    [self.profileView addGestureRecognizer:tap];
}

- (void)setupSubviews {
    
    self.avatarImage.layer.cornerRadius = 18;

    
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = SYColor(26, 31, 36, 1.0);
    
    
 }






- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 更新头像状态
    SYAccount *account = [SYAccount sharedAccount];
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:account.avatar]];
    
    self.nameLabel.text = account.name;
}





- (IBAction)login {
    SYAccount *account = [SYAccount sharedAccount];
    if (account.isLogin) {
        SYProfileController *pc = [[SYProfileController alloc] init];
        [self presentViewController:pc animated:YES completion:nil];
    } else {
        SYLoginViewController *lvc = [[SYLoginViewController alloc] init];
        [self presentViewController:lvc animated:YES completion:nil];
    }
}

- (void)setupDataSource {
    [SYZhihuTool getThemesWithCompleted:^(id obj) {
        SYTheme *home = [[SYTheme alloc] init];
        home.name = @"首页";
        home.isCollected = YES;
        self.dataSource = [obj mutableCopy];
        [self.dataSource insertObject:home atIndex:0];
  
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (NSInteger)locateTheme:(SYTheme *)theme {
    for (NSUInteger i = 0; i < self.dataSource.count; i++) {
        if (self.dataSource[i].id == theme.id) {
            return i;
        }
    }
    return -1;
}



- (IBAction)didClickedMenuButton:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"设置"]) {
        SYSettingController *sc = [[SYSettingController alloc] init];
        SYNavigationController *navi = [[SYNavigationController alloc] initWithRootViewController:sc];
        navi.navigationBar.hidden = YES;
        [self.mainController setCenterViewController:navi withCloseAnimation:YES completion:nil];
        return;
    } else {
        SYCollectionController *cc = [[SYCollectionController alloc] init];;
        
        SYNavigationController *navi = [[SYNavigationController alloc] initWithRootViewController:cc];
        navi.navigationBar.hidden = YES;
        [self.mainController setCenterViewController:navi withCloseAnimation:YES completion:nil];
    }
}


#pragma mark toolBox中tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (SYLeftDrawerCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SYLeftDrawerCell *cell = [SYLeftDrawerCell cellWithTableView:tableView];
    cell.theme = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    SYTheme *theme = self.dataSource[sourceIndexPath.row];
    [self.dataSource removeObjectAtIndex:sourceIndexPath.row];
    if (destinationIndexPath.row == 1) {
        [self.dataSource insertObject:theme atIndex:1];
    } else {
        [self.dataSource addObject:theme];
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.mainController setCenterViewController:self.naviHome withCloseAnimation:YES completion:nil];
    } else {
        self.themeController.theme = self.dataSource[indexPath.row];
        [self.mainController setCenterViewController:self.naviTheme withCloseAnimation:YES completion:nil];
    }
}

#pragma mark cell delegate
- (void)didClickedLeftDrawerCell:(SYLeftDrawerCell *)cell {
    SYTheme *theme = cell.theme;
    NSInteger locate =  [self locateTheme:theme];
    if (locate < 0) return;
    
    NSIndexPath *sip = [NSIndexPath indexPathForRow:locate inSection:0];
    NSIndexPath *dip = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView moveRowAtIndexPath:sip toIndexPath:dip];
    [self tableView:self.tableView moveRowAtIndexPath:sip toIndexPath:dip];
    
}


#pragma mark theme controller delegate

- (void)themeController:(SYThemeController *)themeController theme:(SYTheme*)theme actionType:(SYThemeActionType)type {
    NSInteger locate =  [self locateTheme:theme];
    if (locate < 0) return;
    
    
    NSIndexPath *sip = nil;
    NSIndexPath *dip = nil;
    
    if (type == SYThemeActionTypeCollect) {
        NSLog(@"----收藏---> %@", theme.name);
        [SYZhihuTool collectedWithTheme:theme];
        sip = [NSIndexPath indexPathForRow:locate inSection:0];
        dip = [NSIndexPath indexPathForRow:1 inSection:0];
  
    } else {
        [SYZhihuTool cancelCollectedWithTheme:theme];
        sip = [NSIndexPath indexPathForRow:locate inSection:0];
        dip = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
    }
    
    [self.tableView moveRowAtIndexPath:sip toIndexPath:dip];
    [self tableView:self.tableView moveRowAtIndexPath:sip toIndexPath:dip];
    
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
        _themeController.delegate = self;
    }
    return _themeController;
}



@end
