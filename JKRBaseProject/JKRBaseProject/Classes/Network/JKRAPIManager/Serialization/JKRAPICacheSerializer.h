//
//  JKRAPICacheSerializer.h
//  JKRBaseProject
//
//  Created by Lucky on 2017/4/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKRAPICacheSerializer : NSObject

+ (instancetype)sharedSerializer;
- (NSInteger)cacheTime;
- (NSString *)cacheKeyWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters;

@end
