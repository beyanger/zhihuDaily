//
//  MBProgressHUD+YS.h
//  iWeibo
//
//  Created by yang on 15/11/16.
//  Copyright © 2015年 yang. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (YS)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUD;
@end
