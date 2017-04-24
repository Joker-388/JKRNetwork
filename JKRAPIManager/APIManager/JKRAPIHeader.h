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

#endif /* JKRAPIHeader_h */
