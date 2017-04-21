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
typedef NS_ENUM(NSUInteger, JKRRequestType) {
    JKRRequestTypeGet = 0,
    JKRRequestTypePost
};
typedef NS_ENUM(NSUInteger, JKRApiCacheType) {
    JKRApiCacheTypeDefault = 0,
    JKRApiCacheTypeLoadCache,
    JKRApiCacheTypeNotCache
};

#endif /* JKRAPIHeader_h */
