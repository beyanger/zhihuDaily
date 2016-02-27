//
//  SYTopView.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYTopView.h"
#import "UIImageView+WebCache.h"
@interface SYTopView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@end


@implementation SYTopView


- (void)setStory:(SYDetailStory *)story {
    _story = story;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:story.image]];
    self.titleLabel.text = story.title;
    self.sourceLabel.text = [@"来源 " stringByAppendingString:story.image_source];
    [self setNeedsLayout];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
