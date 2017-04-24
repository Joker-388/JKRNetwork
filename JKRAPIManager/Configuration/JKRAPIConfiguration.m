//
//  JKRAPIConfiguration.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRAPIConfiguration.h"

@implementation JKRAPIConfiguration

+ (instancetype)sharedConfiguration {
    static JKRAPIConfiguration *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[JKRAPIConfiguration alloc] init];
        shareInstance.shouldReachable = YES;
        shareInstance.timeOutSeconds = 20;
        shareInstance.cacheOutSeconds = 30;
        shareInstance.cacheCountLimit = 100;
    });
    return shareInstance;
}

- (void)setBaseURL:(NSURL *)baseURL {
    if ([[baseURL path] length] > 0 && [[baseURL absoluteString] hasSuffix:@"/"]) {
        baseURL = [baseURL URLByAppendingPathComponent:@""];
    }
    _baseURL = baseURL;
}

@end
