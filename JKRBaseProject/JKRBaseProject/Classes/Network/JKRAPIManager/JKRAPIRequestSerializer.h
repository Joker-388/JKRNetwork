//
//  JKRAPIRequestSerializer.h
//  JKRBaseProject
//
//  Created by Joker on 2017/4/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKRAPIConfiguration.h"
#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKRAPIRequestSerializer : NSObject

+ (instancetype)sharedSerializer;
- (NSURLRequest *)requestWithRequestType:(JKRRequestType)type urlString:(NSString *)urlString parameters:(nullable NSDictionary *)parameters;
- (NSMutableURLRequest *)mutableRequestWithRequestType:(JKRRequestType)type urlString:(NSString *)urlString parameters:(nullable NSDictionary *)parameters;


@end

NS_ASSUME_NONNULL_END
