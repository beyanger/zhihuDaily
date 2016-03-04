//
//  SYNetworkTool.m
//  zhihuDaily
//
//  Created by yang on 16/2/27.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYNetworkTool.h"

@implementation SYNetworkTool


+ (SYNetworkType)getNetworkLinkType {
    
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        return SYNetworkTypeWiFi;
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        return SYNetworkType3G;
    }
    return SYNetworkTypeNone;
}

@end
