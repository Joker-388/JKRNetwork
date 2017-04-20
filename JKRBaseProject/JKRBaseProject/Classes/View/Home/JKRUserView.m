//
//  JKRUserView.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/20.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRUserView.h"

@interface JKRUserView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *tokenLabel;
@property (nonatomic, strong) UILabel *genderLabel;

@end

@implementation JKRUserView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.nameLabel.frame = CGRectMake(0, 0, kScreenWidth - 20, 40);
    self.tokenLabel.frame = CGRectMake(0, 40, kScreenWidth - 20, 40);
    self.genderLabel.frame = CGRectMake(0, 80, kScreenWidth - 20, 40);
    [self addSubview:self.nameLabel];
    [self addSubview:self.tokenLabel];
    [self addSubview:self.genderLabel];
    return self;
}

- (void)configWithData:(NSMutableDictionary *)data {
    self.nameLabel.text = data[kUserKeyName];
    self.tokenLabel.text = data[kUserKeyToken];
    self.genderLabel.text = data[kUserGender];
}

- (JKRUserViewReformer *)userReformer {
    if (!_userReformer) {
        _userReformer = [[JKRUserViewReformer alloc] init];
    }
    return _userReformer;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UILabel *)tokenLabel {
    if (!_tokenLabel) {
        _tokenLabel = [[UILabel alloc] init];
    }
    return _tokenLabel;
}

- (UILabel *)genderLabel {
    if (!_genderLabel) {
        _genderLabel = [[UILabel alloc] init];
    }
    return _genderLabel;
}

@end
