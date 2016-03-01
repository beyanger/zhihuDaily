//
//  SYLoadingLayer.m
//  zhihuDaily
//
//  Created by yang on 16/3/1.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYLoadingLayer.h"

@implementation SYLoadingLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = SYColor(128, 128, 128, 1.0).CGColor;
        self.strokeColor = kWhiteColor.CGColor;
        self.strokeEnd = 0.;
        self.lineWidth = 12.;
        self.fillColor = self.backgroundColor;
        self.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 4, 4)].CGPath;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.strokeEnd = progress;
}


@end
