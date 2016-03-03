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


typedef NS_ENUM(NSInteger, SYStoryPositionType) {
    SYStoryPositionTypeFirst = 1,
    SYStoryPositionTypeLast = 2,
    SYStoryPositionTypeOther = 4,
    SYStoryPositionTypeFirstAndLast =
                                    SYStoryPositionTypeFirst|SYStoryPositionTypeLast,
};

@protocol SYDetailControllerDelegate <NSObject>
@required
- (SYStory *)nextStoryForDetailController:(SYDetailController *)detailController story:(SYStory *)story;
- (SYStory *)prevStoryForDetailController:(SYDetailController *)detailController story:(SYStory *)story;
- (SYStoryPositionType)detailController:(SYDetailController *)detailController story:(SYStory *)story;



@end


@interface SYDetailController : UIViewController

@property (nonatomic, strong) SYStory *story;

@property (nonatomic, weak) id<SYDetailControllerDelegate> delegate;

@end
