//
//  SYSettingArrow.h
//  zhihuDaily
//
//  Created by yang on 16/2/27.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYSettingItem.h"

@interface SYSettingArrow : SYSettingItem

@property (nonatomic, assign) Class destvc;

+ (instancetype)itemWithTitle:(NSString *)title operation:(Operation)operation destvc:(Class)destvc;

@end
