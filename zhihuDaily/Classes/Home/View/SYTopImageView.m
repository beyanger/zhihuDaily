//
//  SYTopImageView.m
//  zhihuDaily
//
//  Created by yang on 16/2/25.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYTopImageView.h"
#import "UIImageView+WebCache.h"

@interface SYTopImageView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end


@implementation SYTopImageView


- (void)setStory:(SYStory *)story {
    _story = story;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:story.image]];
    self.imageView.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    self.titleLabel.text = story.title;
}


+ (instancetype)topImageView {
    return [[NSBundle mainBundle] loadNibNamed:@"SYTopImageView" owner:nil options:nil].firstObject;
}

@end
