//
//  SYSettingGroup.h
//  zhihuDaily
//
//  Created by yang on 16/2/27.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYSettingItem.h"
@interface SYSettingGroup : NSObject
@property (nonatomic, strong) NSArray<SYSettingItem *> *items;
@end
