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
#import "SYStory.h"
#import "UIView+Extension.h"


@interface SYShareView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelTop;

@property (weak, nonatomic) IBOutlet UIScrollView *containerView;




@property (nonatomic, assign) CGFloat yoffset;

@end


@implementation SYShareView


- (void)awakeFromNib {
    self.containerView.contentSize = CGSizeMake(kScreenWidth*2, 160);

    for (NSUInteger i = 0; i < 8; i++) {
        for (NSUInteger j = 0; j < 2; j++) {
            UIButton *btn = [self newButton];
            [btn setImage:[UIImage imageNamed:self.imageArray[j*8+i]] forState:UIControlStateNormal];
            [btn setTitle:self.titleArray[j*8+i] forState:UIControlStateNormal];
            btn.center = CGPointMake(20+(kScreenWidth-40)*0.25*(i%4+0.5)+j*kScreenWidth, 40+80*(i/4));
            
            [self.containerView addSubview:btn];
        }
    }
}


- (UIButton *)newButton {
    UIButton *button = [[UIButton alloc] init];
    button.bounds = CGRectMake(0, 0, (kScreenWidth-40)*0.25, 80);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 6, 20, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(60, -60, 0, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:SYColor(60, 60, 60, 1.) forState:UIControlStateNormal];
    return button;
}


- (IBAction)clickedCollected:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareView:didSelected:)]) {
        [self.delegate shareView:self didSelected:sender.tag];
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
        self.transform = CGAffineTransformMakeTranslation(0, self.yoffset);
    }];
}


+ (instancetype)shareView {
    return [self shareViewWithTitle:nil];
}


+ (instancetype)shareViewWithTitle:(NSString *)title {
    SYShareView *shareView = [[NSBundle mainBundle] loadNibNamed:@"SYShareView" owner:nil options:nil].firstObject;
    if (title.length > 0) {
        [shareView.titleButton setTitle:title forState:UIControlStateNormal];
        shareView.yoffset = -320;
        shareView.cancelTop.constant = 12;
    } else {
        [shareView.titleButton setTitle:@"取消" forState:UIControlStateNormal];
        shareView.cancelTop.constant = -36;
        shareView.yoffset = -320+48;
    }

    return shareView;
}


- (NSArray *)titleArray {
    return @[
             @"微信",
             @"朋友圈",
             @"有道云笔记",
             @"QQ",
             @"复制链接",
             @"印象笔记",
             @"新浪",
             @"腾讯",
             @"信息",
             @"Instapper",
             @"人人",
             @"Facebook",
             @"JS",
             @"Pocket",
             @"Twitter",
             @"Readablily",
             ];
    
}

- (NSArray *)imageArray {
    return @[
             @"Share_WeChat",
             @"Share_WeChat_Moments",
             @"Share_YoudaoNote",
             @"Share_QQ",
             @"Share_Copylink",
             @"Share_Evernote",
             @"Share_Sina",
             @"Share_Tencent",
             @"Share_Message",
             @"Share_Instapaper",
             @"Share_Renren",
             @"Share_Facebook",
             @"Share_JS",
             @"Share_Pocket",
             @"Share_Twitter",
             @"Share_Readability",
             ];
}



@end
