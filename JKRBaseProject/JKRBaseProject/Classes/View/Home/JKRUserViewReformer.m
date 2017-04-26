//
//  JKRUserViewReformer.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/20.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRUserViewReformer.h"
#import "JKRUserModel.h"

NSString *const kUserKeyName = @"kUserKeyName";
NSString *const kUserKeyToken = @"kUserKeyToken";
NSString *const kUserGender = @"kUserGender";

@implementation JKRUserViewReformer

/**
- (id)fetchDataWithManager:(__kindof JKRAPIManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *resultData = nil;
    resultData = @{
                   kUserKeyName:data[@"data"][@"username"],
                   kUserKeyToken:data[@"data"][@"token"],
                   kUserGender:[data[@"data"][@"gender"] integerValue] ? @"男" : @"女"
                   };
    return [resultData mutableCopy];
}
 */


- (id)fetchDataWithManager:(__kindof JKRAPIManager *)manager reformData:(NSDictionary *)data {
    JKRUserModel *model = [[JKRUserModel alloc] init];
    model.name = data[@"data"][@"username"];
    model.token = data[@"data"][@"token"];
    model.sex = [data[@"data"][@"gender"] integerValue] ? @"男" : @"女";
    return model;
}

- (void)dealloc {
    NSLog(@"Reformer dealloc");
}

@end
