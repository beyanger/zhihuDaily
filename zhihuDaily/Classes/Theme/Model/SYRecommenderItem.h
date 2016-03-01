//
//  SYRecommenderItem.h
//  zhihuDaily
//
//  Created by yang on 16/3/1.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYRecommender.h"

@interface SYRecommenderItem : NSObject
@property (nonatomic, assign) long index;
@property (nonatomic, strong) NSArray *recommenders;

@end
