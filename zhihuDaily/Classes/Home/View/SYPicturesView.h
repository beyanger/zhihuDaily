//
//  SYPicturesView.h
//  zhihuDaily
//
//  Created by yang on 16/2/24.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYStory.h"
@class SYPicturesView;

@protocol SYPicturesViewDelegate <NSObject>

@optional
- (void)pictureView:(SYPicturesView *)picturesView clickedIndex:(NSInteger)index;

@end


@interface SYPicturesView : UIView

@property (nonatomic, strong) NSArray<SYStory *> *topStroies;

@property (nonatomic, weak) id<SYPicturesViewDelegate> delegate;

@end
