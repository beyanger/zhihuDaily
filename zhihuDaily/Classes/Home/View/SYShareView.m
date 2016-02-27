//
//  SYShareView.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYShareView.h"


@interface SYShareView ()

@property (nonatomic, strong) NSArray<UIButton *> *allButton;
@property (weak, nonatomic) IBOutlet UIView *containerScrollView;

@end


@implementation SYShareView

- (void)awakeFromNib {
    for (NSUInteger i = 0; self.allImage.count; i++) {
        NSString *image = self.allImage[i];
        NSString *title = self.allTitle[i];
        
        
    }
    
}


- (IBAction)clickedCollected:(id)sender {
}
- (IBAction)cancel:(id)sender {
}


- (void)handleTap {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = SYColor(48, 48, 48, 0);
 
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)show {
    
}

- (NSArray *)allImage {
    return @[
             @"Share_WeiChat",
             @"Share_Copylink",
             @"Share_WeiChat_Moments",
             @"Share_YoudaoNote",
             @"Share_QQ",
             @"Share_Evernote",
             @"Share_Sina",
             @"Share_Tencent",
             @"Share_Message",
             @"Share_Instapaper",
             @"Share_Ren",
             @"Share_Facebook",
             @"Share_Twitter",
             @"Share_JS",
             @"Share_Pocket",
             @"Share_Readability"
             ];
}


- (NSArray *)allTitle {
    return @[
    @"微信好友" ,
    @"复制链接" ,
    @"微信朋友圈" ,
    @"有道云笔记" ,
    @"QQ" ,
    @"印象笔记" ,
    @"新浪微博" ,
    @"腾信微博" ,
    @"信息" ,
    @"Instapaper" ,
    @"人人" ,
    @"Facebook" ,
    
    @"Twitter" ,
    @"JS" ,
    @"Pocket" ,
    @"Readability"
    ];
}

@end
