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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSLog(@"before -- push: %lu", self.childViewControllers.count);
    
    [super pushViewController:viewController animated:animated];
    
    
    NSLog(@"after -- push: %lu", self.childViewControllers.count);
    
    [self updateGesture];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.childViewControllers.count == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ToggleDrawer object:nil];
        return nil;
    }
    NSLog(@"before --- pop %lu", self.childViewControllers.count);
    
   
    
    UIViewController *vc = [super popViewControllerAnimated:animated];
    

    
    
    NSLog(@"after --- pop %lu", self.childViewControllers.count);
    [self updateGesture];
    return vc;
}

- (void)updateGesture {
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.childViewControllers.count > 1) {
        delegate.mainController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
        delegate.mainController.closeDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    } else {
        delegate.mainController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
        delegate.mainController.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    }
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
