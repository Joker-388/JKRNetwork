//
//  UITabBarController+JKRChildViewController.m
//  JKRBaseProject
//
//  Created by Joker on 2017/4/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "UITabBarController+JKRChildViewController.h"
#import <objc/runtime.h>

@implementation UITabBarController (JKRChildViewController)

static const char *JKR_TAB_BAR_CONTROLLER_CLASS = "JKR_TAB_BAR_CONTROLLER_CLASS";

- (void)jkr_addChildViewController:(UIViewController *)childController withTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    [childController.tabBarItem setImage:image];
    [childController.tabBarItem setSelectedImage:selectedImage];
    childController.tabBarItem.title = title;
    childController.navigationItem.title = title;
    if (self.navigationControllerClass) {
        if ([self.navigationControllerClass isSubclassOfClass:[UINavigationController class]]) {
            id navigationViewController = [[self.navigationControllerClass alloc] initWithRootViewController:childController];
            [self addChildViewController:navigationViewController];
        } else {
            NSAssert(NO, @"%@必须是UINavigationController的子类", NSStringFromClass(self.navigationControllerClass));
        }
    } else {
        [self addChildViewController:childController];
    }
}

- (void)setNavigationControllerClass:(Class)navigationControllerClass {
    objc_setAssociatedObject(self, JKR_TAB_BAR_CONTROLLER_CLASS, navigationControllerClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (Class)navigationControllerClass {
    return objc_getAssociatedObject(self, JKR_TAB_BAR_CONTROLLER_CLASS);
}

@end
