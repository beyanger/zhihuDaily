//
//  SYLeftDrawerController.h
//  zhihuDaily
//
//  Created by yang on 16/2/24.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYMainViewController.h"
#import "SYNavigationController.h"


@interface SYLeftDrawerController : UIViewController

@property (nonatomic, strong) SYNavigationController *naviHome;

@property (nonatomic, weak) SYMainViewController *mainController;


@end
