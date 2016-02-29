//
//  SYTopImageView.h
//  zhihuDaily
//
//  Created by yang on 16/2/25.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYStory.h"

@interface SYTopImageView : UIView

@property (nonatomic, strong) SYStory *story;


+ (instancetype)topImageView;

@end
