//
//  SYDetailTool.h
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSHttpTool.h"

#import "SYDetailStory.h"
#import "SYExtraStory.h"
#import "SYLastestParamResult.h"


typedef void(^Completed)(id obj);

@interface SYStoryTool : NSObject


+ (void)getDetailWithId:(long long)storyid completed:(Completed)completed;

+ (void)getExtraWithId:(long long)storyid completed:(Completed)completed;

+ (void)getLastestStoryWithCompleted:(Completed)completed;


@end
