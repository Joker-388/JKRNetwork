//
//  JKRAPITerminal.h
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "JKRURLResponse.h"
#import "JKRAPIHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JKRAPICallBack)(JKRURLResponse *response);

@interface JKRAPITerminal : NSObject

+ (instancetype)sharedTerminal;

- (JKRRequestID)sendAPIWithURLString:(NSString *)URLString
                              type:(JKRRequestType)type
                          parameters:(NSDictionary *)parameters
                             success:(JKRAPICallBack)success
                             failure:(JKRAPICallBack)failure;
- (void)cancelRequestWithRequestID:(JKRRequestID)requestID;

@end

NS_ASSUME_NONNULL_END
