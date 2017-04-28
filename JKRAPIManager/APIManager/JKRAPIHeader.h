//
//  JKRAPIHeader.h
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#ifndef JKRAPIHeader_h
#define JKRAPIHeader_h

typedef unsigned long JKRRequestID;

#ifdef __cplusplus
#define JKRNetwork_EXTERN		extern "C" __attribute__((visibility ("default")))
#else
#define JKRNetwork_EXTERN	        extern __attribute__((visibility ("default")))
#endif

/**
 待添加:
 JKRRequestTypeUpload,      ///< 上传请求
 JKRRequestTypeDownload     ///< 下载请求
 */
typedef NS_ENUM(NSUInteger, JKRRequestType) {
    JKRRequestTypeGet = 0,      ///< Get请求
    JKRRequestTypePost,         ///< Post请求
    JKRRequestTypeUpload        ///< 上传文件
};

typedef NS_ENUM(NSUInteger, JKRApiCachePolicy) {
    JKRApiCachePolicyIgnoreCache = 0,         ///< 不使用缓存
    JKRApiCachePolicyLoadCacheIfNotTimeout,   ///< 如果缓存未失效载入缓存
    JKRApiCachePolicyLoadCacheIfLoadFail,     ///< 如果网络请求失败载入缓存
    JKRApiCachePolicyLoadCacheIfExist,        ///< 如果缓存存在就载入缓存
};

typedef NS_ENUM(NSUInteger, JKRReachabilityStatus) {
    JKRReachabilityStatusUnknow = -1,        ///< 没有监听网络
    JKRReachabilityStatusNotReachable = 0,   ///< 网络不可用
    JKRReachabilityStatusViaWWAN,            ///< 移动网络
    JKRReachabilityStatusViaWiFi             ///< WiFi
};

#endif /* JKRAPIHeader_h */
