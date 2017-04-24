//
//  JKRAPIRequestSerializer.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRAPIRequestSerializer.h"

@interface JKRAPIRequestSerializer ()

@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;

@end

@implementation JKRAPIRequestSerializer

+ (instancetype)sharedSerializer {
    static JKRAPIRequestSerializer *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[JKRAPIRequestSerializer alloc] init];
    });
    return shareInstance;
}

- (NSURLRequest *)requestWithRequestType:(JKRRequestType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters {
    NSString *methodString;
    if (type == JKRRequestTypePost) {
        methodString = @"POST";
    } else if (type == JKRRequestTypeGet) {
        methodString = @"GET";
    }
    return [[self fetchRequestWithUrlString:urlString parameters:parameters method:methodString] copy];
}

- (NSMutableURLRequest *)mutableRequestWithRequestType:(JKRRequestType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters {
    NSString *methodString;
    if (type == JKRRequestTypePost) {
        methodString = @"POST";
    } else if (type == JKRRequestTypeGet) {
        methodString = @"GET";
    }
    return [self fetchRequestWithUrlString:urlString parameters:parameters method:methodString];
}

- (NSMutableURLRequest *)fetchRequestWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters method:(NSString *)method {
    NSError *serializerError = nil;
    NSString *urlString1 = [[NSURL URLWithString:urlString relativeToURL:[JKRAPIConfiguration sharedConfiguration].baseURL] absoluteString];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:urlString1 parameters:parameters error:&serializerError];
    request.timeoutInterval = [JKRAPIConfiguration sharedConfiguration].timeOutSeconds;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData; // 由于要自己实现缓存框架，所以不需要载入默认缓存
    if (serializerError) {
        NSLog(@"[JKRAPIRequestSerializer fetchRequestWithUrlString] request生成失败");
        return nil;
    }
    return request;
}

- (AFHTTPRequestSerializer *)requestSerializer {
    if (!_requestSerializer) {
        _requestSerializer = [AFHTTPRequestSerializer serializer];
        _requestSerializer.timeoutInterval = [JKRAPIConfiguration sharedConfiguration].timeOutSeconds;
        _requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _requestSerializer;
}

@end
