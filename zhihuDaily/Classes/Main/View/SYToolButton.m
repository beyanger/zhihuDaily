//
//  SYToolButton.m
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYToolButton.h"

@implementation SYToolButton

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat height = contentRect.size.height * 0.8;
    return CGRectMake(0, 0, contentRect.size.width, height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat y = contentRect.size.height * 0.85;
    CGFloat height = contentRect.size.height * 0.4;
    return CGRectMake(0, y, contentRect.size.width, height);
}




@end
