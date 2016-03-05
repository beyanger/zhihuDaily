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
#import "SYNetworkTool.h"


@interface SYLaunchController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation SYLaunchController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url = [kUserDefaults stringForKey:@"launchScreen"];
    
    // 如果之前有缓存的图片，直接加载先~
    if (url) [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    SYMainViewController *mainvc = [[SYMainViewController alloc] init];
    [mainvc view];
    [SYZhihuTool getLaunchImageWithCompleted:^(id obj) {
        [kUserDefaults setObject:obj forKey:@"launchScreen"];
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:obj]];
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.mainController = mainvc;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [UIView animateWithDuration:1.89 animations:^{
                self.backgroundImageView.alpha = 0.0;
                self.backgroundImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                
                [UIApplication sharedApplication].keyWindow.rootViewController = mainvc;
            }];
        });
    } failure:^{
        [MBProgressHUD showError:@"网络不给力啊，亲~请稍后再试..."];
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
