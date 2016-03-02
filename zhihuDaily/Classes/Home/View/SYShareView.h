//
//  SYShareView.h
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYShareView;

@protocol SYShareViewDelegate <NSObject>

@optional
- (void)shareView:(SYShareView *)shareView didSelected:(NSUInteger)index;

@end


@interface SYShareView : UIView

- (void)show;

@property (nonatomic, weak) id<SYShareViewDelegate> delegate;

+ (instancetype)shareView;
+ (instancetype)shareViewWithTitle:(NSString *)title;
@end
