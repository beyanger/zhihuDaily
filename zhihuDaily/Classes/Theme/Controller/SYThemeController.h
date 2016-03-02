//
//  SYChannelController.h
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYStoryListController.h"
#import "SYTheme.h"


@class SYThemeController;


@interface SYThemeController : SYStoryListController

@property (nonatomic, strong) SYTheme *theme;

@end
