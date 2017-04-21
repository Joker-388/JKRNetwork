//
//  JKRAPIConfiguration.h
//  JKRBaseProject
//
//  Created by Joker on 2017/4/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKRAPIConfiguration : NSObject

@property (nonatomic, assign) BOOL shouldReachable;
@property (nonatomic, assign) NSTimeInterval timeOutSeconds;
@property (nonatomic, assign) NSTimeInterval cacheOutSeconds;
@property (nonatomic, strong) NSURL *baseURL;

+ (instancetype)sharedConfiguration;

@end
