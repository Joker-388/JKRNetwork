//
//  JKRLoginAPI.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRLoginAPI.h"

@implementation JKRLoginAPI

- (NSString *)apiUrl {
    return @"http://www.newqsy.com/easyprint/api/login";
}

- (JKRRequestType)apiRequestType {
    return JKRRequestTypePost;
}

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

@end
