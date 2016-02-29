//
//  SYCommentParam.h
//  zhihuDaily
//
//  Created by yang on 16/2/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYCommentParam : NSObject
@property (nonatomic, assign) long long id;
/**长评论总数*/
@property (nonatomic, assign) long long_comments;

/**短评论总数*/
@property (nonatomic, assign) long short_comments;

+ (instancetype)commentWithId:(long long)storyid longComments:(long)longComment shortComment:(long)shortComment;


@end
