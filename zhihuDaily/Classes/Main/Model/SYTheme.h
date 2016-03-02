//
//  SYMenuItem.h
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYTheme : NSObject

@property (nonatomic, copy) NSString *thumbnail;

/**
 *  title
 */
@property (nonatomic, copy) NSString *name;

/**
 *  
 */
@property (nonatomic, assign) int id;

/**
 *  是否被收藏
 */
@property (nonatomic, assign) BOOL isCollected;


@end
