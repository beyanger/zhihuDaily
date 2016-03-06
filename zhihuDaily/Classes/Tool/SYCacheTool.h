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


+ (void)cancelCollectedWithUser:(NSString *)name story:(SYStory *)story;
+ (BOOL)queryCollectedStatusWithUser:(NSString *)name Story:(SYStory *)story;
+ (NSArray<SYStory *> *)queryCollectedStroyWithUser:(NSString *)name;

+ (void)cacheCollectionWithUser:(NSString *)name story:(SYStory *)story;



// 返回包含主题是否被收藏信息
+ (void)cacheThemeWithTheme:(SYTheme *)theme;
+ (NSArray *)queryThemeWithUser:(NSString *)user;


+ (void)cacheCollectionThemeWithUser:(NSString *)user theme:(SYTheme *)theme;
+ (void)cancelCollectedThemeWithUser:(NSString *)user theme:(SYTheme *)theme;



+ (SYBeforeStoryResult *)queryStoryListWithDateString:(NSString *)dateString;
+ (void)cacheStoryListWithObject:(SYBeforeStoryResult *)respObject;

+ (SYDetailStory *)queryStoryWithId:(long long)storyid;
+ (void)cacheStoryWithObject:(SYDetailStory *)story;


+ (void)cacheThemeStoryListWithId:(int)themeid respObject:(NSArray<SYStory *> *)respObject;
+ (NSArray<SYStory *> *)queryBeforeStoryListWithId:(int)themeid storyId:(long long)storyId;



+ (BOOL)loginWithName:(NSString *)name password:(NSString *)password;


+ (NSArray *)queryTables;

+ (NSUInteger)cachedSize;

+ (NSUInteger)imageSize;

+ (unsigned long long)dataSize;

+ (void)clearCache;


@end
