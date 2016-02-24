//
//  SYTableViewCell.m
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface SYTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *multiImage;

@end


@implementation SYTableViewCell

- (void)setStory:(SYStory *)story {
    _story = story;
    self.title.text = story.title;
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:story.images.firstObject]];
    self.multiImage.hidden = !story.multipic;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
