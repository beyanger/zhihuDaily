//
//  SYSettingArrow.m
//  zhihuDaily
//
//  Created by yang on 16/2/27.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYSettingArrow.h"

@implementation SYSettingArrow

+ (instancetype)itemWithTitle:(NSString *)title operation:(Operation)operation destvc:(Class)destvc {
    SYSettingArrow *item = [SYSettingArrow itemWithTitle:title operation:operation];
    item.destvc = destvc;
    return item;
    
}

@end
