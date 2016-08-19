//
//  UIViewController+TransparentNavigation.m
//  MiLamp
//
//  Created by luhaobo on 16/8/17.
//  Copyright © 2016年 Yeelink. All rights reserved.
//

#import "UIViewController+TransparentNavigation.h"
#import <objc/runtime.h>
#import "MLTransparentNavigation.h"
#import "UINavigationBar+Transparent.h"

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

static void *kTransparentNavigationKey = &kTransparentNavigationKey;
//static void *kEnableTransparentNavigationKey = &kEnableTransparentNavigationKey;
static void *kMyNavigationBarColorKey = &kMyNavigationBarColorKey;

@implementation UIViewController (TransparentNavigation)
+ (void)load {
    swizzleMethod([self class], @selector(viewDidLoad), @selector(swizzledTransparentNavigation_viewDidLoad));
}

- (void)swizzledTransparentNavigation_viewDidLoad {
    [self swizzledTransparentNavigation_viewDidLoad];
    if ([self respondsToSelector:@selector(enableTransparent)]) {
        if ([self enableTransparent]) {
            [self.transparentNavigation setEnableTransparentNavigation:[self enableTransparent] navigationController:self.navigationController];
        } else {
//            [self removeTransparentNavigation];
        }
    } else {
//        [self removeTransparentNavigation];
    }

}

#pragma mark - Public Functions
- (void)removeTransparentNavigation {
    [self.transparentNavigation setEnableTransparentNavigation:NO navigationController:nil];
    self.transparentNavigation = nil;
    self.transparentNavigation.transparentDelegate = nil;
    [self.navigationController.navigationBar df_reset];
}

- (void)setMyNavigationBarColor:(UIColor *)color lazyShow:(BOOL)lazyShow {
    if (!lazyShow) {
        [self.navigationController.navigationBar df_setBackgroundColor:color];
    }
    self.myNavigationBarColor = color;
}

#pragma mark - Setter & Getter
- (MLTransparentNavigation *)transparentNavigation {
    MLTransparentNavigation *transparentNavigation = objc_getAssociatedObject(self, &kTransparentNavigationKey);
    if (!transparentNavigation) {
        transparentNavigation = [[MLTransparentNavigation alloc] init];
        self.transparentNavigation = transparentNavigation;
        self.transparentNavigation.transparentDelegate = self;
    }
    
    return transparentNavigation;
}

- (void)setTransparentNavigation:(MLTransparentNavigation *)transparentNavigation
{
    [self willChangeValueForKey:@"transparentNavigation"];
    objc_setAssociatedObject(self, &kTransparentNavigationKey, transparentNavigation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"transparentNavigation"];
}

//- (BOOL)enableTransparentNavigation {
//    BOOL enableTransparentNavigation = [objc_getAssociatedObject(self, &kEnableTransparentNavigationKey) boolValue];
//
//    return enableTransparentNavigation;
//}
//
//- (void)setEnableTransparentNavigation:(BOOL)enableTransparentNavigation
//{
//    [self willChangeValueForKey:@"enableTransparentNavigation"];
//
//    if (enableTransparentNavigation) {
//        [self.transparentNavigation setEnableTransparentNavigation:enableTransparentNavigation navigationController:self.navigationController];
//    } else {
//        [self removeTransparentNavigation];
//    }
//    objc_setAssociatedObject(self, &kEnableTransparentNavigationKey, @(enableTransparentNavigation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self didChangeValueForKey:@"enableTransparentNavigation"];
//}

- (UIColor *)myNavigationBarColor {
    return objc_getAssociatedObject(self, &kMyNavigationBarColorKey);
}

- (void)setMyNavigationBarColor:(UIColor *)color
{
    if (color != self.myNavigationBarColor) {

        [self willChangeValueForKey:@"myNavigationBarColor"];
        objc_setAssociatedObject(self, &kMyNavigationBarColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"myNavigationBarColor"];
    }
}

#pragma mark - MLTransparentNavigationColorSource
- (UIColor *)navigationBarColor {
    if (self.myNavigationBarColor) {
        return self.myNavigationBarColor;
    } else if (self.navigationController.navigationBar.backgroundColor) {
        return self.navigationController.navigationBar.backgroundColor;
    } else {
        return [UIColor clearColor];
    }
}

//#pragma mark - TransparentNavigationDelegate
//- (BOOL)getRealTimeEnableTransparentNavigation {
//    return self.enableTransparentNavigation;
//}
//
//- (void)mlNavigationController:(UINavigationController *)navigationController
//         didShowViewController:(UIViewController *)viewController {
//    if (!self.enableTransparentNavigation) {
//        [self.navigationController.navigationBar df_reset];
//    }
//}

@end
