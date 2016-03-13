//
//  SYDetailTool.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

// 本文件中API大部分来自于
// https://github.com/izzyleung/ZhihuDailyPurify/wiki/%E7%9F%A5%E4%B9%8E%E6%97%A5%E6%8A%A5-API-%E5%88%86%E6%9E%90

#import "SYZhihuTool.h"
#import "fmdb.h"
#import "NSString+MD5.h"



//推荐者 http://news-at.zhihu.com/api/4/story/7101963(storyid)/recommenders
// 编辑的主页： http://news-at.zhihu.com/api/4/editor/79(这里填入editor的id)/profile-page/ios

@implementation SYZhihuTool


+ (void)load {
    [SYDetailStory mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"recommenders":@"SYRecommender"};
    }];
    
    [SYLastestParamResult mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"top_stories":@"SYStory", @"stories":@"SYStory"};
    }];
    
    [SYBeforeStoryResult mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"stories":@"SYStory"};
    }];
    
    [SYThemeItem mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"stories": @"SYStory", @"editors":@"SYEditor"};
    }];
    
    [SYThemeItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"desc":@"description"};
    }];
    
    [SYRecommenderResult mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"editors": @"SYEditor", @"items":@"SYRecommenderItem"};
    }];
    [SYRecommenderItem mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"recommenders":@"SYRecommender"};
    }];
}


+ (void)getLaunchImageWithCompleted:(Completed)completed failure:(Failure)failure {
    NSString *launchImgUrl = @"http://news-at.zhihu.com/api/4/start-image/720*1184";
    
    [YSHttpTool GETWithURL:launchImgUrl params:nil success:^(id responseObject) {
        NSString *urlStr = responseObject[@"img"];
        !completed ? : completed(urlStr);
    } failure:^(NSError *error) {
        !failure ? :failure();
    }];
}



+ (void)queryAppWithVersion:(NSString *)version  completed:(Completed)completed {
    
    // http://news-at.zhihu.com/api/4/version/android/2.3.0
    // http://news-at.zhihu.com/api/4/version/ios/2.3.0
    NSString *versionUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/version/ios/%@", version];
    
    [YSHttpTool GETWithURL:versionUrl params:nil success:^(id responseObject) {
        SYVersion *ver = [SYVersion mj_objectWithKeyValues:responseObject];
        !completed ? : completed(ver);
    } failure:nil];
}

+ (void)getDetailWithId:(long long)storyid completed:(Completed)completed {
 
    
    
    
    
    SYDetailStory *story = [SYCacheTool queryStoryWithId:storyid];
    if (story) {
        !completed ? : completed(story);
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%lld", storyid];

    [YSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        SYDetailStory *ds = [SYDetailStory mj_objectWithKeyValues:responseObject];
        
        ds.htmlStr = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>", ds.css[0], ds.body];
        
        !completed ? : completed(ds);
    
        [SYCacheTool cacheStoryWithObject:ds];
        
    } failure:nil];
    
    
}

+ (void)getExtraWithId:(long long)storyid completed:(Completed)completed {
    NSString *url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story-extra/%lld",storyid];
    [YSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        SYExtraStory *es = [SYExtraStory mj_objectWithKeyValues:responseObject];
        !completed ? : completed(es);
    } failure:nil];
    
}


+ (void)getLastestStoryWithCompleted:(Completed)completed {
    // 返回结果相同
    //NSString *storyUrl = @"http://news-at.zhihu.com/api/4/stories/latest";
    NSString *url = @"http://news-at.zhihu.com/api/4/news/latest";

    [YSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        // 当日的story 列表不需要缓存
        SYLastestParamResult *result = [SYLastestParamResult mj_objectWithKeyValues:responseObject];
        !completed ? : completed(result);
    } failure:nil];
}

+ (void)getLongCommentsWithId:(long long)storyid completed:(Completed)completed {
    NSString *longCommentUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%lld/long-comments", storyid];
    
    [YSHttpTool GETWithURL:longCommentUrl params:nil success:^(id responseObject) {
        NSArray<SYComment *> *comment = [SYComment mj_objectArrayWithKeyValuesArray:responseObject[@"comments"]];
        !completed ? : completed(comment);
    } failure:nil];
    
    
}
+ (void)getBeforeLongCommentsWithId:(long long)storyid commentid:(long)commentid completed:(Completed)completed {
    NSString *longBeforeUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%lld/long-comments/before/%ld", storyid, commentid];
    [YSHttpTool GETWithURL:longBeforeUrl params:nil success:^(id responseObject) {
        NSArray *comments = [SYComment mj_objectArrayWithKeyValuesArray:responseObject[@"comments"]];

        !completed ? completed : completed(comments);
        
    } failure:nil];
}

+ (void)getShortCommentsWithId:(long long)storyid completed:(Completed)completed {
    NSString *shortCommentUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%lld/short-comments", storyid];
    [YSHttpTool GETWithURL:shortCommentUrl params:nil success:^(id responseObject) {
        NSArray *comment = [SYComment mj_objectArrayWithKeyValuesArray:responseObject[@"comments"]];

        !completed ? : completed(comment);
    } failure:nil];
}


+ (void)getBeforeShortCommentsWithId:(long long)storyid commentid:(long)commentid completed:(Completed)completed {
    NSString *longBeforeUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%lld/short-comments/before/%ld", storyid, commentid];
    [YSHttpTool GETWithURL:longBeforeUrl params:nil success:^(id responseObject) {
        NSArray *comments = [SYComment mj_objectArrayWithKeyValuesArray:responseObject[@"comments"]];
        
        !completed ? completed : completed(comments);
        
    } failure:nil];
}


