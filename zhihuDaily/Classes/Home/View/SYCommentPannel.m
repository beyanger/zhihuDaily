//
//  SYCommentView.m
//  zhihuDaily
//
//  Created by yang on 16/2/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYCommentPannel.h"
#import "UIView+Extension.h"

@interface SYCommentPannel ()
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@end

@implementation SYCommentPannel
- (IBAction)clicked:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(commentView:didClicked:)]) {
        [self.delegate commentView:self didClicked:sender.tag];
    }
    
}

+ (instancetype)commentPannelWithLiked:(BOOL)liked {
    return [self commentPannelWithLiked:liked location:CGPointMake(0, 0)];
}


+ (instancetype)commentPannelWithLiked:(BOOL)liked location:(CGPoint)location {
    SYCommentPannel *commentView = [[NSBundle mainBundle] loadNibNamed:@"SYCommentPannel" owner:nil options:nil].firstObject;
    
    commentView.layer.cornerRadius = 8;
    commentView.clipsToBounds = YES;
    [commentView.likeBtn setTitle:liked?@"取消点赞":@"点赞" forState:UIControlStateNormal];
    commentView.width = liked ? 225 : 203;
    return commentView;
}




@end
