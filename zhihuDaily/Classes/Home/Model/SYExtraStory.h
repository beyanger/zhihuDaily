//
//  SYExtraStory.h
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYExtraStory : NSObject

/**长评论总数*/
@property (nonatomic, assign) long long_comments;
/**点赞总数*/
@property (nonatomic, assign) long popularity;
/**短评论总数*/
@property (nonatomic, assign) long short_comments;
/**评论总数*/
@property (nonatomic, assign) long comments;


@end
