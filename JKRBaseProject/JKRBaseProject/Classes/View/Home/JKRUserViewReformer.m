//
//  JKRUserViewReformer.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/20.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRUserViewReformer.h"

NSString *const kUserKeyName = @"kUserKeyName";
NSString *const kUserKeyToken = @"kUserKeyToken";
NSString *const kUserGender = @"kUserGender";

@implementation JKRUserViewReformer

- (NSMutableDictionary *)fetchDataWithManager:(__kindof JKRAPIManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *resultData = nil;
    resultData = @{
                   kUserKeyName:data[@"data"][@"username"] ? data[@"data"][@"username"] : @"未登录",
                   kUserKeyToken:data[@"data"][@"token"] ? data[@"data"][@"token"] : @"未登录",
                   kUserGender:data[@"data"][@"token"] ? ([data[@"data"][@"gender"] integerValue] ? @"男" : @"女") : @"未登录"
                   };
    return [resultData mutableCopy];
}

@end
