//
//  JKRUserAPI.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/20.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRUserAPI.h"

@implementation JKRUserAPI

- (instancetype)init {
    self = [super init];
    _index = 0;
    return self;
}

/// 请求方式
- (JKRRequestType)apiRequestType {
    return JKRRequestTypeGet;
}

/// url
- (NSString *)apiUrl {
    return @"http://www.newqsy.com/easyprint/api/get_personal_template";
}

/// 额外添加请求参数
- (NSDictionary *)apiAppendParameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"page_no"] = [NSNumber numberWithInteger:self.index];
    mutableParameters[@"page_size"] = [NSNumber numberWithInteger:20];
    return [NSDictionary dictionaryWithDictionary:mutableParameters];
}

/// token失效的条件定义
- (BOOL)apiIsTokenInvalidAfterResponse:(NSDictionary *)parameters {
    if ([parameters[@"header"][@"status"] integerValue] == 2012) {
        return YES;
    }
    return NO;
}

- (void)dealloc {
    NSLog(@"JKRUserAPI dealloc");
}

@end
