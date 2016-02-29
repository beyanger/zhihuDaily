//
//  SYCommentView.m
//  zhihuDaily
//
//  Created by yang on 16/2/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYCommentView.h"

@implementation SYCommentView


+ (instancetype)commentView {
    SYCommentView *commentView = [[NSBundle mainBundle] loadNibNamed:@"SYCommentView" owner:nil options:nil].firstObject;
    return commentView;
}


@end
