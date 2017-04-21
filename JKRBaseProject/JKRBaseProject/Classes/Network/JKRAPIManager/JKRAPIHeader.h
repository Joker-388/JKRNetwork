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
    JKRRequestTypePost          ///< Post请求
};

typedef NS_ENUM(NSUInteger, JKRApiCacheType) {
    JKRApiCacheTypeMemory = 0,   ///< 临时缓存，数据缓存到内存
    JKRApiCacheTypeDisk,         ///< 文件缓存，数据持久化到文件
    JKRApiCacheTypeNotCache      ///< 不缓存
};

#endif /* JKRAPIHeader_h */
