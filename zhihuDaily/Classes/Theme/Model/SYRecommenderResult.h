//
//  SYRecommenderResult.h
//  zhihuDaily
//
//  Created by yang on 16/3/1.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYEditor.h"
#import "SYRecommender.h"
#import "SYRecommenderItem.h"

@interface SYRecommenderResult : NSObject
@property (nonatomic, strong) NSArray *editors;

@property (nonatomic, strong) NSArray<SYRecommenderItem *> *items;
@end
