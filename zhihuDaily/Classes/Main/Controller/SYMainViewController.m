//
//  ViewController.m
//  zhihuDaily
//
//  Created by yang on 16/2/21.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYMainViewController.h"
#import "SYMainToolBox.h"
#import "SYTheme.h"
#import "SYHomeController.h"
#import "SYZhihuTool.h"
#import "MJExtension.h"
#import "SYThemeController.h"


@interface SYMainViewController ()

@end

@implementation SYMainViewController

- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController {
    self = [super initWithCenterViewController:centerViewController leftDrawerViewController:leftDrawerViewController];
    if (self) {
        self.maximumLeftDrawerWidth = 200;
        self.shouldStretchDrawer = NO;
        self.showsShadow = NO;
        self.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
        self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDrawer) name:OpenDrawer object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeDrawer) name:CloseDrawer object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleDrawer) name:ToggleDrawer object:nil];
    }
    return self;
}

- (void)openDrawer {
    [self openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)closeDrawer {
    [self closeDrawerAnimated:YES completion:nil];

}

- (void)toggleDrawer {
    if (self.openSide == MMDrawerSideNone) {
        [self openDrawer];
    } else {
        [self closeDrawer];
    }
}





- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
