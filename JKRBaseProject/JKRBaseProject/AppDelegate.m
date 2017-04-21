//
//  AppDelegate.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/18.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+JKRRootViewController.h"
#import "JKRAPI.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self jkr_configRootViewController];
    [JKRAPIConfiguration sharedConfiguration].baseURL = [NSURL URLWithString:@"http://www.newqsy.com/"];
    return YES;
}

@end
