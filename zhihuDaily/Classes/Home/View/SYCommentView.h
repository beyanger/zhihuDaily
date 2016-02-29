//
//  SYCommentView.h
//  zhihuDaily
//
//  Created by yang on 16/2/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SYCommentView;

@protocol SYCommentViewDelegate <NSObject>

@optional
- (void)commentView:(SYCommentView *)commentView didClicked:(NSUInteger)index;

@end



@interface SYCommentView : UIView

+ (instancetype)commentViewWithLiked:(BOOL)liked;

@property (nonatomic, weak) id<SYCommentViewDelegate> delegate;

@end
