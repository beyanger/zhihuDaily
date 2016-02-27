//
//  SYComment.h
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYComment : NSObject

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) long time;
@property (nonatomic, assign) long id;
@property (nonatomic, assign) long likes;

@property (nonatomic, assign) BOOL isLong;


@end
