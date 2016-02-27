//
//  SYSettingText.h
//  zhihuDaily
//
//  Created by yang on 16/2/27.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYSettingItem.h"

@interface SYSettingText : SYSettingItem

@property (nonatomic, copy) NSString *text;


+ (instancetype)itemWithTitle:(NSString *)title operation:(Operation)operation text:(NSString *)text;
@end
