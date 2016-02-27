//
//  SYThemeItem.h
//  zhihuDaily
//
//  Created by yang on 16/2/25.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYStory.h"

@interface SYThemeItem : NSObject

@property (nonatomic, strong) NSMutableArray<SYStory *> *stories;


@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *background;

@property (nonatomic, assign) long color;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, strong) NSArray *editors;

@property (nonatomic, copy) NSString *image_source;

@end
