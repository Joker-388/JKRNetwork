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
/// 根据请求参数生成一个NSURLRequest对象
- (NSURLRequest *)requestWithRequestType:(JKRRequestType)type urlString:(NSString *)urlString parameters:(nullable NSDictionary *)parameters;
/// 根据请求参数生成一个NSMutableURLRequest对象
- (NSMutableURLRequest *)mutableRequestWithRequestType:(JKRRequestType)type urlString:(NSString *)urlString parameters:(nullable NSDictionary *)parameters;


@end

NS_ASSUME_NONNULL_END
