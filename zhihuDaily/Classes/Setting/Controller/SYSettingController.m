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

@interface SYSettingController ()
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *switches;
@property (weak, nonatomic) IBOutlet UILabel *cachedSize;
@property (nonatomic, strong) NSArray *switchTitle;

@end

@implementation SYSettingController

- (IBAction)didClickedSwitch:(UISwitch *)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:sender.isOn forKey:self.switchTitle[sender.tag]];
    [ud synchronize];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    for (NSUInteger i = 0; i < self.switches.count; i++) {
        UISwitch *switcher = self.switches[i];
        switcher.on = [ud boolForKey:self.switchTitle[switcher.tag]];
    }
    
    self.cachedSize.text = [NSString stringWithFormat:@"共 %.1fMB",
                            [SYCacheTool cachedSize]/1024./1024.];
}

- (IBAction)back:(UIBarButtonItem *)sender {
       [[NSNotificationCenter defaultCenter] postNotificationName:ToggleDrawer object:nil];
}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 5) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (indexPath.row == 0) {
                [SYCacheTool clearCache];
                [MBProgressHUD showSuccess:@"清除成功..."];
                self.cachedSize.text = [NSString stringWithFormat:@"共 %.1fMB",
                                        [SYCacheTool cachedSize]/1024./1024.];
            } else {
                [MBProgressHUD showSuccess:@"恭喜，已经是最新版本"];
            }
        });
    }
}

- (NSArray *)switchTitle {
    if (!_switchTitle) {
        _switchTitle = @[@"自动离线缓存", @"移动网络下载图片", @"大号字", @"消息推送", @"点评分享到微博"];
    }
    return _switchTitle;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
