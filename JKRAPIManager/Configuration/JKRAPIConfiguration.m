//
//  JKRAPIConfiguration.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRAPIConfiguration.h"
#import <AFNetworking.h>

@implementation JKRAPIConfiguration

NSString *const JKR_REACHABILITY_NOTIFICATION_KEY = @"JKR_REACHABILITY_NOTIFICATION_KEY";

+ (instancetype)sharedConfiguration {
    static JKRAPIConfiguration *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[JKRAPIConfiguration alloc] init];
        shareInstance.shouldReachable = YES;
        shareInstance.timeOutSeconds = 20;
        shareInstance.cacheOutSeconds = 30;
        shareInstance.cacheCountLimit = 100;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                JKRReachabilityStatus rs;
                switch (status) {
                    case AFNetworkReachabilityStatusUnknown:
                        rs = JKRReachabilityStatusUnknow;
                        break;
                    case AFNetworkReachabilityStatusNotReachable:
                        rs = JKRReachabilityStatusNotReachable;
                        break;
                    case AFNetworkReachabilityStatusReachableViaWWAN:
                        rs = JKRReachabilityStatusViaWWAN;
                        break;
                    case AFNetworkReachabilityStatusReachableViaWiFi:
                        rs = JKRReachabilityStatusViaWiFi;
                        break;
                    default:
                        rs = JKRReachabilityStatusUnknow;
                        break;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:JKR_REACHABILITY_NOTIFICATION_KEY object:nil userInfo:@{JKR_REACHABILITY_NOTIFICATION_KEY : [NSNumber numberWithUnsignedInteger:rs]}];
            });
        }];
    });
    return shareInstance;
}

- (void)setBaseURL:(NSURL *)baseURL {
    if ([[baseURL path] length] > 0 && [[baseURL absoluteString] hasSuffix:@"/"]) {
        baseURL = [baseURL URLByAppendingPathComponent:@""];
    }
    _baseURL = baseURL;
}

- (JKRReachabilityStatus)reachabilityStatus {
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    JKRReachabilityStatus rs;
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            rs = JKRReachabilityStatusUnknow;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            rs = JKRReachabilityStatusNotReachable;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            rs = JKRReachabilityStatusViaWWAN;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            rs = JKRReachabilityStatusViaWiFi;
            break;
        default:
            rs = JKRReachabilityStatusUnknow;
            break;
    }
    return rs;
}

- (void)setShouldReachable:(BOOL)shouldReachable {
    _shouldReachable = shouldReachable;
    if (_shouldReachable) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    } else {
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    }
}

@end
