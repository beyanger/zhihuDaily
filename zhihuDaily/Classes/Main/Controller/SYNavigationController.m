//
//  SYNavigationController.m
//  zhihuDaily
//
//  Created by yang on 16/2/25.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYNavigationController.h"
#import "AppDelegate.h"
#import "SYCollectionController.h"

@interface SYNavigationController () <UINavigationControllerDelegate>

@end

@implementation SYNavigationController
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

#pragma mark navigation delegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // 在进入收藏页面(一级页面，若打开返回手势，会影响收藏页面上的操作)时， 或者进入到其他的二级页面，关闭返回手势
    if ((navigationController.childViewControllers.count == 1 && [viewController isKindOfClass:[SYCollectionController class]]) || navigationController.childViewControllers.count > 1) {
        delegate.mainController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    } else {
        delegate.mainController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    }
}


#pragma mark pop mothed
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    // 当一级页面需要返回时，打开抽屉
    if (self.childViewControllers.count == 1) {
       [kNotificationCenter postNotificationName:ToggleDrawer object:nil];
    }
    
    return [super popViewControllerAnimated:animated];
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
