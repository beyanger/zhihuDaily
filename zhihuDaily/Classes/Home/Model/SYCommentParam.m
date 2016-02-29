//
//  SYCommentParam.m
//  zhihuDaily
//
//  Created by yang on 16/2/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYCommentParam.h"

@implementation SYCommentParam


+ (instancetype)commentWithId:(long long)storyid longComments:(long)longComment shortComment:(long)shortComment {
    SYCommentParam *param = [[self alloc] init];
    param.id = storyid;
    param.long_comments = longComment;
    param.short_comments = shortComment;
    return param;
}

@end
