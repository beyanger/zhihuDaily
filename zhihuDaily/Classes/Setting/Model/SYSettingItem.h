//
//  SYSettingItem.h
//  zhihuDaily
//
//  Created by yang on 16/2/27.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Operation)();

@interface SYSettingItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) Operation operation;


+ (instancetype)itemWithTitle:(NSString *)title operation:(Operation)operation;
@end
