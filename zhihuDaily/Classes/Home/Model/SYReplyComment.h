//
//  SYReplyComment.h
//  zhihuDaily
//
//  Created by yang on 16/3/4.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYReplyComment : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) int status;

@property (nonatomic, assign) long id;

@property (nonatomic, copy) NSString *author;


@end
