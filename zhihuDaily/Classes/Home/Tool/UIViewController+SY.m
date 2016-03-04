//
//  UIViewController+SY.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//  修改系统默认的 present和dismiss动画效果， 本项目中已经弃用

#import "UIViewController+SY.h"
#import "SYPresentAnimation.h"
#import "SYDismisAnimation.h"
#import <objc/runtime.h>
#import "SYLoginViewController.h"

@implementation UIViewController (SY) 

- (void)new_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion {

    if (![viewControllerToPresent isKindOfClass:[SYLoginViewController class]]) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
        viewControllerToPresent.transitioningDelegate = self;
    }
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self new_presentViewController:viewControllerToPresent animated:YES completion:completion];
    });
    
    
    
}


- (void)new_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if (![self isKindOfClass:[SYLoginViewController class]]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self new_dismissViewControllerAnimated:flag completion:completion];
    });
    
}



+ (void)fork {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // 交换 present
        SEL origin_selector = @selector(presentViewController:animated:completion:);
        SEL new_selector = @selector(new_presentViewController:animated:completion:);
        
        Method origin_method = class_getInstanceMethod(class, origin_selector);
        Method new_method = class_getInstanceMethod(class, new_selector);
        
        BOOL didAddMethod = class_addMethod(class, origin_selector, method_getImplementation(new_method), method_getTypeEncoding(new_method));
        if (didAddMethod) {
            class_replaceMethod(class, new_selector, method_getImplementation(origin_method), method_getTypeEncoding(origin_method));
        } else {
            method_exchangeImplementations(origin_method, new_method);
        }
        
        
        // 交换 dismiss
        SEL origin_dis = @selector(dismissViewControllerAnimated:completion:);
        SEL new_dis = @selector(new_dismissViewControllerAnimated:completion:);
        Method origin_disMethod = class_getInstanceMethod(class, origin_dis);
        Method new_disMethod = class_getInstanceMethod(class, new_dis);
        
        BOOL disAddMethod = class_addMethod(class, origin_dis, method_getImplementation(new_disMethod), method_getTypeEncoding(new_disMethod));
        if (disAddMethod) {
            class_replaceMethod(class, new_dis, method_getImplementation(origin_disMethod), method_getTypeEncoding(origin_disMethod));
        } else {
            method_exchangeImplementations(origin_disMethod, new_disMethod);
        }
        
    });
    
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[SYPresentAnimation alloc] init];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[SYDismisAnimation alloc] init];
}


@end
