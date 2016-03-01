//
//  NSString+MD5.m
//  zhihuDaily
//
//  Created by yang on 16/3/1.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)
- (NSString *)md5sum {
    
    unsigned char digest[16], i;
    
    CC_MD5([self UTF8String], (CC_LONG)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for (i=0;i<16;i++) {
        [ms appendFormat: @"%x", (int)(digest[i])];
    }
    return [ms copy];
}
@end
