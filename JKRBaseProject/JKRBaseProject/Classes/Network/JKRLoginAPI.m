//
//  JKRLoginAPI.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRLoginAPI.h"

@implementation JKRLoginAPI

/// url
- (NSString *)apiUrl {
    return @"easyprint/api/login";
}

/// 请求方式
- (JKRRequestType)apiRequestType {
    return JKRRequestTypePost;
}

/// 请求结果验证
- (BOOL)apiIsCorrentCallBackDataAfterResponse:(JKRURLResponse *)response {
    if (response.content == nil) {
        return NO;
    }
    if (response.content[@"data"] == nil) {
        return NO;
    }
    if ([response.content[@"data"] isKindOfClass:[NSNull class]]) {
        response.content = @{
                             @"data":@{
                                     @"username":@"Joker",
                                     @"token":@"388",
                                     @"gender":@"1"
                                     }
                             };
        return YES;
    }
    return YES;
}

- (void)dealloc {
    NSLog(@"JKRLoginAPI dealloc");
}

@end
