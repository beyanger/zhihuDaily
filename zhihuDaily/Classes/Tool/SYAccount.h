//
//  SYAccount.h
//  zhihuDaily
//
//  Created by yang on 16/2/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYAccount : NSObject

@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *avatar;

+ (instancetype)sharedAccount;

@end
