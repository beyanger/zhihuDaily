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
#import "SYAccount.h"
#import "NSString+MD5.h"

static FMDatabaseQueue *_zhihu_queue;

@implementation SYCacheTool


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        NSString *dbName = [NSString stringWithFormat:@"%@.cached.sqlite", @"zhihu"];
        NSString *pathName = [path stringByAppendingPathComponent:dbName];
        
        NSLog(@"---> %@", path);
        
        _zhihu_queue = [FMDatabaseQueue databaseQueueWithPath:pathName];
        [_zhihu_queue inDatabase:^(FMDatabase *db) {
            // 缓存主页列表，以日期作为 primary key，每日列表为表项
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_homelist (id INTEGER PRIMARY KEY AUTOINCREMENT, date INTEGER UNIQUE, storylist BLOB);"];
            // 缓存具体的story， storyid作为primary key， story内容为表项
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_detailstory (id INTEGER PRIMARY KEY AUTOINCREMENT,  storyid INTEGER UNIQUE, story BLOB);"];
            
            
            // 缓存主题下的故事，storyid为primary key，同时记录该story的themeid
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_themelist (id INTEGER PRIMARY KEY AUTOINCREMENT, storyid INTEGER UNIQUE, themeid INTEGER, story BLOB);"];

            // 已登录过用户表，登录过程为，当用户为新用户时，第一次登录输入的密码作为用户密码，并登录成功，当用户再次登录时，必须输入与第一次登录时的密码相同，否则登录不成功
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS ct_user (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE, password TEXT);"];
            
            
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_theme (themeid INTEGER PRIMARY KEY, theme BLOB);"];
            //创建联合 unique约束
            // 创建一个公共表，添加 storyid和name的联合唯一约束...
            NSString *ct_story = @"CREATE TABLE IF NOT EXISTS ct_story (id INTEGER PRIMARY KEY AUTOINCREMENT, user TEXT, storyid INTEGER, story BLOB, CONSTRAINT collected_story UNIQUE(user, storyid));";

            //记录用户收藏主题情况
            NSString *ct_theme = @"CREATE TABLE IF NOT EXISTS ct_theme (id INTEGER PRIMARY KEY AUTOINCREMENT, user TEXT, themeid INTEGER, is_collected BOOL, CONSTRAINT collected_theme UNIQUE(user, themeid));";
            
            [db executeUpdate:ct_story];
            [db executeUpdate:ct_theme];
            
        }];
    });
    
}

+ (FMDatabaseQueue *)queue {
     return _zhihu_queue;
}


+ (void)cacheCollectionWithUser:(NSString *)name story:(SYStory *)story {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            NSString *sql = @"REPLACE INTO ct_story (user, storyid, story) VALUES (?, ?, ?);";
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:story];
            
            [db executeUpdate:sql, name, @(story.id), data];
        }];
    });
}
+ (NSArray<SYStory *> *)queryCollectedStroyWithUser:(NSString *)name {
    NSMutableArray *storyArray = [@[] mutableCopy];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            NSString *sql = @"SELECT story FROM ct_story WHERE user = ? ORDER BY id DESC;";
            FMResultSet *rs =  [db executeQuery:sql, name];
            while (rs.next) {
                NSData *data = [rs dataForColumnIndex:0];
                SYStory *story = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [storyArray addObject:story];
            }
            [rs close];
        }];
    });

    return storyArray.count > 0 ? storyArray : nil;
}

+ (BOOL)queryCollectedStatusWithUser:(NSString *)name Story:(SYStory *)story {
    __block BOOL result = NO;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            NSString *sql = @"SELECT story FROM ct_story WHERE user = ? AND storyid = ?;";
            FMResultSet *rs =  [db executeQuery:sql, name, @(story.id)];
            result = rs.next;
            [rs close];
         }];
    });
    return result;
}

+ (void)cancelCollectedWithUser:(NSString *)name story:(SYStory *)story {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            NSString *sql = @"DELETE FROM ct_story WHERE user = ? AND storyid = ?;";
            [db executeUpdate:sql, name, @(story.id)];
        }];
    });
}

+ (void)updateCollectedThemeWithUser:(NSString *)user themeid:(int)themeid type:(BOOL)type {
    NSLog(@"update id: %d, %d", themeid, type);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            //NSString *sql = [NSString stringWithFormat:@"UPDATE ct_theme SET is_collected = ? WHERE user = ? AND themeid = ?;"];
            NSString *sql = @"REPLACE INTO ct_theme (user, themeid, is_collected) VALUES (?, ?, ?)";
            [db executeUpdate:sql, user, @(themeid), @(type)];
        }];
    });
}



+ (void)cacheThemeWithTheme:(SYTheme *)theme {
    NSLog(@"---> %@", theme.name);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            NSString *sql = @"REPLACE INTO t_theme (themeid, theme) VALUES (?, ?);";
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:theme];
            [db executeUpdate:sql, @(theme.id), data];
        }];
    });
}

+ (void)cacheCollectionThemeWithUser:(NSString *)user theme:(SYTheme *)theme {
    [self updateCollectedThemeWithUser:user themeid:theme.id type:YES];
}

