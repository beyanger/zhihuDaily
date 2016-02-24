//
//  SYMainViewCell.m
//  zhihuDaily
//
//  Created by yang on 16/2/24.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYMainViewCell.h"

@implementation SYMainViewCell

- (void)setTheme:(SYTheme *)theme {
    _theme = theme;
    self.textLabel.text = theme.name;
}


@end
