//
//  SYLaunchController.m
//  zhihuDaily
//
//  Created by yang on 16/2/27.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYLaunchController.h"
#import "UIImageView+WebCache.h"
#import "SYZhihuTool.h"
#import "SYMainViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+YS.h"
#import "SYCacheTool.h"



@interface SYLaunchController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation SYLaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *url = [ud stringForKey:@"launchScreen"];
    
    if (url) [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    
    SYMainViewController *mainvc = [[SYMainViewController alloc] init];
    [mainvc view];
    [SYZhihuTool getLauchImageWithCompleted:^(id obj) {
        [ud setObject:obj forKey:@"launchScreen"];
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:obj]];
        
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.mainController = mainvc;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [UIView animateWithDuration:0.68 animations:^{
                self.backgroundImageView.alpha = 0.;
                self.backgroundImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                [UIApplication sharedApplication].keyWindow.rootViewController = mainvc;
            } completion:nil];
        });
    } failure:^{
        [MBProgressHUD showError:@"网络状况差，请稍后再试..."];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
