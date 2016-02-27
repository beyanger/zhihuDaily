//
//  SYSettingText.m
//  zhihuDaily
//
//  Created by yang on 16/2/27.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYSettingText.h"

@implementation SYSettingText


+ (instancetype)itemWithTitle:(NSString *)title operation:(Operation)operation text:(NSString *)text {
    SYSettingText *item = [SYSettingText itemWithTitle:title operation:operation];
    item.text = text;
    return item;
}

@end
