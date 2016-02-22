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
@property (nonatomic, copy) NSString *name;

/**
 *  是否id
 */
@property (nonatomic, assign) int id;





- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)itemWithDictionary:(NSDictionary *)dict;
@end
