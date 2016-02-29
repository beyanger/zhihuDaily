//
//  SYCommentView.h
//  zhihuDaily
//
//  Created by yang on 16/2/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SYCommentPannel;

@protocol SYCommentPannelDelegate <NSObject>

@optional
- (void)commentView:(SYCommentPannel *)commentPannel didClicked:(NSUInteger)index;

@end



@interface SYCommentPannel : UIView

+ (instancetype)commentPannelWithLiked:(BOOL)liked;

@property (nonatomic, weak) id<SYCommentPannelDelegate> delegate;

@end
