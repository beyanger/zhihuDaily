//
//  SYMainViewCell.m
//  zhihuDaily
//
//  Created by yang on 16/2/24.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYLeftDrawerCell.h"

@implementation SYLeftDrawerCell



- (void)setTheme:(SYTheme *)theme {
    _theme = theme;
    self.textLabel.text = theme.name;
}


@end
