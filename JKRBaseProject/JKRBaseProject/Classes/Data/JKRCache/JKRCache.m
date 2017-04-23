//
//  JKRCache.m
//  JKRBaseProject
//
//  Created by Lucky on 2017/4/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRCache.h"
#import "JKRAPIConfiguration.h"

@implementation JKRCache

+ (instancetype)apiCache {
    JKRCache *cache = [[self alloc] initWithName:@"JKRAPICache"];
    return cache;
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    [super setObject:object forKey:key];
    NSLog(@"Memory:%zd",[self.memoryCache totalCount]);
    NSLog(@"Disk:%zd",[self.diskCache totalCount]);
}

- (id<NSCoding>)objectForKey:(NSString *)key {
    NSLog(@"Memory:%zd",[self.memoryCache totalCount]);
    NSLog(@"Disk:%zd",[self.diskCache totalCount]);
    return [super objectForKey:key];
}

@end
