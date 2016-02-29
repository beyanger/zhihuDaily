//
//  SYShareView.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYShareView.h"
#import "MBProgressHUD+YS.h"
#import "SYLoginViewController.h"
#import "AppDelegate.h"
#import "SYAccount.h"


@interface SYShareView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, weak) UIView *coverView;

@end


@implementation SYShareView

- (IBAction)clickedCollected:(id)sender {
    if ([SYAccount sharedAccount].isLogin) {
        [MBProgressHUD showSuccess:@"收藏成功"];
       
    } else {
        SYLoginViewController *lvc = [[SYLoginViewController alloc] init];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.mainController presentViewController:lvc animated:YES completion:nil];
    }
     [self handleTap];
}

- (IBAction)cancel:(id)sender {
    [self handleTap];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (NSInteger)(0.5 + scrollView.contentOffset.x / kScreenWidth);
}

- (void)handleTap {
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.backgroundColor = SYColor(48, 48, 48, 0);
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
    }];
}


- (void)show {
    UIView *cover = [[UIView alloc] initWithFrame:kScreenBounds];
    cover.backgroundColor = SYColor(128, 128, 128, 0);
    
    self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 320);
    [cover addSubview:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [cover addGestureRecognizer:tap];
    self.coverView = cover;
    [[UIApplication sharedApplication].keyWindow addSubview:cover];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        cover.backgroundColor = SYColor(48, 48, 48, 0.6);
        self.transform = CGAffineTransformMakeTranslation(0, -320);
    }];
}


@end
