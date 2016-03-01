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


@interface SYCacheTool : NSObject

+ (void)cacheCollectedStoryId:(long long)storyid;
+ (NSArray<NSNumber *> *)queryCollectedStroy;


+ (SYBeforeStoryResult *)queryStoryListWithDateString:(NSString *)dateString;
+ (void)cacheStoryListWithObject:(SYBeforeStoryResult *)respObject;

+ (SYDetailStory *)queryStoryWithId:(long long)storyid;
+ (void)cacheStoryWithObject:(SYDetailStory *)story;


+ (void)cacheTheme:(int)themeid;

+ (void)cacheThemeSotryListWithId:(int)themeid respObject:(NSArray<SYStory *> *)respObject;
+ (NSArray<SYStory *> *)queryBeforeStoryListWithId:(int)themeid storyId:(long long)storyId;



+ (NSArray *)queryTables;

+ (NSUInteger)cachedSize;

+ (NSUInteger)imageSize;

+ (NSUInteger)dataSize;

+ (void)clearCache;


@end
