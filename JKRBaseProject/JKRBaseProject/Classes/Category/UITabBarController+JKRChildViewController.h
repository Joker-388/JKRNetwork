//
//  UITabBarController+JKRChildViewController.h
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (JKRChildViewController)

@property (nonatomic) Class navigationControllerClass;
- (void)jkr_addChildViewController:(UIViewController *)childController withTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@end
