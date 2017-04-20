//
//  JKRURLResponse.h
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKRURLResponse : NSObject

@property (nonatomic, copy, readwrite) NSDictionary *content;
@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, assign) JKRRequestID requestID;

- (instancetype)initWithResponse:(id)response;
- (instancetype)initWithError:(NSError *)error;

@end
