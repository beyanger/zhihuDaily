//
//  SYParamResult.h
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYLastestParamResult : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, strong) NSArray *top_stories;

@end
