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
//        [[JKRAPIConfiguration sharedConfiguration] addObserver:sharedInstance forKeyPath:@"cacheCountLimit" options:NSKeyValueObservingOptionNew context:nil];
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

- (NSInteger)cacheCost {
    return self.cache.diskCache.totalCost;
}

- (void)cleanCache {
    NSLog(@"[JKRAPICacheManager] begin clean cache: %zd bytes", [JKRAPICacheManager sharedManager].cacheCost);
    [self.cache.diskCache removeAllObjectsWithBlock:^{
        NSLog(@"[JKRAPICacheManager] after clean cache: %zd btyes", [JKRAPICacheManager sharedManager].cacheCost);
    }];
    [self.cache.memoryCache removeAllObjects];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    id newValue = change[NSKeyValueChangeNewKey];
//    self.cache.diskCache.costLimit = [newValue integerValue];
//    self.cache.memoryCache.costLimit = [newValue integerValue];
//    NSLog(@"%@", newValue);
//}
//
//- (void)dealloc {
//    [[JKRAPIConfiguration sharedConfiguration] removeObserver:self forKeyPath:@"cacheCountLimit"];
//}

- (JKRCache *)cache {
    if (!_cache) {
        _cache = [JKRCache apiCache];
        _cache.diskCache.countLimit = [JKRAPIConfiguration sharedConfiguration].cacheCountLimit;
        _cache.memoryCache.countLimit = [JKRAPIConfiguration sharedConfiguration].cacheCountLimit;
    }
    return _cache;
}

@end
