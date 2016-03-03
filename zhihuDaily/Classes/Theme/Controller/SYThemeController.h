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

typedef NS_ENUM(BOOL, SYThemeActionType) {
    SYThemeActionTypeCancel = NO,
    SYThemeActionTypeCollect = YES,
};

@protocol SYThemeControllerDelegate <NSObject>

@optional
- (void)themeController:(SYThemeController *)themeController theme:(SYTheme*)theme actionType:(SYThemeActionType)type;

@end

@interface SYThemeController : SYStoryListController

@property (nonatomic, strong) SYTheme *theme;

@property (nonatomic, weak) id<SYThemeControllerDelegate> delegate;

@end
