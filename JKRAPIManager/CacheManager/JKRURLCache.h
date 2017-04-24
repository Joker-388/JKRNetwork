//
//  JKRURLCache.h
//  JKRBaseProject
//
//  Created by Lucky on 2017/4/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKRURLCache : NSObject<NSCoding>

@property (nonatomic, strong) NSDictionary *content;
@property (nonatomic, assign) NSInteger cacheTime;

@end
