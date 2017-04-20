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
    __block NSURLSessionDataTask *dataTask = nil;
    if (type == JKRRequestTypePost) {
        __weak typeof(self) weakSelf = self;
        dataTask = [self.sessionManager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf requestTableViewRemoveObjectWithIdentifier:task.taskIdentifier];
            JKRURLResponse *response = [[JKRURLResponse alloc] initWithResponse:responseObject];
            response.requestID = dataTask.taskIdentifier;
            success(response);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf requestTableViewRemoveObjectWithIdentifier:task.taskIdentifier];
            JKRURLResponse *response = [[JKRURLResponse alloc] initWithError:error];
            response.requestID = dataTask.taskIdentifier;
            failure(response);
        }];
    } else if (type == JKRRequestTypeGet) {
        __weak typeof(self) weakSelf = self;
        dataTask = [self.sessionManager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf requestTableViewRemoveObjectWithIdentifier:task.taskIdentifier];
            JKRURLResponse *response = [[JKRURLResponse alloc] initWithResponse:responseObject];
            response.requestID = dataTask.taskIdentifier;
            success(response);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf requestTableViewRemoveObjectWithIdentifier:task.taskIdentifier];
            JKRURLResponse *response = [[JKRURLResponse alloc] initWithError:error];
            response.requestID = dataTask.taskIdentifier;
            failure(response);
        }];
    }
    [self.requestTable setValue:dataTask forKey:[NSString stringWithFormat:@"%lu", (unsigned long)dataTask.taskIdentifier]];
    return dataTask.taskIdentifier;
}

- (void)requestTableViewRemoveObjectWithIdentifier:(JKRRequestID)requestID {
    [self.requestTable removeObjectForKey:[NSString stringWithFormat:@"%lu", requestID]];
}

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
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
