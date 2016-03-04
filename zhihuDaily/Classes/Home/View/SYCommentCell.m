//
//  SYCommentCell.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYCommentCell.h"
#import "UIImageView+WebCache.h"
#import "SYCommentPannel.h"
#import "MBProgressHUD+YS.h"



@interface SYCommentCell () 
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (nonatomic, weak) SYCommentPannel *commentPannel;
@property (nonatomic, assign) BOOL isAnimatting;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;

@property (weak, nonatomic) IBOutlet UILabel *replyLabel;


@end


@implementation SYCommentCell
- (IBAction)didClickedExpendBtn:(UIButton *)sender {
    
    
    
    NSLog(@"- comment: --> %@", self.comment);
    self.comment.isOpen = !self.comment.isOpen;

    
    sender.selected = self.comment.isOpen;
    
    
    if ([self.delegate respondsToSelector:@selector(commentCelll:actionType:)]) {
        [self.delegate commentCelll:self actionType:sender.selected];
    }}



- (void)awakeFromNib {
    self.avatar.layer.cornerRadius = 20;
    self.avatar.clipsToBounds = YES;
}


- (void)setComment:(SYComment *)comment {
    _comment = comment;
    [comment addObserver:self forKeyPath:@"isLike" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:comment.avatar]];
    self.nameLabel.text = comment.author;
    self.commentLabel.text = comment.content;
    
    if (comment.reply_to) {
        
        NSDictionary *nameAttr = @{
            NSFontAttributeName:[UIFont systemFontOfSize:16],
            NSForegroundColorAttributeName:[UIColor blackColor]};
        NSString *name  = [@"//" stringByAppendingString:comment.reply_to.author];
        NSMutableAttributedString *author = [[NSMutableAttributedString alloc] initWithString:name attributes: nameAttr];
        
        NSDictionary *contentAttr = @{
                    NSFontAttributeName:[UIFont systemFontOfSize:15],
                    NSForegroundColorAttributeName:SYColor(89, 89, 89, 1)
                    };
        NSAttributedString *content = [[NSAttributedString alloc] initWithString:[@": " stringByAppendingString:comment.reply_to.content] attributes:contentAttr];
        
        [author appendAttributedString:content];
        self.replyLabel.attributedText = author;
        self.expandBtn.hidden = NO;
    } else {
        self.replyLabel.text = nil;
        self.expandBtn.hidden = YES;
    }
    
    self.likeLabel.text = [NSString stringWithFormat:@"%ld", comment.likes];
    
    
    if (comment.reply_to) {
        self.expandBtn.hidden = NO;
    } else {
        self.expandBtn.hidden = YES;
    }
    
    
    if (comment.isLike) {
        self.likeImage.image = [UIImage imageNamed:@"Comment_Voted"];
        self.likeLabel.textColor = kGroundColor;
    } else {
        self.likeImage.image = [UIImage imageNamed:@"Comment_Vote"];
        self.likeLabel.textColor = SYColor(128, 128, 128, 1.0);
    }
    
   
    
    self.replyLabel.numberOfLines = self.comment.isOpen ? 0 : 2;
    self.expandBtn.selected = comment.isOpen;
    
    
    
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


- (void)addLikeAnimation {
    
    if (self.isAnimatting) return;
    self.isAnimatting = YES;
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
        self.isAnimatting = NO;
    }];
}


- (void)prepareForReuse {
    [self.comment removeObserver:self forKeyPath:@"isLike"];
    [super prepareForReuse];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    BOOL isLike = [change[@"new"] boolValue];
    !isLike ? : [self addLikeAnimation];
    
    
    self.likeLabel.text = [NSString stringWithFormat:@"%ld", self.comment.likes];
    
    if (isLike) {
        self.likeImage.image = [UIImage imageNamed:@"Comment_Voted"];
        self.likeLabel.textColor = kGroundColor;
    } else {
        self.likeImage.image = [UIImage imageNamed:@"Comment_Vote"];
        self.likeLabel.textColor = SYColor(128, 128, 128, 1.0);
    }
}

- (void)dealloc {
    if (self.comment) {
        [self.comment removeObserver:self forKeyPath:@"isLike"];
    }
}

@end
