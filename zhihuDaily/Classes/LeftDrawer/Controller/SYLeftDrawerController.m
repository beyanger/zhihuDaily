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
#import "SYLoginController.h"

@interface SYLeftDrawerController () <UITableViewDataSource, UITableViewDelegate, SYLeftDrawerCellDelegate, SYThemeControllerDelegate>
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


#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupDataSource];
    
    [kNotificationCenter addObserver:self selector:@selector(setupDataSource) name:NotiLogin object:nil];
    
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
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:kAccount.avatar]];
    self.nameLabel.text = kAccount.name;
    White_StatusBar;
}

- (void)dealloc {
    [kNotificationCenter removeObserver:self];
}

#pragma mark event handler
- (IBAction)login {
    SYAccount *account = [SYAccount sharedAccount];
    if (account.isLogin) {
        SYProfileController *pc = [[SYProfileController alloc] init];
        [self presentViewController:pc animated:YES completion:nil];
    } else {
        SYLoginController *lvc = [[SYLoginController alloc] init];
        
        [self presentViewController:lvc animated:YES completion:nil];
    }
}

- (void)setupDataSource {
    [SYZhihuTool getThemesWithCompleted:^(NSArray<SYTheme *> *obj) {
        // 将收藏的列表放在前面显示
        NSMutableArray *collected = [@[] mutableCopy];
        NSMutableArray *notCollected = [@[] mutableCopy];
        for (SYTheme *theme in obj) {
            theme.isCollected ? [collected addObject:theme] : [notCollected addObject:theme];
        }
        
        [collected addObjectsFromArray:notCollected];
        self.dataSource = collected;
        
        SYTheme *home = [[SYTheme alloc] init];
        home.name = @"首页";
        home.isCollected = YES;
        
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


#pragma mark tableView Delegate
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
    cell.theme.isCollected = YES;
    
    NSIndexPath *sip = [NSIndexPath indexPathForRow:locate inSection:0];
    NSIndexPath *dip = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView moveRowAtIndexPath:sip toIndexPath:dip];
    [self tableView:self.tableView moveRowAtIndexPath:sip toIndexPath:dip];
    
}


#pragma mark theme controller delegate

- (void)themeController:(SYThemeController *)themeController theme:(SYTheme*)theme actionType:(SYThemeActionType)type {
    NSInteger locate =  [self locateTheme:theme];
    if (locate < 0) return;
    theme.isCollected = type;
    
    NSIndexPath *sip = nil;
    NSIndexPath *dip = nil;
    
    if (type == SYThemeActionTypeCollect) {
        [SYZhihuTool collectedWithTheme:theme];
        
        sip = [NSIndexPath indexPathForRow:locate inSection:0];
        dip = [NSIndexPath indexPathForRow:1 inSection:0];
    } else {
        [SYZhihuTool cancelCollectedWithTheme:theme];
        sip = [NSIndexPath indexPathForRow:locate inSection:0];
        dip = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
    }
    // 重新设置theme，刷新cell的显示
    SYLeftDrawerCell *cell = [self.tableView cellForRowAtIndexPath:sip];
    cell.theme = theme;
    [self.tableView moveRowAtIndexPath:sip toIndexPath:dip];
    [self tableView:self.tableView moveRowAtIndexPath:sip toIndexPath:dip];
    
}

#pragma mark setter & getter
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
