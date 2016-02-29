//
//  SYTopView.h
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYDetailStory.h"
@interface SYTopView : UIView


@property (nonatomic, strong) SYDetailStory *story;


+ (instancetype)topView;

@end
