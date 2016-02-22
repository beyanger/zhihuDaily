//
//  SYMenuItem.h
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYMenuItem : NSObject
/**
 *  title
 */
@property (nonatomic, copy) NSString *title;

/**
 *  是否被收藏
 */
@property (nonatomic, assign) BOOL collected;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)itemWithDictionary:(NSDictionary *)dict;
@end
