//
//  NSDictionary+JKRAPICacheKey.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/24.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "NSDictionary+JKRAPICacheKey.h"

@implementation NSDictionary (JKRAPICacheKey)

- (NSString *)cacheKey {
    NSArray<NSString *> *sortedArray = [self sortObjectsWithKey];
    NSMutableString *parametersString = [[NSMutableString alloc] init];
    for (NSString *string in sortedArray) {
        [parametersString appendString:string];
    }
    return parametersString;
}

- (NSArray<NSString *> *)sortObjectsWithKey {
    NSMutableArray *result = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        if ([obj length] > 0) {
            [result addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}

@end
