//
//  JKRTabBarViewController.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRTabBarViewController.h"
#import "UITabBarController+JKRChildViewController.h"
#import "JKRHomeViewController.h"
#import "JKRMeViewController.h"
#import "JKRRootViewController.h"

@interface JKRTabBarViewController ()

@end

@implementation JKRTabBarViewController

- (instancetype)init {
    self = [super init];
    self.navigationControllerClass = NSClassFromString(@"JKRNavigationController");
//    [self jkr_addChildViewController:[[JKRHomeViewController alloc] init] withTitle:@"Home" image:[UIImage imageNamed:@"tabbar_mainframe"] selectedImage:[UIImage imageNamed:@"tabbar_mainframeHL"]];
    [self jkr_addChildViewController:[[JKRRootViewController alloc] init] withTitle:@"Home" image:[UIImage imageNamed:@"tabbar_mainframe"] selectedImage:[UIImage imageNamed:@"tabbar_mainframeHL"]];
    [self jkr_addChildViewController:[[JKRMeViewController alloc] init] withTitle:@"Me" image:[UIImage imageNamed:@"tabbar_me"] selectedImage:[UIImage imageNamed:@"tabbar_meHL"]];
    return self;
}

@end
