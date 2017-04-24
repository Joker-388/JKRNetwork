//
//  JKRURLCache.m
//  JKRBaseProject
//
//  Created by Lucky on 2017/4/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRURLCache.h"

@implementation JKRURLCache

static NSString *kContent = @"JKRURLCACHECONTENT";
static NSString *kTime = @"JKRURLCACHETIME";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.content = [aDecoder decodeObjectForKey:kContent];
    self.cacheTime = [aDecoder decodeIntegerForKey:kTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:kContent];
    [aCoder encodeInteger:self.cacheTime forKey:kTime];
}

@end
