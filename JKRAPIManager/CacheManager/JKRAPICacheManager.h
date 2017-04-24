//
//  JKRAPICacheManager.h
//  JKRBaseProject
//
//  Created by Joker on 2017/4/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKRAPIConfiguration.h"
#import "JKRAPIManager.h"
#import "JKRURLCache.h"

@interface JKRAPICacheManager : NSObject

+ (instancetype)sharedManager;
/// 获取网络缓存文件大小 bytes
- (NSInteger)cacheCost;
/// 清空网络缓存
- (void)cleanCache;
- (void)setCache:(JKRURLCache *)cache forKey:(NSString *)key;
- (JKRURLCache *)getCacheForKey:(NSString *)key;

@end
