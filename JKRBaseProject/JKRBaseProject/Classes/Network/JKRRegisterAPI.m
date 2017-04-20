//
//  JKRRegisterAPI.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/20.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRRegisterAPI.h"

@implementation JKRRegisterAPI

/// url
- (NSString *)apiUrl {
    return @"http://www.newqsy.com/easyprint/api/register";
}

/// 请求方式
- (JKRRequestType)apiRequestType {
    return JKRRequestTypePost;
}

/// 请求参数验证
- (BOOL)apiIsCorrectParametersBeforeRequest:(NSDictionary *)parameters {
    NSString *name = parameters[@"username"];
    if (name.length <= 1) {
        return NO;
    }
    return YES;
}

- (void)dealloc {
    NSLog(@"JKRRegisterAPI dealloc");
}

@end
