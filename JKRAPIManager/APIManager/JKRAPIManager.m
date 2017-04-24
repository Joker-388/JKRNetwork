//
//  JKRAPIManager.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRAPIManager.h"
#import "JKRAPITerminal.h"
#import "JKRAPICacheManager.h"
#import "JKRAPICacheSerializer.h"

@interface JKRAPIManager ()

@property (nonatomic, strong, readwrite) NSDictionary *fetchData;
@property (nonatomic, strong, readwrite) NSError *fetchError;
@property (nonatomic, strong) NSMutableArray<NSString *> *requestIdList;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, strong) NSString *cacheKey;
@property (nonatomic, assign) NSInteger cacheTime;

@end

@implementation JKRAPIManager

- (instancetype)init {
    self = [super init];
    _delegate = nil;
    _parametersSource = nil;
    if ([self conformsToProtocol:@protocol(JKRAPIManagerProtocol)]) {
        self.child = (id<JKRAPIManagerProtocol>)self;
        self.cancelLoadWhenResend = YES;
    } else {
        NSAssert(NO, @"JKRAPIManager的子类必须实现名为JKRAPIManagerProtocol的这个Protocol并实现相关方法");
    }
    return self;
}

- (JKRRequestID)loadData {
    NSDictionary *parameters = [self.parametersSource parametersForApiManager:self];
    JKRRequestType requestType = [self.child apiRequestType];
    JKRRequestID requestID = 0;
    requestID = [self sendAPIWithParameters:parameters type:requestType];
    NSLog(@"[JKRAPIManager] current request count: %zd", self.requestIdList.count);
    return requestID;
}

- (void)cancelRequestWithRequestID:(JKRRequestID)requestID {
    [[JKRAPITerminal sharedTerminal] cancelRequestWithRequestID:requestID];
}

- (void)cancelAllRequests {
    [self.requestIdList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[JKRAPITerminal sharedTerminal] cancelRequestWithRequestID:[obj integerValue]];
    }];
    [self.requestIdList removeAllObjects];
}

- (JKRRequestID)sendAPIWithParameters:(NSDictionary *)parameters type:(JKRRequestType)type{
    self.fetchError = nil;
    self.fetchData = nil;
    if (![self readyLoadWithParameters:parameters]) return 0;
    if ([self.child respondsToSelector:@selector(apiAppendParameters:)]) {
        parameters = [self.child apiAppendParameters:parameters];
    }
    if ([self getCache]) {
        return 0;
    }
    __weak typeof(self) weakSelf = self;
    JKRRequestID requestID = [[JKRAPITerminal sharedTerminal] sendAPIWithURLString:[self.child apiUrl] type:type parameters:parameters success:^(JKRURLResponse * _Nonnull response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf loadDataSuccessWithResponse:response];
    } failure:^(JKRURLResponse * _Nonnull response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf loadDataFailedWithResponse:response];
    }];
    [self.requestIdList addObject:[NSString stringWithFormat:@"%lu", requestID]];
    return requestID;
}

- (void)loadDataSuccessWithResponse:(JKRURLResponse *)response {
    self.isLoading = NO;
    [self removeRequestWithID:response.requestID];
    if ([self.child respondsToSelector:@selector(apiIsCorrentCallBackDataAfterResponse:)]) {
        if (![self.child apiIsCorrentCallBackDataAfterResponse:response]) {
            NSError *error = [NSError errorWithDomain:@"ResutNullError" code:NSURLErrorNoPermissionsToReadFile userInfo:@{@"NSErrorFailingURLKey":[self.child apiUrl], @"NSLocalizedDescription":@"result null", @"ErrorParameters":response.content}];
            self.fetchError = error;
            self.fetchData = nil;
            [self.delegate apiManagerRequestFailed:self];
            return;
        }
    }
    self.fetchData = response.content;
    self.fetchError = nil;
    if ([self.child respondsToSelector:@selector(apiIsTokenInvalidAfterResponse:)] && [self.delegate respondsToSelector:@selector(apiManagerRequestTokenInvalid:)] && [self.child apiIsTokenInvalidAfterResponse:self.fetchData]) {
        self.fetchData = nil;
        NSError *error = [NSError errorWithDomain:@"TokenInvalidError" code:NSURLErrorNoPermissionsToReadFile userInfo:@{@"NSErrorFailingURLKey":[self.child apiUrl], @"NSLocalizedDescription":@"token invalid", @"ErrorParameters":[self.parametersSource parametersForApiManager:self]}];
        self.fetchError = error;
        [self.delegate apiManagerRequestTokenInvalid:self];
    } else if ([self.delegate respondsToSelector:@selector(apiManagerRequestSuccess:)]) {
        if (self.cachePolicy != JKRApiCachePolicyIgnoreCache) {
            [self saveCache];
        }
        [self.delegate apiManagerRequestSuccess:self];
    }
}

- (void)saveCache {
    if (self.cachePolicy == JKRApiCachePolicyIgnoreCache || [self.child apiRequestType] == JKRRequestTypeUpload) {
        return;
    }
    NSLog(@"[JKRAPIManager] save cache");
    JKRURLCache *urlCache = [[JKRURLCache alloc] init];
    urlCache.content = self.fetchData;
    urlCache.cacheTime = self.cacheTime;
    [[JKRAPICacheManager sharedManager] setCache:urlCache forKey:self.cacheKey];
}

