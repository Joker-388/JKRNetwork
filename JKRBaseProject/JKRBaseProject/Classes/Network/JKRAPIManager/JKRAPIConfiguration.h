//
//  JKRAPIConfiguration.h
//  JKRBaseProject
//
//  Created by Joker on 2017/4/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKRAPIConfiguration : NSObject

@property (nonatomic, assign) BOOL shouldReachable;               ///< 是否监听网络状态
@property (nonatomic, assign) NSTimeInterval timeOutSeconds;      ///< 请求超时时间
@property (nonatomic, assign) NSTimeInterval cacheOutSeconds;     ///< 缓存失效时间
@property (nonatomic, strong) NSURL *baseURL;                     ///< 所有API的baseURL

+ (instancetype)sharedConfiguration;

@end
