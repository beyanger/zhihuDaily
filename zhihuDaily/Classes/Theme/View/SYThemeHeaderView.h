//
//  SYThemeHeaderView.h
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYThemeItem.h"

@interface SYThemeHeaderView : UIView


@property (nonatomic, strong) SYThemeItem *themeItem;

- (instancetype)initWithAttachScrollView:(UIScrollView *)scrollView;

@end
