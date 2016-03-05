//
//  SYSettingController.m
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYSettingController.h"
#import "MBProgressHUD+YS.h"
#import "SYCacheTool.h"
#import "SYSettingGroup.h"
#import "SYSettingArrow.h"
#import "SYSettingSwitch.h"
#import "SYSettingText.h"
#import "SYSettingItem.h"
#import "SYSettingCell.h"
#import "SYLoginViewController.h"
#import "SYAccount.h"
#import "UIImageView+WebCache.h"
#import "SYLoginController.h"
#import "SYProfileController.h"

@interface SYSettingController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<SYSettingGroup *> *groups;

@end

@implementation SYSettingController
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.title = @"设置";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _groups[0].items = @[[SYSettingArrow itemWithTitle:[SYAccount sharedAccount].name operation:nil destvc:[SYAccount sharedAccount].isLogin?[SYProfileController class]:[SYLoginController class] ]];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}



#pragma mark tableView  delegate & data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups[section].items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) return @"仅Wi-Fi下可用, 自动下载最新内容";
    return nil;
}

- (SYSettingCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYSettingCell *cell = [SYSettingCell cellWithTableView:tableView];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        SYAccount *account = [SYAccount sharedAccount];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:account.avatar]];
        
    } else {
        cell.imageView.image = nil;
    }
    cell.item = self.groups[indexPath.section].items[indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SYSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SYSettingItem *item = cell.item;
    
    !item.operation?:item.operation();
    
    
    if ([item isKindOfClass:[SYSettingArrow class]]) {
        SYSettingArrow *arrow = (SYSettingArrow *)item;
        if (arrow.destvc) {
            UIViewController *vc = [[arrow.destvc alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 5 && indexPath.row == 0){
        SYSettingText *text = (SYSettingText *)item;
        text.text = [NSString stringWithFormat:@"清除完毕"];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark setter & getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray<SYSettingGroup *> *)groups {
    if (!_groups) {
        SYSettingGroup *group0 = [[SYSettingGroup alloc] init];
        
        group0.items = @[[SYSettingArrow itemWithTitle:[SYAccount sharedAccount].name operation:nil destvc:[SYAccount sharedAccount].isLogin?[SYProfileController class]:[SYLoginController class] ]];
        
        SYSettingGroup *group1 = [[SYSettingGroup alloc] init];
        group1.items = @[[SYSettingSwitch itemWithTitle:@"自动离线下载" operation:nil]];
        
        SYSettingGroup *group2 = [[SYSettingGroup alloc] init];
        group2.items = @[
                         [SYSettingSwitch itemWithTitle:@"移动网络下载图片" operation:nil],
                         [SYSettingSwitch itemWithTitle:@"大号字" operation:nil]];
        
        SYSettingGroup *group3 = [[SYSettingGroup alloc] init];
        group3.items = @[
                         [SYSettingSwitch itemWithTitle:@"消息推送" operation:nil],
                         [SYSettingSwitch itemWithTitle:@"点评分享到微博" operation:nil]];
        
        SYSettingGroup *group4 = [[SYSettingGroup alloc] init];
        group4.items = @[
                         
                         [SYSettingArrow itemWithTitle:@"去好评" operation:^{
                             
                             NSString *url = @"https://itunes.apple.com/cn/app/zhi-hu-ri-bao-mei-ri-ti-gong/id639087967?l=en&mt=8";
                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                         }],
                         [SYSettingArrow itemWithTitle:@"去吐槽" operation:nil destvc:nil]];
        
        SYSettingGroup *group5 = [[SYSettingGroup alloc] init];
        group5.items = @[
                         [SYSettingText itemWithTitle:@"清除缓存" operation:^{
                             [SYCacheTool clearCache];
                             [MBProgressHUD showSuccess:@"清除成功..."];
                         } text:[NSString stringWithFormat:@" 共 %.1fMB", [SYCacheTool cachedSize]/1024./1024.]],
                         [SYSettingText itemWithTitle:@"检查版本" operation:^{
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 [MBProgressHUD showSuccess:@"恭喜，已经是最新版本"];
                             });
                         } text:@"1.0.0"]];
        _groups = @[group0, group1, group2, group3, group4, group5];
    }
    
    return _groups;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
