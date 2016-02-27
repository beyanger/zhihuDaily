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
    
    
    NSMutableString *jsonString = [@"" mutableCopy];
    // 先从数据库中查找，是否存在
    [[self queue] inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT storylist FROM t_storylist WHERE date = ?", dateString];
        // 这里结果应该只有一个
        while (rs.next) {
            [jsonString appendString:[rs stringForColumnIndex:0]];
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
    
    NSMutableString *jsonString = [@"" mutableCopy];
    
    [[self queue] inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT story FROM t_story WHERE storyid = ?", @(storyid)];
        // 这里结果只有一个
        while (rs.next) {
            [jsonString appendString:[rs stringForColumnIndex:0]];
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
    
    [[self queue] inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT INTO t_story (storyid, story) VALUES (?, ?);", respObject[@"id"], jsonString];
    }];
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
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS theme_%d (storyid INTEGER PRIMARY KEY, story TEXT)", themeid];
    [[self queue] inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}

+ (void)cacheThemeSotryListWithId:(int)themeid respObject:(id)respObject {

    // 进行缓存数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:respObject options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO theme_%d (storyid, story) VALUES (?, ?);", themeid];
    
    [[self queue] inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql, respObject[@"id"], jsonString];
    }];
}

+ (id)queryBeforeStoryListWithId:(int)themeid storyId:(long long)storyId {
    NSString *sql = [NSString stringWithFormat:@"SELECT story FROM theme_%d WHERE storyid < ? ORDER BY storyid DESC LIMIT 20;", themeid];
    
    NSMutableArray *storyArray = [@[] mutableCopy];
    [[self queue] inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql, @(storyId)];
        while (rs.next) {
            NSString *jsonString = [rs stringForColumnIndex:0];
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            [storyArray addObject:response];
        }
    }];
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
    [[self queue] inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM t_storylist"];
        [db executeUpdate:@"DELETE FROM t_story"];
    }];

    NSArray *tableArray = [self queryTables];
    [[self queue] inDatabase:^(FMDatabase *db) {
        for (NSString *table in tableArray) {
            NSString *sql = [@"DELETE FROM " stringByAppendingString:table];
            [db executeUpdate:sql];
        }
    }];
}




@end
