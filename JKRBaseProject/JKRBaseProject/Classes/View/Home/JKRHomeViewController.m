//
//  JKRHomeViewController.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRHomeViewController.h"
#import "JKRRegisterAPI.h"
#import "JKRLoginAPI.h"
#import "JKRUserAPI.h"
#import "JKRUserView.h"

@interface JKRHomeViewController ()<JKRAPIManagerCallBackDelegate, JKRAPIManagerParametersSource>

@property (nonatomic, strong) JKRLoginAPI *loginAPI;
@property (nonatomic, strong) JKRRegisterAPI *registerAPI;
@property (nonatomic, strong) JKRUserAPI *userAPI;

@property (nonatomic, strong) JKRUserView *userView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *token;

@end

@implementation JKRHomeViewController {
    JKRRequestID _requestID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Register" forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 70, 100, 40);
    [button addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:@"Login" forState:UIControlStateNormal];
    button1.frame = CGRectMake(10, 130, 100, 40);
    [button1 addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"Change" forState:UIControlStateNormal];
    button2.frame = CGRectMake(10, 190, 100, 40);
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button3 setTitle:@"Get Info" forState:UIControlStateNormal];
    button3.frame = CGRectMake(120, 70, 100, 40);
    [button3 addTarget:self action:@selector(getUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor redColor];
    textField.frame = CGRectMake(10, 250, 100, 40);
    [self.view addSubview:textField];
    self.textField = textField;
    
    self.userView = [[JKRUserView alloc] init];
    self.userView.frame = CGRectMake(10, 300, kScreenWidth - 20, 120);
    [self.view addSubview:self.userView];
}

- (void)registerClick {
    [self.registerAPI loadData];
}

- (void)loginClick {
    [self.loginAPI loadData];
}

- (void)getUserInfo {
    NSLog(@"***Get User Info");
    [self.userAPI loadData];
}

- (NSDictionary *)parametersForApiManager:(__kindof JKRAPIManager *)manager {
    if (manager == self.registerAPI) {
        return @{@"username":self.textField.text, @"password":@"qq123456", @"user_type":@"consumer"};
    } else if (manager == self.loginAPI) {
        return @{@"username":self.textField.text, @"password":@"qq123456"};
    } else if (manager == self.userAPI) {
        return @{@"token":self.token ? self.token : @"333", @"category":@"business_card"};
    }
    return nil;
}

- (void)apiManagerRequestSuccess:(__kindof JKRAPIManager *)manager {
    if (manager == self.registerAPI) {
        NSLog(@"Register Success:%@", [manager fetchOriginalData]);
    } else if (manager == self.loginAPI) {
        NSLog(@"Login Success:%@", [manager fetchOriginalData]);
        if (![manager.fetchOriginalData[@"data"] isKindOfClass:[NSNull class]]) {
            self.token = manager.fetchOriginalData[@"data"][@"token"] ? manager.fetchOriginalData[@"data"][@"token"] : @"";
        }
        NSMutableDictionary *userViewData = [manager fetchDataWithReformer:self.userView.userReformer];
        [self.userView configWithData:userViewData];
    } else if (manager == self.userAPI) {
        NSLog(@"Get info Success:%@", [manager fetchOriginalData]);
    }
}

- (void)apiManagerRequestFailed:(__kindof JKRAPIManager *)manager {
    if (manager == self.registerAPI) {
        NSLog(@"Register Failed:%@", [manager fetchOriginalError]);
    } else if (manager == self.loginAPI) {
        NSLog(@"Login Failed:%@", [manager fetchOriginalError]);
    } else if (manager == self.userAPI) {
        NSLog(@"Get info Failed:%@", [manager fetchOriginalError]);
    }
}

- (void)apiManagerRequestParametersError:(__kindof JKRAPIManager *)manager {
    if (manager == self.registerAPI) {
        NSLog(@"Register ParamaterError:%@", [manager fetchOriginalError]);
    } else if (manager == self.loginAPI) {
        NSLog(@"Login ParamaterError:%@", [manager fetchOriginalError]);
    } else if (manager == self.userAPI) {
        NSLog(@"Get info ParamaterError:%@", [manager fetchOriginalError]);
    }
}

- (void)apiManagerRequestCancel:(__kindof JKRAPIManager *)manager {
    if (manager == self.registerAPI) {
        NSLog(@"Register Cancel:%@", [manager fetchOriginalError]);
    } else if (manager == self.loginAPI) {
        NSLog(@"Login Cancel:%@", [manager fetchOriginalError]);
    } else if (manager == self.userAPI) {
        NSLog(@"Get info Cancel:%@", [manager fetchOriginalError]);
    }
}

- (void)apiManagerRequestTokenInvalid:(__kindof JKRAPIManager *)manager {
    if (manager == self.registerAPI) {
        NSLog(@"Register TokenInvalid:%@", [manager fetchOriginalError]);
    } else if (manager == self.loginAPI) {
        NSLog(@"Login TokenInvalid:%@", [manager fetchOriginalError]);
    } else if (manager == self.userAPI) {
        NSLog(@"Get info TokenInvalid:%@", [manager fetchOriginalError]);
    }
}

- (JKRLoginAPI *)loginAPI {
    if (!_loginAPI) {
        _loginAPI = [[JKRLoginAPI alloc] init];
        _loginAPI.parametersSource = self;
        _loginAPI.delegate = self;
        _loginAPI.cancelLoadWhenResend = YES;
        _loginAPI.cachePolicy = JKRApiCachePolicyLoadCacheIfNotTimeout;
    }
    return _loginAPI;
}

- (JKRRegisterAPI *)registerAPI {
    if (!_registerAPI) {
        _registerAPI = [[JKRRegisterAPI alloc] init];
        _registerAPI.delegate = self;
        _registerAPI.parametersSource = self;
    }
    return _registerAPI;
}

- (JKRUserAPI *)userAPI {
    if (!_userAPI) {
        _userAPI = [[JKRUserAPI alloc] init];
        _userAPI.delegate = self;
        _userAPI.parametersSource = self;
//        _userAPI.cachePolicy = JKRApiCachePolicyLoadCacheIfLoadFail;
    }
    return _userAPI;
}

- (void)dealloc {
    NSLog(@"Controller dealloc");
}

@end
