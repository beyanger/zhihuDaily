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
#import "SYAccount.h"


typedef void (^Completed)(id obj);

typedef void (^Success)();
typedef void (^Failure)();

@interface SYZhihuTool : NSObject

/**
 *  获取LaunchImage
 */
+ (void)getLaunchImageWithCompleted:(Completed)completed failure:(Failure)failure;


+ (void)queryAppWithVersion:(NSString *)version  completed:(Completed)completed;



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

+ (void)getBeforeLongCommentsWithId:(long long)storyid commentid:(long)commentid completed:(Completed)completed;

/**
 *  获取story的短评论
 */
+ (void)getShortCommentsWithId:(long long)storyid completed:(Completed)completed;
+ (void)getBeforeShortCommentsWithId:(long long)storyid commentid:(long)commentid completed:(Completed)completed;


/**
 *  获取所有的 theme //主题列表相对稳定，所以可以缓存
 */
+ (void)getThemesWithCompleted:(Completed)completed;

// 收藏或者取消专栏
+ (void)collectedWithTheme:(SYTheme *)theme;
+ (void)cancelCollectedWithTheme:(SYTheme *)theme;

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

/**
 *  获取某个专栏story之前的story
 *
 */
+ (void)getBeforeThemeStoryWithId:(int)themeid storyId:(long long)storyId completed:(Completed)completed;
/**
 *  获取story的推荐者
 */
+ (void)getStoryRecommendersWithId:(long long)storyid completed:(Completed)completed;


// 获取当前用户的收藏的故事, 收藏/取消/查询收藏状态
+ (void)getColltedStoriesWithCompleted:(Completed)completed;
+ (void)collectedWithStroy:(SYStory *)story;
+ (void)cancelCollectedWithStroy:(SYStory *)story;
+ (BOOL)queryCollectedStatusWithStory:(SYStory *)story;


+ (NSString *)getEditorHomePageWithEditor:(SYEditor *)editor;
+ (NSString *)getRecommenderHomePageWithRecommender:(SYRecommender *)recommender;

/**
 *  用户登录
 */
+ (void)loginWithName:(NSString *)name password:(NSString *)password success:(Success)success failure:(Failure)failure;

@end
