//
//  SYCachedTool.h
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SYCacheTool : NSObject

+ (id)queryStoryListWithDateString:(NSString *)dateString;
+ (void)cacheStoryListWithObject:(id)respObject;

+ (id)queryStoryWithId:(long long)storyid;
+ (void)cacheStoryWithObject:(id)respObject;


+ (void)cacheTheme:(int)themeid;

+ (void)cacheThemeSotryListWithId:(int)themeid respObject:(id)respObject;
+ (id)queryBeforeStoryListWithId:(int)themeid storyId:(long long)storyId;



+ (NSArray *)queryTables;

+ (NSUInteger)cachedSize;

+ (NSUInteger)imageSize;

+ (NSUInteger)dataSize;

+ (void)clearCache;


@end
