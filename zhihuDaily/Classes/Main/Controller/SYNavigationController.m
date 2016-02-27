//
//  SYNavigationController.m
//  zhihuDaily
//
//  Created by yang on 16/2/25.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYNavigationController.h"
#import "AppDelegate.h"

@interface SYNavigationController ()

@end

@implementation SYNavigationController


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self updateGesture];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.childViewControllers.count == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ToggleDrawer object:nil];
        return nil;
    }
    
    UIViewController *vc = [super popViewControllerAnimated:animated];
    [self updateGesture];
    return vc;
}

- (void)updateGesture {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.viewControllers.count > 1) {
        delegate.mainController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
        delegate.mainController.closeDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    } else {
        delegate.mainController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
        delegate.mainController.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    }
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