+ (void)cancelCollectedThemeWithUser:(NSString *)user theme:(SYTheme *)theme {
    [self updateCollectedThemeWithUser:user themeid:theme.id type:NO];
}

+ (NSArray *)queryThemeWithUser:(NSString *)user {
    NSMutableArray *themeArray = [@[] mutableCopy];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            NSString *allTheme = @"SELECT themeid, theme FROM t_theme;";
            FMResultSet *trs = [db executeQuery:allTheme];
            NSMutableDictionary *dict = [@{} mutableCopy];
            while (trs.next) {
                int themeid = [trs intForColumnIndex:0];
                SYTheme *theme = [NSKeyedUnarchiver unarchiveObjectWithData:[trs dataForColumnIndex:1]];
                dict[@(themeid)] = theme;
                
            }
            [trs close];
//            NSString *sql = [NSString stringWithFormat:@"SELECT ct_theme.themeid, is_collected FROM theme INNER JOIN ct_theme WHERE  user = ? AND is_collected = 1 AND theme.themeid = ct_theme.themeid;"];
            
            NSString *sql = @"SELECT themeid FROM ct_theme WHERE user = ? AND is_collected = 1;";
            FMResultSet *rs = [db executeQuery:sql, user];
            while (rs.next) {
                int themeid = [rs intForColumnIndex:0];
                SYTheme *theme = dict[@(themeid)];
                theme.isCollected = YES;
            }
            [rs close];
            [themeArray addObjectsFromArray:dict.allValues];
        }];
    });
    return themeArray.count>0 ? themeArray : nil;
}
/**
 *  <#Description#>
 *
 *  @param dateString <#dateString description#>
 *
 *  @return <#return value description#>
 */
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
            FMResultSet *rs = [db executeQuery:@"SELECT storylist FROM t_homelist WHERE date = ?", dateString];
            // 这里结果应该只有一个
            if (rs.next) data = [rs dataForColumnIndex:0];
            [rs close];
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
            [db executeUpdate:@"INSERT OR IGNORE INTO t_homelist (date, storylist) VALUES (?, ?);", dateString, data];
        }];
    });
}

+ (SYDetailStory *)queryStoryWithId:(long long)storyid {
    
    __block NSData *data = nil;
    
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self queue] inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"SELECT story FROM t_detailstory WHERE storyid = ?", @(storyid)];
            // 这里结果只有一个
            if (rs.next) data = [rs dataForColumnIndex:0];
            [rs close];
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
            [db executeUpdate:@"INSERT OR IGNORE INTO t_detailstory (storyid, story) VALUES (?, ?);", @(story.id), data];
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
        [rs close];
    }];
    
    return tables;
}


+ (void)cacheThemeStoryListWithId:(int)themeid respObject:(NSArray<SYStory *>*)respObject {
    // 进行缓存数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *sql = [NSString stringWithFormat:@"INSERT OR IGNORE INTO t_themelist (storyid, themeid, story) VALUES (?, ?, ?);"];
        [[self queue] inDatabase:^(FMDatabase *db) {
            for (SYStory *story in respObject) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:story];
                [db executeUpdate:sql, @(story.id), @(themeid), data];
            }
        }];
    });
    
}

+ (NSArray<SYStory *> *)queryBeforeStoryListWithId:(int)themeid storyId:(long long)storyId {
    NSMutableArray *storyArray = [@[] mutableCopy];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *sql = @"SELECT story FROM t_themelist WHERE themeid=? AND storyid < ? ORDER BY storyid DESC LIMIT 20;";
        [[self queue] inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:sql, @(themeid), @(storyId)];
            while (rs.next) {
                NSData *data = [rs dataForColumnIndex:0];
                SYStory *story = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [storyArray addObject:story];
            }
            [rs close];
        }];
    });
    return storyArray;
}


+ (BOOL)loginWithName:(NSString *)name password:(NSString *)password {
    __block BOOL success = NO;
    NSString *sql = @"SELECT password FROM ct_user WHERE name = ?;";
    [[self queue] inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql, name];
        BOOL existFlag = NO;
        if (rs.next) {
            existFlag = YES;
            NSString *pwd = [rs objectForColumnIndex:0];
            if ([pwd isEqualToString:password]) {
                success = YES;
            }
        }
        [rs close];
        // 新用户登录
        if (!existFlag) {
            success = YES;
            NSString *insert = @"INSERT INTO ct_user (name, password) VALUES (?, ?);";
            [db executeUpdate:insert, name, password];
        }
    }];
    return success;
}



+ (NSUInteger)cachedSize {
    return [self imageSize] + [self dataSize];
}

+ (NSUInteger)imageSize {
    return [[SDImageCache sharedImageCache] getSize];
}

+ (unsigned long long)dataSize {
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
            // 这里只需要清除缓存的主页故事和主题故事， 不需要清除收藏数据
            if (![table hasPrefix:@"ct_"]) {
                NSString *sql = [@"DELETE FROM " stringByAppendingString:table];
                [db executeUpdate:sql];
            }
        }
    }];
}

@end
