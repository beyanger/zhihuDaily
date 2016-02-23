//
//  SYDetailController.h
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYStory.h"

@class SYDetailController;

@protocol SYDetailControllerDelegate <NSObject>

@optional
- (SYStory *)nextStoryForDetailController:(SYDetailController *)detailController;
- (SYStory *)prevStoryForDetailController:(SYDetailController *)detailController;

@end


@interface SYDetailController : UIViewController

@property (nonatomic, strong) SYStory *story;

- (instancetype)initWithStory:(SYStory *)story;

@property (nonatomic, weak) id<SYDetailControllerDelegate> delegate;

@end
