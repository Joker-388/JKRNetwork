//
//  JKRUserView.h
//  JKRBaseProject
//
//  Created by Joker on 2017/4/20.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKRUserViewReformer.h"
#import "JKRUserModel.h"

@interface JKRUserView : UIView

@property (nonatomic, strong) JKRUserViewReformer *userReformer;
@property (nonatomic, strong) JKRUserModel *model;
- (void)configWithData:(NSMutableDictionary *)data;

@end
