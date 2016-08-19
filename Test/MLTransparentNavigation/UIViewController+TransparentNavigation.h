//
//  UIViewController+TransparentNavigation.h
//  MiLamp
//
//  Created by luhaobo on 16/8/17.
//  Copyright © 2016年 Yeelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLTransparentNavigationColorSource.h"
#import "MLTransparentNavigation.h"

@protocol TransparentNavigation <NSObject>
@optional
- (BOOL)enableTransparent;
@end

@class MLTransparentNavigation;
@interface UIViewController (TransparentNavigation)<MLTransparentNavigationColorSource, TransparentNavigationDelegate, TransparentNavigation>
//- (BOOL)enableTransparent;/*category中不实现此方法，引用到该category的UIViewController要实现此方法*/
//- (BOOL)enableTransparentNavigation;
//- (void)setEnableTransparentNavigation:(BOOL)enableTransparentNavigation;
- (void)setMyNavigationBarColor:(UIColor *)color lazyShow:(BOOL)lazyShow;
@end
