//
//  JKRUploadAPI.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/24.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRUploadAPI.h"

@implementation JKRUploadAPI

- (JKRRequestType)apiRequestType {
    return JKRRequestTypeUpload;
}

- (NSString *)apiUrl {
//    return @"http://easyprint.cdn.tronsis.com/open-cdn/ssl/data/write";
    return @"http://www.newqsy.com/open-cdn/ssl/data/write";
}

@end
