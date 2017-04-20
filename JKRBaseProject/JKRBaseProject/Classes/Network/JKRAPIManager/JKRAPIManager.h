//
//  JKRAPIManager.h
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKRAPIHeader.h"
#import "JKRURLResponse.h"
@class JKRAPIManager;

// 子类必须实现的接口
@protocol JKRAPIManagerProtocol <NSObject>

@required
/// 设置API对应的URL链接
- (NSString *)apiUrl;
/// 设置API的请求方式
- (JKRRequestType)apiRequestType;

@optional
/**
 如果请求参数错误,会终止请求发送并尝试回调对应的代理方法
 这里同样用来做请求参数的预处理，比如添加额外的分页参数等
 调用顺序优先级：apiManagerRequestParametersError: -> apiManagerRequestFailed:
 */
/// 检查请求参数是否错误,该回调是在请求发送之前回调
- (BOOL)apiIsCorrectParametersBeforeRequest:(NSDictionary *)parameters;

/**
 请求前再额外添加一些请求参数，如分页数据等
 该回调在apiIsCorrectParametersBeforeRequest:后回调
 */
/// 额外添加请求参数
- (NSDictionary *)apiAppendParameters:(NSDictionary *)parameters;

/**
 请求成功响应并接收到数据后判断token是否过期，如果token过期尝试回调对应的代理方法
 调用顺序优先级：apiManagerRequestTokenInvalid: -> apiManagerRequestSuccess:
 */
/// 检查token是否过期,该回调是在接收到响应数据后回调
- (BOOL)apiIsTokenInvalidAfterResponse:(NSDictionary *)parameters;

@end



// API调用者实现的回调协议
@protocol JKRAPIManagerCallBackDelegate <NSObject>

@required
/// API请求成功
- (void)apiManagerRequestSuccess:(__kindof JKRAPIManager *)manager;
/// API请求失败
- (void)apiManagerRequestFailed:(__kindof JKRAPIManager *)manager;

@optional
/**
 apiManagerRequestParametersError这个回调是当请求发送前
 APIManager子类通过<JKRAPIManagerProtocol>协议的apiIsCorrectParametersBeforeRequest方法验证到请求参数错误后
 直接终止请求的发送后调用，并不是请求发送成功后根据服务器返回参数进行的判断
 如果回调代理没有实现这个方法，那么调用apiManagerRequestFailed:方法
 */
/// API请求参数错误
- (void)apiManagerRequestParametersError:(__kindof JKRAPIManager *)manager;

/**
 取消发送分两种情况，一种是当cancelLoadWhenResend=YES，重复发送请求的时候，新请求终止了原请求
 另一种情况是通过调用API的方法cancelRequestWithRequestID:\cancelAllRequests，取消请求
 如果回调代理没有实现这个方法，那么调用apiManagerRequestFailed:方法
 */
/// API取消发送
- (void)apiManagerRequestCancel:(__kindof JKRAPIManager *)manager;

/**
 该回调是当请求发送并接收到响应数据后
 APIManager子类通过<JKRAPIManagerProtocol>协议的apiIsTokenInvalidAfterResponse方法根据请求数据判断token过期后
 回调该代理方法
 如果回调代理没有实现这个方法，那么调用apiManagerRequestSuccess:方法
 */
/// 用户token过期
- (void)apiManagerRequestTokenInvalid:(__kindof JKRAPIManager *)manager;

@end


// API调用者实现的请求参数协议
@protocol JKRAPIManagerParametersSource <NSObject>

@required
/// 返回网络请求的参数
- (NSDictionary *)parametersForApiManager:(__kindof JKRAPIManager *)manager;

@end

@interface JKRAPIManager : NSObject

@property (nonatomic, weak) id<JKRAPIManagerCallBackDelegate> delegate;
@property (nonatomic, weak) id<JKRAPIManagerParametersSource> parametersSource;
@property (nonatomic, weak) id<JKRAPIManagerProtocol> child;
@property (nonatomic, assign, readwrite) BOOL cancelLoadWhenResend;

- (JKRRequestID)loadData;
- (void)cancelRequestWithRequestID:(JKRRequestID)requestID;
- (void)cancelAllRequests;
- (NSDictionary *)fetchData;
- (NSError *)fetchError;

@end
