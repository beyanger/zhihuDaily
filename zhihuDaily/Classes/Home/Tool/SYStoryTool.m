//
//  SYDetailTool.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYStoryTool.h"

#import "MJExtension.h"


@implementation SYStoryTool

+ (void)getDetailWithId:(long long)storyid completed:(Completed)completed {
    NSString *url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%lld", storyid];
    [YSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        SYDetailStory *ds = [SYDetailStory mj_objectWithKeyValues:responseObject];
        ds.htmlStr = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>", ds.css[0], ds.body];
        completed(ds);
        
    } failure:nil];
    
    
}

+ (void)getExtraWithId:(long long)storyid completed:(Completed)completed {
    NSString *url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story-extra/%lld",storyid];
    [YSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        SYExtraStory *es = [SYExtraStory mj_objectWithKeyValues:responseObject];
        completed(es);
    } failure:nil];
    
}


+ (void)getLastestStoryWithCompleted:(Completed)completed {
    [SYLastestParamResult mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"top_stories":@"SYStory", @"stories":@"SYStory"};
    }];
    
    NSString *url = @"http://news-at.zhihu.com/api/4/news/latest";

    [YSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        SYLastestParamResult *result = [SYLastestParamResult mj_objectWithKeyValues:responseObject];
        completed(result);
    } failure:nil];
}

+ (void)getLongCommentsWithId:(long long)storyid completed:(Completed)completed {
    NSString *longCommentUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%lld/long-comments", storyid];
    
    NSLog(@"get .. long : %@", longCommentUrl);
    
    [YSHttpTool GETWithURL:longCommentUrl params:nil success:^(id responseObject) {
        NSArray *comment = [SYComment mj_objectArrayWithKeyValuesArray:responseObject[@"comments"]];
        completed(comment);
    } failure:nil];
    
    
}


+ (void)getShortCommentsWithId:(long long)storyid completed:(Completed)completed {
    NSString *shortCommentUrl = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%lld/short-comments", storyid];
    [YSHttpTool GETWithURL:shortCommentUrl params:nil success:^(id responseObject) {
        NSArray *comment = [SYComment mj_objectArrayWithKeyValuesArray:responseObject[@"comments"]];
        completed(comment);
    } failure:nil];
    
    
}



@end
