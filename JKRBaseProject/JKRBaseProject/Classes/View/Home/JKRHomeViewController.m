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

@interface JKRHomeViewController ()<JKRAPIManagerCallBackDelegate, JKRAPIManagerParametersSource>

@property (nonatomic, strong) JKRLoginAPI *loginAPI;
@property (nonatomic, strong) JKRRegisterAPI *registerAPI;
@property (nonatomic, strong) JKRUserAPI *userAPI;
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
}

- (void)registerClick {
    [self.registerAPI loadData];
}

- (void)loginClick {
    [self.loginAPI loadData];
}

- (void)getUserInfo {
    [self.userAPI loadData];
}

- (NSDictionary *)parametersForApiManager:(__kindof JKRAPIManager *)manager {
//    return @{PARAMETERS_LOGINAPI_USERNAME_KEY:@"joker", PARAMETERS_LOGINAPI_PASSWORD_KEY:@"qq123456", PARAMETERS_LOGINAPI_USERTYPE_KEY:@"consumer"};
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
        NSLog(@"Register Success:%@", [manager fetchData]);
    } else if (manager == self.loginAPI) {
        NSLog(@"Login Success:%@", [manager fetchData]);
        if (![manager.fetchData[@"data"] isKindOfClass:[NSNull class]]) {
            self.token = manager.fetchData[@"data"][@"token"] ? manager.fetchData[@"data"][@"token"] : @"";
        }
    } else if (manager == self.userAPI) {
        NSLog(@"Get info Success:%@", [manager fetchData]);
    }
}

- (void)apiManagerRequestFailed:(__kindof JKRAPIManager *)manager {
    if (manager == self.registerAPI) {
        NSLog(@"Register Failed:%@", [manager fetchError]);
    } else if (manager == self.loginAPI) {
        NSLog(@"Login Failed:%@", [manager fetchError]);
    } else if (manager == self.userAPI) {
        NSLog(@"Get info Failed:%@", [manager fetchError]);
    }
}

- (void)apiManagerRequestParametersError:(__kindof JKRAPIManager *)manager {
    if (manager == self.registerAPI) {
        NSLog(@"Register ParamaterError:%@", [manager fetchError]);
    } else if (manager == self.loginAPI) {
        NSLog(@"Login ParamaterError:%@", [manager fetchError]);
    } else if (manager == self.userAPI) {
        NSLog(@"Get info ParamaterError:%@", [manager fetchError]);
    }
}

- (void)apiManagerRequestCancel:(__kindof JKRAPIManager *)manager {
    if (manager == self.registerAPI) {
        NSLog(@"Register Cancel:%@", [manager fetchError]);
    } else if (manager == self.loginAPI) {
        NSLog(@"Login Cancel:%@", [manager fetchError]);
    } else if (manager == self.userAPI) {
        NSLog(@"Get info Cancel:%@", [manager fetchError]);
    }
}

- (void)apiManagerRequestTokenInvalid:(__kindof JKRAPIManager *)manager {
    if (manager == self.registerAPI) {
        NSLog(@"Register TokenInvalid:%@", [manager fetchError]);
    } else if (manager == self.loginAPI) {
        NSLog(@"Login TokenInvalid:%@", [manager fetchError]);
    } else if (manager == self.userAPI) {
        NSLog(@"Get info TokenInvalid:%@", [manager fetchError]);
    }
}

- (JKRLoginAPI *)loginAPI {
    if (!_loginAPI) {
        _loginAPI = [[JKRLoginAPI alloc] init];
        _loginAPI.parametersSource = self;
        _loginAPI.delegate = self;
        _loginAPI.cancelLoadWhenResend = YES;
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
    }
    return _userAPI;
}

@end