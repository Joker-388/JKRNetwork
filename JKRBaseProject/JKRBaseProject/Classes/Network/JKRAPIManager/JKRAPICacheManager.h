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

@interface JKRAPICacheManager : NSObject

- (BOOL)cacheValueWithManager:(JKRAPIManager *)manager;
- (id)getValueWithManager:(JKRAPIManager *)manager;

//- (BOOL)cacheValue:(id)value forKey:(NSString *)key type:(JKRApiCacheType)type;
//- (id)getValueForKey:(NSString *)key type:(JKRApiCacheType)type;

@end
