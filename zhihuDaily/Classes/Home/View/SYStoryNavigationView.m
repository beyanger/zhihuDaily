//
//  SYBottomView.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYStoryNavigationView.h"

@interface SYStoryNavigationView ()


@end


@implementation SYStoryNavigationView


- (void)setExtraStory:(SYExtraStory *)extraStory {
    _extraStory = extraStory;
}



- (IBAction)didClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(storyNavigationView:didClicked:)]) {
        [self.delegate storyNavigationView:self didClicked:sender.tag];
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
