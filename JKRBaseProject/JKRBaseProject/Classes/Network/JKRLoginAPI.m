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

@end
