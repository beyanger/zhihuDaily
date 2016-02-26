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

+ (FMDatabaseQueue *)queue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        NSString *dbName = [NSString stringWithFormat:@"%@.cached.sqlite", @"zhihu"];
        
        NSString *pathName = [path stringByAppendingPathComponent:dbName];
        
        _zhihu_queue = [FMDatabaseQueue databaseQueueWithPath:pathName];
        [_zhihu_queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_storylist (date INTEGER PRIMARY KEY, storylist TEXT);"];
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_story (storyid INTEGER PRIMARY KEY, story TEXT);"];
        }];
    });
    return _zhihu_queue;
}


+ (id)queryStoryListWithDateString:(NSString *)dateString {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMdd";
    });
    
    NSDate *date = [formatter dateFromString:dateString];
    date = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
    dateString = [formatter stringFromDate:date];
    
    
    __block NSString *jsonString = @"";
    // 先从数据库中查找，是否存在
    [[self queue] inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT storylist FROM t_storylist WHERE date = ?", dateString];
        while (rs.next) {
            jsonString =  [rs stringForColumnIndex:0];
        }
    }];
    
    if (jsonString.length > 0) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        return response;
    }
    return nil;
}



+ (void)cacheStoryListWithObject:(id)respObject {

    // 进行缓存数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:respObject options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *dateString = respObject[@"date"];
    [[self queue] inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT INTO t_storylist (date, storylist) VALUES (?, ?);", dateString, jsonString];
    }];
}

+ (id)queryStoryWithId:(long long)storyid {
    
    __block NSString *jsonString = @"";
    // 先从数据库中查找，是否存在
    [[self queue] inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT story FROM t_story WHERE storyid = ?", @(storyid)];
        while (rs.next) {
            jsonString =  [rs stringForColumnIndex:0];
        }
    }];
    
    if (jsonString.length > 0) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        return response;
    }
    return nil;
}

+ (void)cacheStoryWithObject:(id)respObject {
    // 进行缓存数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:respObject options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    long long storyid = [respObject[@"id"] longLongValue];
    
    [[self queue] inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT INTO t_story (storyid, story) VALUES (?, ?);", @(storyid), jsonString];
    }];
}




+ (void)clearCachedStroy {
    [[self queue] inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM t_storylist"];
        [db executeUpdate:@"DELETE FROM t_story"];
    }];
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
    [self clearCachedStroy];
}



@end
