//
//  JKRAPICacheSerializer.m
//  JKRBaseProject
//
//  Created by Lucky on 2017/4/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRAPICacheSerializer.h"

@implementation JKRAPICacheSerializer

+ (instancetype)sharedSerializer {
    static JKRAPICacheSerializer *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[JKRAPICacheSerializer alloc] init];
    });
    return shareInstance;
}

- (NSInteger)cacheTime {
    NSDate *date = [NSDate date];
    NSString *nowTimeString = [NSString stringWithFormat:@"%lf", [date timeIntervalSince1970]];
    if (nowTimeString.length >= 10) {
        nowTimeString = [nowTimeString substringToIndex:10];
    }
    return [nowTimeString integerValue];
}

- (NSString *)cacheKeyWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters {
    return urlString;
}

@end
