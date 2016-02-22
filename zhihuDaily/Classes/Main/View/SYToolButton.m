//
//  SYToolButton.m
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYToolButton.h"

@implementation SYToolButton


- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat height = contentRect.size.height * 0.7;
    return CGRectMake(0, 0, contentRect.size.width, height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    NSLog(@"%@", NSStringFromCGRect(contentRect));
    
    CGFloat height = contentRect.size.height * 0.4;
    CGFloat y = contentRect.size.height * 0.7;
    return CGRectMake(0, y, contentRect.size.width, height);
}




@end
