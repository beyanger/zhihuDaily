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

#pragma mark life cycle
- (void)awakeFromNib {
    [self.popularityButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [self.popularityButton removeObserver:self forKeyPath:@"selected"];
}


#pragma mark event handler

- (IBAction)didClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(storyNavigationView:didClicked:)]) {
        [self.delegate storyNavigationView:self didClicked:sender.tag];
    }
    if (sender.tag == self.popularityButton.tag) {
        self.popularityButton.selected = !self.popularityButton.selected;
    }
}


- (void)changeValue:(UIButton *)button {
    UILabel *view = [[UILabel alloc] init];
    view.backgroundColor = SYColor(22, 164, 220, 1.);
    view.textAlignment = NSTextAlignmentCenter;
    view.textColor = [UIColor whiteColor];
    view.layer.cornerRadius = 4;
    view.clipsToBounds = YES;
    view.text = self.popularityLabel.text;
    
    [self.popularityButton addSubview:view];
    
    
    CGSize buttonSize = button.frame.size;
    view.frame = CGRectMake(buttonSize.width*0.5, buttonSize.height*0.5, 0, 0);
    
    
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = CGRectMake(0, -15, buttonSize.width, 15);
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            view.text = [NSString stringWithFormat:@"%d", self.popularityLabel.text.intValue+1];
            self.popularityLabel.text = view.text;
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view removeFromSuperview];
        });
    }];
}


#pragma mark setter & getter
- (void)setExtraStory:(SYExtraStory *)extraStory {
    _extraStory = extraStory;
    self.popularityLabel.text = [NSString stringWithFormat:@"%ld", extraStory.popularity];
    self.commentsLabel.text = [NSString stringWithFormat:@"%ld", extraStory.comments];
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selected"]) {
        self.popularityLabel.textColor = self.popularityButton.selected ? SYColor(22, 164, 220, 1.) : [UIColor lightGrayColor];
        if (self.popularityButton.selected) {
            [self changeValue:self.popularityButton];
        } else {
            self.popularityLabel.text = [NSString stringWithFormat:@"%d", self.popularityLabel.text.intValue-1];
        }
    }
}



+ (instancetype)storyNaviView {
    return [[NSBundle mainBundle] loadNibNamed:@"SYStoryNavigationView" owner:self options:nil].firstObject;
}

@end
