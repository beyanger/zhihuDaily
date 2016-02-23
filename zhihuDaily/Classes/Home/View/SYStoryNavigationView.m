//
//  SYBottomView.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYStoryNavigationView.h"

@interface SYStoryNavigationView ()
@property (weak, nonatomic) IBOutlet UILabel *popularityLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *popularityButton;


@end


@implementation SYStoryNavigationView

- (void)updatePopularity {
    self.popularityLabel.textColor = self.popularityButton.selected ? SYColor(22, 164, 220, 1.) : [UIColor lightGrayColor];
    
}


- (void)setExtraStory:(SYExtraStory *)extraStory {
    _extraStory = extraStory;
    self.popularityLabel.text = [NSString stringWithFormat:@"%ld", extraStory.popularity];
    self.commentsLabel.text = [NSString stringWithFormat:@"%ld", extraStory.comments];
    [self updatePopularity];
}





- (IBAction)didClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(storyNavigationView:didClicked:)]) {
        [self.delegate storyNavigationView:self didClicked:sender.tag];
    }
    if (sender.tag == self.popularityButton.tag) {
        self.popularityButton.selected = !self.popularityButton.selected;
        [self updatePopularity];
        if (self.popularityButton.selected) {
            self.popularityLabel.text = [NSString stringWithFormat:@"%d", self.popularityLabel.text.intValue+1];
            // 添加动画
        } else {
            self.popularityLabel.text = [NSString stringWithFormat:@"%d", self.popularityLabel.text.intValue-1];
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
