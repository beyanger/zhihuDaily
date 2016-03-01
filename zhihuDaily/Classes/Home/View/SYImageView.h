//
//  SYImageView.h
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYImageView;

@protocol SYImageViewDelegate <NSObject>

@optional
- (NSString *)prevImageOfImageView:(SYImageView *)imageView current:(NSString *)current;
- (NSString *)nextImageOfImageView:(SYImageView *)imageView current:(NSString *)current;

@end


@interface SYImageView : UIView

+ (instancetype)showImageWithURLString:(NSString *)url;

@property (nonatomic, weak) id<SYImageViewDelegate> delegate;

@end
