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

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.childViewControllers.count == 1) {
       [[NSNotificationCenter defaultCenter] postNotificationName:ToggleDrawer object:nil];
        return nil;
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
