//
//  JKRURLResponse.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRURLResponse.h"

@implementation JKRURLResponse

- (instancetype)initWithResponse:(id)response {
    self = [super init];
    if ([response isKindOfClass:[NSDictionary class]]) {
        self.content = response;
    } else if ([response isKindOfClass:[NSData class]]) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            NSLog(@"[JKRAPI] JSON解析失败: %@", error.localizedDescription);
        } else {
            self.content = dictionary;
        }
    }
    return self;
}

- (instancetype)initWithError:(NSError *)error {
    self = [super init];
    self.error = error;
    return self;
}

@end
