//
//  SYAccount.m
//  zhihuDaily
//
//  Created by yang on 16/2/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYAccount.h"


@implementation SYAccount

+ (instancetype)sharedAccount {
    
    static SYAccount *_account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _account = [[self alloc] init];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _account.isLogin = [ud boolForKey:@"isLogin"];
    });
    return _account;
}


- (void)setIsLogin:(BOOL)isLogin {
    _isLogin = isLogin;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:isLogin forKey:@"isLogin"];
}

- (NSString *)avatar {
    return self.isLogin ? _avatar : @"http://i13.tietuku.com/e8a20966f7153539.png";
}

- (NSString *)name {
    return self.isLogin ? _name : @"请登录";
}



@end
