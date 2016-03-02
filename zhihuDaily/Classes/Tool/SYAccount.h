//
//  SYAccount.h
//  zhihuDaily
//
//  Created by yang on 16/2/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYAccount : NSObject

@property (nonatomic, assign, readonly) BOOL isLogin;

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, copy, readonly) NSString *avatar;

+ (instancetype)sharedAccount;


// 必须等待登录过程成功，所以不需要回调block
+ (BOOL)loginWithName:(NSString *)name password:(NSString *)password;

- (void)logout;

@end
