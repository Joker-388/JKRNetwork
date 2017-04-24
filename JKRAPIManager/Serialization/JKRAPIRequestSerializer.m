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
    } else if (type == JKRRequestTypeUpload) {
        methodString = @"POST";
        return [self fecthUploadRequestWithUrlString:urlString parameters:parameters method:methodString];
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

- (NSMutableURLRequest *)fecthUploadRequestWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters method:(NSString *)method {
    NSError *serializerError = nil;
    NSString *urlString1 = [[NSURL URLWithString:urlString relativeToURL:[JKRAPIConfiguration sharedConfiguration].baseURL] absoluteString];
    NSMutableDictionary *uploadParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSMutableArray *imageArray = [NSMutableArray array];
    __block NSString *fileName = nil;
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImage class]]) {
            fileName = (NSString *)key;
            [uploadParameters removeObjectForKey:key];
            [imageArray addObject:obj];
            *stop = YES;
        }
        if ([obj isKindOfClass:[NSArray class]] && [[(NSArray *)obj firstObject] isKindOfClass:[UIImage class]]) {
            [(NSArray *)obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[UIImage class]]) {
                    [imageArray addObject:obj];
                }
            }];
            fileName = (NSString *)key;
            [uploadParameters removeObjectForKey:key];
            *stop = YES;
        }
    }];
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlString1 parameters:uploadParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *data = UIImagePNGRepresentation(obj);
            [formData appendPartWithFileData:data name:fileName fileName:[NSString stringWithFormat:@"%zd", idx] mimeType:@"image/png"];
        }];
    } error:&serializerError];
    request.timeoutInterval = [JKRAPIConfiguration sharedConfiguration].timeOutSeconds;
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
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