// 获取主题列表
+ (void)getThemesWithCompleted:(Completed)completed {
   
    
    NSArray *themeStatus = [SYCacheTool queryThemeWithUser:[SYAccount sharedAccount].name];
    if (themeStatus.count > 0) {
        !completed ? : completed(themeStatus); // 这里是带有收藏信息的,但未排序
        return;
    }
    
    NSString *themeUrl = @"http://news-at.zhihu.com/api/4/themes";
    [YSHttpTool GETWithURL:themeUrl params:nil success:^(id responseObject) {
        NSArray<SYTheme *> *themeArray = [SYTheme mj_objectArrayWithKeyValuesArray:responseObject[@"others"]];
        
        !completed ? : completed(themeArray);
        for (SYTheme *obj in themeArray) {
            [SYCacheTool cacheThemeWithTheme:obj];
        }
        
    } failure:nil];
}


+ (void)getLaunchImageWithCompleted:(Completed)completed {
    NSString *launchImgUrl = @"http://news-at.zhihu.com/api/4/start-image/720*1184";
    
    [YSHttpTool GETWithURL:launchImgUrl params:nil success:^(id responseObject) {
        NSString *urlStr = responseObject[@"img"];
        !completed ? : completed(urlStr);
    } failure:nil];

}

+ (void)getBeforeStroyWithDate:(NSDate *)date completed:(Completed)completed {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self getBeforeStroyWithDateString:dateString completed:completed];
}


+ (void)getBeforeStroyWithDateString:(NSString *)dateString completed:(Completed)completed {


    SYBeforeStoryResult *result = [SYCacheTool queryStoryListWithDateString:dateString];

    if (result) {
        !completed ? : completed(result);
        return;
    }
    
    NSString *beforeUrl = [NSString stringWithFormat:@"http://news.at.zhihu.com/api/4/news/before/%@", dateString];
    
    [YSHttpTool GETWithURL:beforeUrl params:nil success:^(id responseObject) {
        SYBeforeStoryResult *result = [SYBeforeStoryResult mj_objectWithKeyValues:responseObject];
        !completed ? : completed(result);
        [SYCacheTool cacheStoryListWithObject:result];
    } failure:nil];
}


+ (void)getThemeWithId:(int)themeId completed:(Completed)completed {
    
    NSString *themeUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%d", themeId];
    [YSHttpTool GETWithURL:themeUrl params:nil success:^(id responseObject) {
        SYThemeItem *item = [SYThemeItem mj_objectWithKeyValues:responseObject];
        !completed ? : completed(item);
    } failure:nil];
}


+ (void)getBeforeThemeStoryWithId:(int)themeid storyId:(long long)storyId completed:(Completed)completed {

    NSArray *objArray = [SYCacheTool queryBeforeStoryListWithId:themeid storyId:storyId];
    
    if (objArray.count > 0) {
        !completed ? :completed(objArray);
        return;
    }
    
    NSString *beforeUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%d/before/%lld", themeid, storyId];
    
    [YSHttpTool GETWithURL:beforeUrl params:nil success:^(id responseObject) {
        NSArray<SYStory *> *storyArray = [SYStory mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]];
    
        !completed ? :completed(storyArray);
        
        [SYCacheTool cacheThemeStoryListWithId:themeid respObject:storyArray];
        
    } failure:nil];
}


+ (void)getStoryRecommendersWithId:(long long)storyid completed:(Completed)completed {
    NSString *url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%lld/recommenders", storyid];
    [YSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        SYRecommenderResult *result = [SYRecommenderResult mj_objectWithKeyValues:responseObject];
        !completed ? : completed(result);
    } failure:nil];
}


// 获取当前用户的收藏
+ (void)getColltedStoriesWithCompleted:(Completed)completed {
    // 这里应该从网络中获取，但是当前仅仅是本地收藏
    NSArray *collted =  [SYCacheTool queryCollectedStroyWithUser:[SYAccount sharedAccount].name];
    !completed ? : completed(collted);
}

+ (BOOL)queryCollectedStatusWithStory:(SYStory *)story {
    return [SYCacheTool queryCollectedStatusWithUser:[SYAccount sharedAccount].name Story:story];
}


+ (void)collectedWithStroy:(SYStory *)story {
    [SYCacheTool cacheCollectionWithUser:[SYAccount sharedAccount].name story:story];
}

+ (void)cancelCollectedWithStroy:(SYStory *)story {
    [SYCacheTool cancelCollectedWithUser:[SYAccount sharedAccount].name story:story];
}

// 获取当前用户收藏的主题

// 收藏或者取消
+ (void)collectedWithTheme:(SYTheme *)theme {
    [SYCacheTool cacheCollectionThemeWithUser:[SYAccount sharedAccount].name theme:theme];
}
+ (void)cancelCollectedWithTheme:(SYTheme *)theme {
    [SYCacheTool cancelCollectedThemeWithUser:[SYAccount sharedAccount].name theme:theme];
}

+ (NSString *)getEditorHomePageWithEditor:(SYEditor *)editor {
    return  [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/editor/%d/profile-page/ios", editor.id];
}

+ (NSString *)getRecommenderHomePageWithRecommender:(SYRecommender *)recommender {
    return [@"http://www.zhihu.com/people/" stringByAppendingString:recommender.zhihu_url_token];
}

+ (void)loginWithName:(NSString *)name password:(NSString *)password success:(Success)success failure:(Failure)failure {
    // 这里应该
    BOOL result = [SYCacheTool loginWithName:name password:password];
    result ? (!success? :success()) : (!failure? :failure());
}

@end
