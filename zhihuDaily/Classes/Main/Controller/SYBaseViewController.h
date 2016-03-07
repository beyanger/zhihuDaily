//
//  SYBaseViewController.h
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYRefreshView.h"


@interface SYBaseViewController : UIViewController

@property (nonatomic, strong) UIView *sy_header;

@property (nonatomic, weak) UIScrollView *sy_attachScrollView;

- (UIImageView *)sy_backgoundImageView;

- (SYRefreshView *)sy_refreshView;

@end
