//
//  SYBeforeStoryResult.h
//  zhihuDaily
//
//  Created by yang on 16/2/25.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYStory.h"
@interface SYBeforeStoryResult : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSArray<SYStory *> *stories;
@end
