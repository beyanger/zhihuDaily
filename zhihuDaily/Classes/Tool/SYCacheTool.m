//
//  SYCachedTool.m
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYCacheTool.h"
#import "fmdb.h"
#import "SDImageCache.h"


static FMDatabaseQueue *_zhihu_queue;

@implementation SYCacheTool


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        NSString *dbName = [NSString stringWithFormat:@"%@.cached.sqlite", @"zhihu"];
        
        NSString *pathName = [path stringByAppendingPathComponent:dbName];
        
        _zhihu_queue = [FMDatabaseQueue databaseQueueWithPath:pathName];
        [_zhihu_queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_storylist (date INTEGER PRIMARY KEY, storylist BLOB);"];
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_story (storyid INTEGER PRIMARY KEY, story BLOB);"];
        }];
    });
    
}

+ (FMDatabaseQueue *)queue {
     return _zhihu_queue;
}


+ (SYBeforeStoryResult *)queryStoryListWithDateString:(NSString *)dateString {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMdd";
    });
    
    NSDate *date = [formatter dateFromString:dateString];
    date = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
    dateString = [formatter stringFromDate:date];
    
    __block NSData *data = nil;

    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"SELECT storylist FROM t_storylist WHERE date = ?", dateString];
            // 这里结果应该只有一个
            while (rs.next) {
                data = [rs dataForColumnIndex:0];
            }
        }];
    });
    

    
    if (data.length > 0) {
        SYBeforeStoryResult *result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return result;
    }
    
    
    return nil;
}

+ (void)cacheStoryListWithObject:(SYBeforeStoryResult *)respObject {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 进行缓存数据
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:respObject];
        NSString *dateString = respObject.date;
        [[self queue] inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"INSERT OR IGNORE INTO t_storylist (date, storylist) VALUES (?, ?);", dateString, data];
        }];
    });
}

+ (SYDetailStory *)queryStoryWithId:(long long)storyid {
    
    __block NSData *data = nil;
    
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"SELECT story FROM t_story WHERE storyid = ?", @(storyid)];
            // 这里结果只有一个
            while (rs.next) {
                data = [rs dataForColumnIndex:0];
            }
        }];
    });
    if (data.length > 0) {

        SYDetailStory *story = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return story;
    }
    return nil;
}

+ (void)cacheStoryWithObject:(SYDetailStory *)story {
    // 进行缓存数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:story];
        
        [[self queue] inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"INSERT OR IGNORE INTO t_story (storyid, story) VALUES (?, ?);", @(story.id), data];
        }];
    });
}


+ (NSArray *)queryTables {
    NSMutableArray *tables = [@[] mutableCopy];
    
    [[self queue] inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT name FROM sqlite_master WHERE type = ?;", @"table"];
        while (rs.next) {
            [tables addObject:[rs stringForColumnIndex:0]];
        }
        
    }];
    
    return tables;
}


+ (void)cacheTheme:(int)themeid {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS theme_%d (storyid INTEGER PRIMARY KEY, story BLOB)", themeid];
        [[self queue] inDatabase:^(FMDatabase *db) {
            [db executeUpdate:sql];
        }];
    });
    
}

+ (void)cacheThemeSotryListWithId:(int)themeid respObject:(NSArray<SYStory *>*)respObject {
    // 进行缓存数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *sql = [NSString stringWithFormat:@"INSERT OR IGNORE INTO theme_%d (storyid, story) VALUES (?, ?);", themeid];
        [[self queue] inDatabase:^(FMDatabase *db) {
            for (SYStory *story in respObject) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:story];
                [db executeUpdate:sql, @(story.id), data];
            }
        }];
    });
    
}

+ (NSArray<SYStory *> *)queryBeforeStoryListWithId:(int)themeid storyId:(long long)storyId {
    NSMutableArray *storyArray = [@[] mutableCopy];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *sql = [NSString stringWithFormat:@"SELECT story FROM theme_%d WHERE storyid < ? ORDER BY storyid DESC LIMIT 20;", themeid];
        [[self queue] inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:sql, @(storyId)];
            while (rs.next) {
                NSData *data = [rs dataForColumnIndex:0];
                SYStory *story = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [storyArray addObject:story];
            }
        }];
    });
    return storyArray;
}



+ (NSUInteger)cachedSize {
    return [self imageSize] + [self dataSize];
}

+ (NSUInteger)imageSize {
    return [[SDImageCache sharedImageCache] getSize];
}

+ (NSUInteger)dataSize {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dbName = [NSString stringWithFormat:@"%@.cached.sqlite", @"zhihu"];
    
    NSString *pathName = [path stringByAppendingPathComponent:dbName];
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:pathName error:nil];
    return attrs.fileSize;
}

+ (void)clearCache {
    [[SDImageCache sharedImageCache] clearDisk];
    [self clearCacheTables];
}


+ (void)clearCacheTables {
    NSArray *tableArray = [self queryTables];
    [[self queue] inDatabase:^(FMDatabase *db) {
        for (NSString *table in tableArray) {
            NSString *sql = [@"DELETE FROM " stringByAppendingString:table];
            [db executeUpdate:sql];
        }
    }];
}




@end
