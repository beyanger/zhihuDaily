//
//  SYCommentCell.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYCommentCell.h"
#import "UIImageView+WebCache.h"
#import "SYCommentView.h"



@interface SYCommentCell () <SYCommentViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (nonatomic, weak) SYCommentView *commentView;
@end


@implementation SYCommentCell


- (void)setComment:(SYComment *)comment {
    _comment = comment;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:comment.avatar]];
    self.nameLabel.text = comment.author;
    
    if (comment.isLike) {
        self.likeImage.image = [UIImage imageNamed:@"Comment_Voted"];
        self.likeLabel.textColor = kGroundColor;
    } else {
        self.likeImage.image = [UIImage imageNamed:@"Comment_Vote"];
        self.likeLabel.textColor = SYColor(128, 128, 128, 1.0);
    }
    
    
    self.commentLabel.text = comment.content;
    self.likeLabel.text = [NSString stringWithFormat:@"%ld", comment.likes];
    
    static NSDateFormatter *_formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter=[[NSDateFormatter alloc]init];
        [_formatter setLocale:[NSLocale currentLocale]];
        [_formatter setDateFormat:@"MM-dd HH:mm"];

    });
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:comment.time];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [_formatter stringFromDate:date]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    
    if (self.commentView) {
        [self removeCommentView];
    } else {
        CGPoint location = [touches.anyObject locationInView:self];
        self.commentView = [self addCommentViewWithLocation:location];
    }
}
#pragma mark commentView delegate
- (void)commentView:(SYCommentView *)commentView didClicked:(NSUInteger)index {
    if (index == 0) {
        self.comment.isLike = !self.comment.isLike;
        self.comment.likes += self.comment.isLike?1:-1;
        // 重新设置，更新UI
        self.comment = _comment;
        if (self.comment.isLike) {
            #warning TODO  添加点赞动画效果

            [self addLikeAnimation];
        }
        
    }
    [self removeCommentView];
}



- (SYCommentView *)addCommentViewWithLocation:(CGPoint)location {
    
    SYCommentView *cv = [SYCommentView commentViewWithLiked:self.comment.isLike];
    cv.delegate  = self;
    cv.center = CGPointMake(kScreenWidth*0.5, location.y-20);
    UIView *windows = [UIApplication sharedApplication].keyWindow;
    CGRect frame = [self convertRect:cv.frame toView:windows];
    cv.frame = frame;
    cv.alpha = 0;
    [windows addSubview:cv];
    [UIView animateWithDuration:0.5 animations:^{
        cv.alpha = 1.0;
    } completion:nil];
    return cv;
}

- (void)addLikeAnimation {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"+1"]];
    CGRect frame  = CGRectMake(-30., -24, 30, 24);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    imageView.frame = [self.likeImage convertRect:frame toView:window];
    [window addSubview:imageView];
    [UIView animateWithDuration:0.48 animations:^{
        CGRect endFrame = CGRectMake(0, 0, 5, 4);
        imageView.frame = [self.likeImage convertRect:endFrame toView:window];
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
    
}


- (void)removeCommentView {
    if (self.commentView) {
        [UIView animateWithDuration:0.2 animations:^{
            self.commentView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.commentView removeFromSuperview];
            self.commentView = nil;
        }];
    }
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (!selected)
        [self removeCommentView];
    
    
}

@end
