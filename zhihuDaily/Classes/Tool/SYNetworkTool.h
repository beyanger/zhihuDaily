//
//  SYNetworkTool.h
//  zhihuDaily
//
//  Created by yang on 16/2/27.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
typedef NS_ENUM(NSUInteger, SYNetworkType) {
    SYNetworkTypeNone = 0,
    SYNetworkType2G = 1,
    SYNetworkType3G = 2,
    SYNetworkType4G = 3,
    SYNetworkType5G = 4, // /  5G目前为猜测结果
    SYNetworkTypeWiFi = 5,
};



@interface SYNetworkTool : NSObject

+ (SYNetworkType)getNetworkLinkType;

@end
