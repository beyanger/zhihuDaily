//
//  SYBeforeStoryResult.m
//  zhihuDaily
//
//  Created by yang on 16/2/25.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYBeforeStoryResult.h"
#import "MJExtension.h"
#import "SYStory.h"


@implementation SYBeforeStoryResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"stories" : @"SYStory"};
}


MJCodingImplementation
@end
