//
//  SYVersion.h
//  zhihuDaily
//
//  Created by yang on 16/2/25.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYVersion : NSObject

@property (nonatomic, assign) int status;

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *latest;

@end
