//
//  SYLastestGroup.h
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYStory.h"
@interface SYLastestGroup : NSObject

@property (nonatomic, copy) NSString *header;

@property (nonatomic, strong) NSArray<SYStory *> *stories;


@end