- (BOOL)getCache {
    if (self.cachePolicy == JKRApiCachePolicyIgnoreCache || [self.child apiRequestType] == JKRRequestTypeUpload) {
        return NO;
    }
    JKRURLCache *urlCache = [[JKRAPICacheManager sharedManager] getCacheForKey:self.cacheKey];
    if (urlCache.content) {
        if (self.cachePolicy == JKRApiCachePolicyLoadCacheIfNotTimeout) {
            NSInteger nowTime = [JKRAPICacheSerializer sharedSerializer].cacheTime;
            if (nowTime <= urlCache.cacheTime + [JKRAPIConfiguration sharedConfiguration].cacheOutSeconds) {
                self.fetchError = nil;
                self.fetchData = urlCache.content;
                if ([self.delegate respondsToSelector:@selector(apiManagerRequestSuccess:)]) {
                    [self.delegate apiManagerRequestSuccess:self];
                }
                NSLog(@"[JKRAPIManager] get cache success and not send request");
                return YES;
            }
        } else if (self.cachePolicy == JKRApiCachePolicyLoadCacheIfExist) {
            self.fetchError = nil;
            self.fetchData = urlCache.content;
            if ([self.delegate respondsToSelector:@selector(apiManagerRequestSuccess:)]) {
                [self.delegate apiManagerRequestSuccess:self];
            }
            NSLog(@"[JKRAPIManager] get cache success and not send request");
            return YES;
        } else {
            if (self.fetchError && self.cachePolicy == JKRApiCachePolicyLoadCacheIfLoadFail) {
                self.fetchData = urlCache.content;
                self.fetchError = nil;
                if ([self.delegate respondsToSelector:@selector(apiManagerRequestSuccess:)]) {
                    [self.delegate apiManagerRequestSuccess:self];
                }
                NSLog(@"[JKRAPIManager] get cache success and not send failer");
                return YES;
            }
        }
    }
    return NO;
}

- (void)loadDataFailedWithResponse:(JKRURLResponse *)response {
    self.isLoading = NO;
    [self removeRequestWithID:response.requestID];
    self.fetchData = nil;
    self.fetchError = response.error;
    if ([self getCache]) {
        return;
    }
    if (response.error.code == NSURLErrorCancelled && [self.delegate respondsToSelector:@selector(apiManagerRequestCancel:)]) {
        [self.delegate apiManagerRequestCancel:self];
        return;
    } else if ([self.delegate respondsToSelector:@selector(apiManagerRequestFailed:)]) {
        [self.delegate apiManagerRequestFailed:self];
    }
}

- (void)removeRequestWithID:(JKRRequestID)requestID {
    NSString *removeObject = nil;
    for (NSString *obj in self.requestIdList) {
        if ([obj integerValue] == requestID) {
            removeObject = obj;
        }
    }
    if (removeObject) {
        [self.requestIdList removeObject:removeObject];
    }
}

- (BOOL)readyLoadWithParameters:(NSDictionary *)parameters {
    if (self.isLoading && self.cancelLoadWhenResend) {
        [self cancelAllRequests];
    }
    if ([self.child respondsToSelector:@selector(apiIsCorrectParametersBeforeRequest:)]) {
        if (!self.parametersSource) {
            NSAssert(NO, @"API调用者必须实现JKRAPIManagerParametersSource这个协议以提供请求参数");
        }
        if (![self.parametersSource respondsToSelector:@selector(parametersForApiManager:)]) {
            NSAssert(NO, @"API调用者必须实现 parametersForApiManager: 方法以提供请求参数");
        }
        if (![self.child apiIsCorrectParametersBeforeRequest:parameters]) {
            NSError *error = [NSError errorWithDomain:@"ParametersError" code:NSURLErrorResourceUnavailable userInfo:@{@"NSErrorFailingURLKey":[self.child apiUrl], @"NSLocalizedDescription":@"Parameters Error", @"ErrorParameters":[self.parametersSource parametersForApiManager:self]}];
            self.fetchError = error;
            self.fetchData = nil;
            if ([self.delegate respondsToSelector:@selector(apiManagerRequestParametersError:)]) {
                [self.delegate apiManagerRequestParametersError:self];
            } else if ([self.delegate respondsToSelector:@selector(apiManagerRequestFailed:)]) {
                [self.delegate apiManagerRequestFailed:self];
            } else {
                NSLog(@"请求参数格式错误，请检查!");
            }
            return NO;
        }
    }
    self.isLoading = YES;
    return YES;
}

- (NSMutableDictionary *)fetchOriginalData {
    return [_fetchData mutableCopy];
}

- (NSMutableDictionary *)fetchDataWithReformer:(id<JKRAPIManagerDataReformer>)reformer {
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(fetchDataWithManager:reformData:)]) {
        resultData = [reformer fetchDataWithManager:self reformData:self.fetchData];
    } else {
        resultData = [self.fetchData mutableCopy];
    }
    return resultData;
}

- (NSError *)fetchOriginalError {
    return _fetchError;
}

- (NSMutableArray<NSString *> *)requestIdList {
    if (!_requestIdList) {
        _requestIdList = [NSMutableArray array];
    }
    return _requestIdList;
}

- (NSString *)cacheKey {
    return [[JKRAPICacheSerializer sharedSerializer] cacheKeyWithUrlString:[self.child apiUrl] parameters:[self.parametersSource parametersForApiManager:self]];
}

- (NSInteger)cacheTime {
    return [JKRAPICacheSerializer sharedSerializer].cacheTime;
}

@end
