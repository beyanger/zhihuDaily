//
//  SYRefreshView.h
//  zhihuDaily
//
//  Created by yang on 16/2/25.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYRefreshView : UIView

+ (instancetype)refreshViewWithScrollView:(UIScrollView *)scrollView;

- (void)endRefresh;

@end
