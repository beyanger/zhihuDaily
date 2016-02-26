//
//  AppDelegate.m
//  zhihuDaily
//
//  Created by yang on 16/2/21.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "AppDelegate.h"

#import "SYZhihuTool.h"
#import "UIImageView+WebCache.h"
#import "SYLeftDrawerController.h"
#import "MMDrawerController.h"
#import "SYMainViewController.h"
#import "SYDemoViewController.h"
#import "SYHomeController.h"


@interface AppDelegate ()
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:kScreenBounds];
    [self.window makeKeyAndVisible];
    
    
    self.mainController = [[SYMainViewController alloc] init];
    self.window.rootViewController = self.mainController;

    
    return YES;
    
    
    [self.window makeKeyAndVisible];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window addSubview:imageView];
    self.imageView = imageView;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *url = [ud stringForKey:@"launchScreen"];
    
    if (url) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    [SYZhihuTool getLauchImageWithCompleted:^(NSString *obj) {
        [ud setObject:obj forKey:@"launchScreen"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj]];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.67 animations:^{
            self.imageView.alpha = 0.0;
            self.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [self.imageView removeFromSuperview];
        }];
    });
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
