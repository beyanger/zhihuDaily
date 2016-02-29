//
//  SYCommentView.m
//  zhihuDaily
//
//  Created by yang on 16/2/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYCommentPannel.h"

@interface SYCommentPannel ()
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@end

@implementation SYCommentPannel
- (IBAction)clicked:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(commentView:didClicked:)]) {
        [self.delegate commentView:self didClicked:sender.tag];
    }
    
}

- (void)awakeFromNib {
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

+ (instancetype)commentPannelWithLiked:(BOOL)liked {
    SYCommentPannel *commentView = [[NSBundle mainBundle] loadNibNamed:@"SYCommentPannel" owner:nil options:nil].firstObject;
    
    [commentView.likeBtn setTitle:liked?@"取消点赞":@"点赞" forState:UIControlStateNormal];
    return commentView;
}




@end
