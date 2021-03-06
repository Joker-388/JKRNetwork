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

/******************************/
/****** 子类必须实现的接口 *******/
/******************************/
@protocol JKRAPIManagerProtocol <NSObject>

@required
/** 
 设置API对应的URL链接
 */
- (NSString *)apiUrl;
/** 
 设置API的请求方式
 */
- (JKRRequestType)apiRequestType;

@optional
/**
 检查请求参数是否错误,该回调是在请求发送之前回调
 @discussion 如果请求参数错误,会终止请求发送并尝试回调对应的代理方法
 这里同样用来做请求参数的预处理，比如添加额外的分页参数等
 调用顺序优先级：apiManagerRequestParametersError: -> apiManagerRequestFailed:
 */
- (BOOL)apiIsCorrectParametersBeforeRequest:(NSDictionary *)parameters;

/**
 检查返回结果是否错误，该回调在网络请求成功接收到数据并处理成JKRURLResponse之后调用
 @discussion 如果返回结果验证错误，那么调用apiManagerRequestFailed:
 */
- (BOOL)apiIsCorrentCallBackDataAfterResponse:(JKRURLResponse *)response;

/**
 额外添加请求参数
 @discussion 请求前再额外添加一些请求参数，如分页数据等。该回调在apiIsCorrectParametersBeforeRequest:后回调
 */
- (NSDictionary *)apiAppendParameters:(NSDictionary *)parameters;

/**
 检查token是否过期,该回调是在接收到响应数据后回调
 @discussion 请求成功响应并接收到数据后判断token是否过期，如果token过期尝试回调对应的代理方法
 调用顺序优先级：apiManagerRequestTokenInvalid: -> apiManagerRequestSuccess:
 */
- (BOOL)apiIsTokenInvalidAfterResponse:(NSDictionary *)parameters;
/** 
 是否监听网络状态
 */
- (BOOL)apiIsReachability;

@end




/******************************/
/**** API调用者监听请求状态回调 ***/
/******************************/
@protocol JKRAPIManagerCallBackDelegate <NSObject>

@required
/** 
 API请求成功
 */
- (void)apiManagerRequestSuccess:(__kindof JKRAPIManager *)manager;
/** 
 API请求失败
 */
- (void)apiManagerRequestFailed:(__kindof JKRAPIManager *)manager;

@optional
/**
 API请求参数错误
 @discussion apiManagerRequestParametersError这个回调是当请求发送前
 APIManager子类通过<JKRAPIManagerProtocol>协议的apiIsCorrectParametersBeforeRequest方法验证到请求参数错误后
 直接终止请求的发送后调用，并不是请求发送成功后根据服务器返回参数进行的判断
 如果回调代理没有实现这个方法，那么调用apiManagerRequestFailed:方法
 */
- (void)apiManagerRequestParametersError:(__kindof JKRAPIManager *)manager;

/**
 API取消发送
 @discussion 取消发送分两种情况，一种是当cancelLoadWhenResend=YES，重复发送请求的时候，新请求终止了原请求
 另一种情况是通过调用API的方法cancelRequestWithRequestID:\cancelAllRequests，取消请求
 如果回调代理没有实现这个方法，那么调用apiManagerRequestFailed:方法
 */
- (void)apiManagerRequestCancel:(__kindof JKRAPIManager *)manager;

/**
 用户token过期
 @discussion 该回调是当请求发送并接收到响应数据后
 APIManager子类通过<JKRAPIManagerProtocol>协议的apiIsTokenInvalidAfterResponse方法根据请求数据判断token过期后
 回调该代理方法
 如果回调代理没有实现这个方法，那么调用apiManagerRequestSuccess:方法
 */
- (void)apiManagerRequestTokenInvalid:(__kindof JKRAPIManager *)manager;
/** 
 没有连接网络，请求网络前、网络状态从联网状态改为非联网状态调用
 */
- (void)apiManagerNotConnectNetwork:(__kindof JKRAPIManager *)manager;
/** 
 网络连接状态改变调用
 */
- (void)apiManagerConnectNetwork:(__kindof JKRAPIManager *)manager reachabilityStatus:(JKRReachabilityStatus)status;
/** 
 连接网络后调用
 */
- (void)apiManager:(__kindof JKRAPIManager *)manager changeReachabilityStatus:(JKRReachabilityStatus)status;

@end



/******************************/
/*** API调用者提供网络请求参数 ****/
/******************************/
@protocol JKRAPIManagerParametersSource <NSObject>

@required
/// 返回网络请求的参数
- (NSDictionary *)parametersForApiManager:(__kindof JKRAPIManager *)manager;

@end


/******************************/
/*** 数据加工者需要实现的接口 ******/
/******************************/
@protocol JKRAPIManagerDataReformer <NSObject>

/// 加工APIManager的数据为便于使用的特征数据
- (id)fetchDataWithManager:(__kindof JKRAPIManager *)manager reformData:(NSDictionary *)data;

@end



@interface JKRAPIManager : NSObject

/// API请求状态监听者
@property (nonatomic, weak) id<JKRAPIManagerCallBackDelegate> delegate;
/// API请求参数提供者
@property (nonatomic, weak) id<JKRAPIManagerParametersSource> parametersSource;
/// APIManager的子类，自己实现自己的接口
@property (nonatomic, weak) id<JKRAPIManagerProtocol> child;
/// 当前请求未完成的情况下重新请求是否取消当前请求，默认YES
@property (nonatomic, assign, readwrite) BOOL cancelLoadWhenResend;
/// API缓存策略，默认临时缓存到内存
@property (nonatomic, assign) JKRApiCachePolicy cachePolicy;

/// 开始请求
- (JKRRequestID)loadData;
/// 根据请求ID取消请求
- (void)cancelRequestWithRequestID:(JKRRequestID)requestID;
/// 取消当前API所有请求
- (void)cancelAllRequests;
/// 获取请求原始数据
- (NSMutableDictionary *)fetchOriginalData;
/// 获取通过加工条件改良过的数据
- (id)fetchDataWithReformer:(id<JKRAPIManagerDataReformer>)reformer;
/// 获取请求原始错误信息
- (NSError *)fetchOriginalError;

@end
