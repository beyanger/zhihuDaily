//
//  SYDismisAnimation.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYDismisAnimation.h"

@implementation SYDismisAnimation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
         fromVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}
@end
