//
//  SYAccount.m
//  zhihuDaily
//
//  Created by yang on 16/2/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYAccount.h"
#import "SYZhihuTool.h"
#import "NSString+MD5.h"
@interface SYAccount () {
    BOOL _isLogin;
    NSString *_name;
    NSString *_password;
    NSString *_avatar;
}

@end

static SYAccount *_account;

@implementation SYAccount

+ (instancetype)sharedAccount {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _account = [[self alloc] init];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _account->_isLogin = [ud boolForKey:@"isLogin"];
        _account->_name = [ud stringForKey:@"name"];
        _account->_avatar = [ud stringForKey:@"avatar"];
    });
    return _account;
}

+ (BOOL)loginWithName:(NSString *)name password:(NSString *)password {
    __block BOOL result = NO;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [SYZhihuTool loginWithName:name password:password.md5sum success:^{
            _account->_isLogin = YES;
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setBool:YES forKey:@"isLogin"];
            [ud setObject:name forKey:@"name"];
            _account->_avatar = @"http://pic1.zhimg.com/e70b91873695eb59e7d9a145f87a1688_m.jpg";
            [ud setObject:_account->_avatar forKey:@"avatar"];
            _account->_avatar = @"http://pic1.zhimg.com/e70b91873695eb59e7d9a145f87a1688_m.jpg";
            _account->_name = name;
            result = YES;
        } failure:nil];
    });
    return result;
}

- (void)logout {
    _isLogin = NO;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:NO forKey:@"isLogin"];
}


- (NSString *)avatar {
    return self.isLogin ? _avatar : @"http://pic3.zhimg.com/d07b9bcfc_m.jpg";
}

- (NSString *)name {
    return self.isLogin ? _name : @"请登录";
}



@end
