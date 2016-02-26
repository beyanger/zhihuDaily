//
//  SYDetailTool.h
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSHttpTool.h"

#import "MJExtension.h"

#import "SYDetailStory.h"
#import "SYExtraStory.h"
#import "SYLastestParamResult.h"
#import "SYComment.h"
#import "SYTheme.h"
#import "SYBeforeStoryResult.h"
#import "SYEditor.h"
#import "SYThemeItem.h"
#import "SYVersion.h"
#import "SYCacheTool.h"

typedef void(^Completed)(id obj);

@interface SYZhihuTool : NSObject
/**
 *  获取story详情
 */
+ (void)getDetailWithId:(long long)storyid completed:(Completed)completed;


/**
 *  获取故事额外信息，如评论数，赞数
 */
+ (void)getExtraWithId:(long long)storyid completed:(Completed)completed;

/**
 *  获取最新的story
 */
+ (void)getLastestStoryWithCompleted:(Completed)completed;

/**
 *  获取story的长评论
 */
+ (void)getLongCommentsWithId:(long long)storyid completed:(Completed)completed;
/**
 *  获取story的短评论
 */
+ (void)getShortCommentsWithId:(long long)storyid completed:(Completed)completed;
/**
 *  获取所有的 theme
 */
+ (void)getThemesWithCompleted:(Completed)completed;
/**
 *  获取LaunchImage
 */
+ (void)getLauchImageWithCompleted:(Completed)completed;
/**
 *  根据 NSDate类型时间获取当日之前的story
 */
+ (void)getBeforeStroyWithDate:(NSDate *)date completed:(Completed)completed;
/**
 *  根据 时间串(20151204)获取当日之前的story
 */
+ (void)getBeforeStroyWithDateString:(NSString *)dateString completed:(Completed)completed;

/**
 *  根据 主题 id 获取主题详情
 */
+ (void)getThemeWithThemeId:(int)themeId completed:(Completed)completed;


+ (void)queryAppWithVersion:(NSString *)version  Completed:(Completed)completed;

@end
