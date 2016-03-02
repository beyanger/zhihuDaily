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
#import "SYStory.h"
#import "SYRecommenderResult.h"
#import "SYRecommenderItem.h"
typedef void (^Completed)(id obj);

typedef void  (^Failure)();

@interface SYZhihuTool : NSObject

/**
 *  获取LaunchImage
 */
+ (void)getLauchImageWithCompleted:(Completed)completed failure:(Failure)failure;


+ (void)queryAppWithVersion:(NSString *)version  Completed:(Completed)completed;



/**
 *  获取story详情
 */
+ (void)getDetailWithId:(long long)storyid completed:(Completed)completed;


/**
 *  获取故事额外信息，如评论数，赞数
 */
+ (void)getExtraWithId:(long long)storyid completed:(Completed)completed;

/**
 *  获取最新的storyList
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
 *  根据 NSDate类型时间获取当日之前的story
 */
+ (void)getBeforeStroyWithDate:(NSDate *)date completed:(Completed)completed;
/**
 *  根据 时间串(20151204)获取当日之前的story
 */
+ (void)getBeforeStroyWithDateString:(NSString *)dateString completed:(Completed)completed;

/**
 *  根据 主题 id 获取主题 最新列表
 */
+ (void)getThemeWithId:(int)themeId completed:(Completed)completed;


+ (void)getBeforeThemeStoryWithId:(int)themeid storyId:(long long)storyId completed:(Completed)completed;

+ (void)likeStoryWithId:(long long)storyid;

+ (void)getStoryRecommendersWithId:(long long)storyid completed:(Completed)completed;


// 获取当前用户的收藏的故事, 收藏或者取消
+ (void)getColltedStoriesWithCompleted:(Completed)completed;
+ (BOOL)queryCollectedStatusWithStory:(SYStory *)story;
+ (void)collectedWithStroy:(SYStory *)story;
+ (void)cancelCollectedWithStroy:(SYStory *)story;

// 收藏或者取消
+ (void)collectedWithTheme:(SYTheme *)theme;
+ (void)cancelCollectedWithTheme:(SYTheme *)theme;



@end
