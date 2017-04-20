//
//  JKRRegisterAPI.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/20.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRRegisterAPI.h"

@implementation JKRRegisterAPI

- (NSString *)apiUrl {
    return @"http://www.newqsy.com/easyprint/api/register";
}

- (JKRRequestType)apiRequestType {
    return JKRRequestTypePost;
}

- (BOOL)apiIsCorrectParametersBeforeRequest:(NSDictionary *)parameters {
    NSString *name = parameters[@"username"];
    if (name.length <= 1) {
        return NO;
    }
    return YES;
}

@end
