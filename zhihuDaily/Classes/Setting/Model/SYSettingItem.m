//
//  SYSettingItem.m
//  zhihuDaily
//
//  Created by yang on 16/2/27.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYSettingItem.h"

@implementation SYSettingItem

+ (instancetype)itemWithTitle:(NSString *)title operation:(Operation)operation {
    SYSettingItem *item  = [[self alloc] init];
    if (item) {
        item.title = title;
        item.operation = operation;
    }
    return item;
}

@end
