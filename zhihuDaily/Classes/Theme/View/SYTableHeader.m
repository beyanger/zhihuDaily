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
@property (weak, nonatomic) IBOutlet UIImageView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *moreImage;

@end


@implementation SYTableHeader


#pragma mark life cycle
- (void)awakeFromNib {
    for (UIImageView *imageView in self.editorsImage) {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = imageView.bounds;
        maskLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(imageView.bounds, 2, 2)].CGPath;
        imageView.layer.mask = maskLayer;
    }
    
}

#pragma mark setter & getter
- (void)setAvatars:(NSArray<NSString *> *)avatars {
    _avatars = avatars;
    for (NSUInteger i = 0; i < 5; i++) {
        if (i < avatars.count) {
            [self.editorsImage[i] sd_setImageWithURL:[NSURL URLWithString:avatars[i]]];
        } else {
            self.editorsImage[i].image = nil;
        }
    }
}


+ (instancetype)headerViewWitTitle:(NSString *)title rightViewType:(SYRightViewType)type {
    SYTableHeader *header = [[NSBundle mainBundle] loadNibNamed:@"SYTableHeader" owner:nil options:nil].firstObject;
    header.title.text = title;
    if (type == SYRightViewTypeArrow) {
        header.rightView.hidden = NO;
        header.moreImage.hidden = YES;
    } else if (type == SYRightViewTypeMore) {
        header.rightView.hidden = YES;
        header.moreImage.hidden = NO;
    } else {
        header.rightView.hidden = YES;
        header.moreImage.hidden = YES;
    }
    return header;
}

- (void)setHidenMoreIndicator:(BOOL)hidenMoreIndicator {
    self.moreImage.hidden = hidenMoreIndicator;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
