//
//  SYCachedTool.h
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYBeforeStoryResult.h"
#import "SYDetailStory.h"
#import "SYStory.h"
#import "SYTheme.h"


@interface SYCacheTool : NSObject

+ (void)cacheCollectionWithStory:(SYStory *)story;
+ (NSArray<SYStory *> *)queryCollectedStroy;
+ (BOOL)queryCollectedStatusWithStory:(SYStory *)story;

+ (void)cancelCollectedWithStory:(SYStory *)story;

+ (void)cacheCollectionWithTheme:(SYTheme *)theme;
+ (void)cancelCollectedWithTheme:(SYTheme *)theme;
+ (NSMutableArray *)queryCollectedTheme;


+ (SYBeforeStoryResult *)queryStoryListWithDateString:(NSString *)dateString;
+ (void)cacheStoryListWithObject:(SYBeforeStoryResult *)respObject;

+ (SYDetailStory *)queryStoryWithId:(long long)storyid;
+ (void)cacheStoryWithObject:(SYDetailStory *)story;


//这里是创建主题表，以后有有该主题的新闻，则缓存到对应的表中
+ (void)cacheTheme:(int)themeid;

+ (void)cacheThemeSotryListWithId:(int)themeid respObject:(NSArray<SYStory *> *)respObject;
+ (NSArray<SYStory *> *)queryBeforeStoryListWithId:(int)themeid storyId:(long long)storyId;

// denglu shuju ku ...
+ (BOOL)loginWithName:(NSString *)name password:(NSString *)password;




+ (NSArray *)queryTables;

+ (NSUInteger)cachedSize;

+ (NSUInteger)imageSize;

+ (NSUInteger)dataSize;

+ (void)clearCache;


@end
