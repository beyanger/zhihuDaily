//
//  SYTableHeader.m
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYTableHeader.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"

@interface SYTableHeader ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray<UIImageView *> *editorsImage;

@end


@implementation SYTableHeader

- (void)awakeFromNib {
    for (UIImageView *imageView in self.editorsImage) {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = imageView.bounds;
        maskLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(imageView.bounds, 2, 2)].CGPath;
        imageView.layer.mask = maskLayer;
    }
    
}

- (void)setEditors:(NSArray<SYEditor *> *)editors {
    _editors = editors;
    for (NSUInteger i = 0; i < 5; i++) {
        if (i < editors.count) {
            [self.editorsImage[i] sd_setImageWithURL:[NSURL URLWithString:editors[i].avatar]];
        } else {
            self.editorsImage[i].image = nil;
        }
    }
    
    
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
