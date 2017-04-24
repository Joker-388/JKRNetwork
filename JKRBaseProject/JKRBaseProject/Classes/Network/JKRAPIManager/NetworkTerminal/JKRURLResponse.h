//
//  JKRURLResponse.h
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKRURLResponse : NSObject

@property (nonatomic, copy, readwrite) NSDictionary *content;  ///< 请求到的数据
@property (nonatomic, strong, readwrite) NSError *error;       ///< 错误信息
@property (nonatomic, assign) JKRRequestID requestID;          ///< 请求的ID

/// 通过请求接收的数据初始化
- (instancetype)initWithResponse:(id)response;
/// 通过请求接收的错误信息初始化
- (instancetype)initWithError:(NSError *)error;

@end
