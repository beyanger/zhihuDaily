//
//  SYTableHeader.h
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYEditor.h"

typedef NS_ENUM(NSUInteger, SYRightViewType) {
    SYRightViewTypeNone = 0,
    SYRightViewTypeArrow = 1,
    SYRightViewTypeMore = 2,
};

@interface SYTableHeader : UIView

@property (nonatomic, strong) NSArray<NSString *> *avatars;

+ (instancetype)headerViewWitTitle:(NSString *)title rightViewType:(SYRightViewType)type;

@property (nonatomic, assign) BOOL hidenMoreIndicator;

@end
