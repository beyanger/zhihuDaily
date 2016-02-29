//
//  SYCommentView.m
//  zhihuDaily
//
//  Created by yang on 16/2/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYCommentView.h"

@interface SYCommentView ()
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@end

@implementation SYCommentView
- (IBAction)clicked:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(commentView:didClicked:)]) {
        [self.delegate commentView:self didClicked:sender.tag];
    }
}

- (void)awakeFromNib {
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

+ (instancetype)commentViewWithLiked:(BOOL)liked {
    SYCommentView *commentView = [[NSBundle mainBundle] loadNibNamed:@"SYCommentView" owner:nil options:nil].firstObject;
    if (liked) {
        [commentView.likeBtn setTitle:@"取消点赞" forState:UIControlStateNormal];
    } else {
        [commentView.likeBtn setTitle:@"点赞" forState:UIControlStateNormal];

    }
    
    return commentView;
}




@end
