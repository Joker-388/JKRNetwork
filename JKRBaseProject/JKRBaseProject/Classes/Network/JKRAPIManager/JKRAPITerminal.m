//
//  JKRAPITerminal.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRAPITerminal.h"

@interface JKRAPITerminal ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableDictionary *requestTable;

@end

@implementation JKRAPITerminal

+ (instancetype)sharedTerminal {
    static JKRAPITerminal *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JKRAPITerminal alloc] init];
    });
    return sharedInstance;
}

- (void)cancelRequestWithRequestID:(JKRRequestID)requestID {
    NSURLSessionDataTask *task = self.requestTable[[NSString stringWithFormat:@"%lu", requestID]];
    [task cancel];
    [self requestTableViewRemoveObjectWithIdentifier:requestID];
}

/// 底层网络请求
- (JKRRequestID)sendAPIWithURLString:(NSString *)URLString type:(JKRRequestType)type parameters:(NSDictionary *)parameters success:(JKRAPICallBack)success failure:(JKRAPICallBack)failure {
    NSURLRequest *request = [[JKRAPIRequestSerializer sharedSerializer] requestWithRequestType:type urlString:URLString parameters:parameters];
    __block NSURLSessionDataTask *dataTask = nil;
    __weak typeof(self)weakSelf = self;
    dataTask = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf requestTableViewRemoveObjectWithIdentifier:dataTask.taskIdentifier];
        if (error) {
            JKRURLResponse *jkr_response = [[JKRURLResponse alloc] initWithError:error];
            jkr_response.requestID = dataTask.taskIdentifier;
            failure ? failure(jkr_response):nil;
        } else {
            JKRURLResponse *jkr_response = [[JKRURLResponse alloc] initWithResponse:responseObject];
            jkr_response.requestID = dataTask.taskIdentifier;
            success ? success(jkr_response):nil;
        }
    }];
    [self.requestTable setValue:dataTask forKey:[NSString stringWithFormat:@"%lu", (unsigned long)dataTask.taskIdentifier]];
    [dataTask resume];
    return dataTask.taskIdentifier;
}

//- (JKRRequestID)sendAPIWithURLString:(NSString *)URLString cacheType:(JKRApiCacheType)cacheType type:(JKRRequestType)type parameters:(NSDictionary *)parameters success:(JKRAPICallBack)success failure:(JKRAPICallBack)failure {
//    NSMutableURLRequest *request = [[JKRAPIRequestSerializer sharedSerializer] mutableRequestWithRequestType:type urlString:URLString parameters:parameters];
//    if (cacheType == JKRApiCacheTypeLoadCache) {
//        request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
//    } else if (cacheType == JKRApiCacheTypeNotCache) {
//        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//    }
//    __block NSURLSessionDataTask *dataTask = nil;
//    __weak typeof(self)weakSelf = self;
//    dataTask = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf requestTableViewRemoveObjectWithIdentifier:dataTask.taskIdentifier];
//        if (error) {
//            JKRURLResponse *jkr_response = [[JKRURLResponse alloc] initWithError:error];
//            jkr_response.requestID = dataTask.taskIdentifier;
//            failure ? failure(jkr_response):nil;
//        } else {
//            JKRURLResponse *jkr_response = [[JKRURLResponse alloc] initWithResponse:responseObject];
//            jkr_response.requestID = dataTask.taskIdentifier;
//            success ? success(jkr_response):nil;
//        }
//    }];
//    [self.requestTable setValue:dataTask forKey:[NSString stringWithFormat:@"%lu", (unsigned long)dataTask.taskIdentifier]];
//    [dataTask resume];
//    return dataTask.taskIdentifier;
//}

- (void)requestTableViewRemoveObjectWithIdentifier:(JKRRequestID)requestID {
    [self.requestTable removeObjectForKey:[NSString stringWithFormat:@"%lu", requestID]];
}

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:sessionConfiguration];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

- (NSMutableDictionary *)requestTable {
    if (!_requestTable) {
        _requestTable = [NSMutableDictionary dictionary];
    }
    return _requestTable;
}

@end
