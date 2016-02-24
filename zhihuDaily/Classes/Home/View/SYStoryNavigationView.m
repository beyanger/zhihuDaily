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

- (void)awakeFromNib {
    [self.popularityButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)dealloc {
    [self.popularityButton removeObserver:self forKeyPath:@"selected"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selected"]) {
            self.popularityLabel.textColor = self.popularityButton.selected ? SYColor(22, 164, 220, 1.) : [UIColor lightGrayColor];
        if (self.popularityButton.selected) {
#warning  添加动画
            [self changeValue:self.popularityButton];
        } else {
            self.popularityLabel.text = [NSString stringWithFormat:@"%d", self.popularityLabel.text.intValue-1];
        }
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
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    CGSize buttonSize = button.frame.size;
    CGRect originFrame = CGRectMake(buttonSize.width*0.5, buttonSize.height*0.5, 0, 0);
    view.frame = [self.popularityButton convertRect:originFrame toView:window];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = CGRectMake(0, -15, buttonSize.width, 15);
        view.frame = [button convertRect:frame toView:window];
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            view.text = [NSString stringWithFormat:@"%d", self.popularityLabel.text.intValue+1];
            self.popularityLabel.text = view.text;
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view removeFromSuperview];
        });
    }];
}



- (void)setExtraStory:(SYExtraStory *)extraStory {
    _extraStory = extraStory;
    self.popularityLabel.text = [NSString stringWithFormat:@"%ld", extraStory.popularity];
    self.commentsLabel.text = [NSString stringWithFormat:@"%ld", extraStory.comments];
}





- (IBAction)didClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(storyNavigationView:didClicked:)]) {
        [self.delegate storyNavigationView:self didClicked:sender.tag];
    }
    if (sender.tag == self.popularityButton.tag) {
        self.popularityButton.selected = !self.popularityButton.selected;
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
