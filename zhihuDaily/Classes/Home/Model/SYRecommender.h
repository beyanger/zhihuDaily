//
//  SYRecommender.h
//  zhihuDaily
//
//  Created by yang on 16/2/28.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYRecommender : NSObject

@property (nonatomic, copy) NSString *bio;

@property (nonatomic, copy) NSString *zhihu_url_token;

@property (nonatomic, assign) long id;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *name;



@end
