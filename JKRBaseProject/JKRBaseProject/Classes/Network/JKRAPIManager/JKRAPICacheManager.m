//
//  JKRAPICacheManager.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRAPICacheManager.h"
#import "JKRCache.h"

@interface JKRAPICacheManager ()

@property (nonatomic, strong) JKRCache *cache;

@end

@implementation JKRAPICacheManager

+ (instancetype)sharedManager {
    static JKRAPICacheManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JKRAPICacheManager alloc] init];
    });
    return sharedInstance;
}

- (void)setCache:(JKRURLCache *)cache forKey:(NSString *)key {
    [self.cache setObject:cache forKey:key];
}

- (JKRURLCache *)getCacheForKey:(NSString *)key {
    id cache = [self.cache objectForKey:key];
    if ([cache isKindOfClass:[JKRURLCache class]]) {
        return (JKRURLCache *)[self.cache objectForKey:key];
    }
    return nil;
}

- (JKRCache *)cache {
    if (!_cache) {
        _cache = [JKRCache apiCache];
        _cache.diskCache.costLimit = [JKRAPIConfiguration sharedConfiguration].cacheCountLimit;
        _cache.memoryCache.costLimit = [JKRAPIConfiguration sharedConfiguration].cacheCountLimit;
    }
    return _cache;
}

@end
