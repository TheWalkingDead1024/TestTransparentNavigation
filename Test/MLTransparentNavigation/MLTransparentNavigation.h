//
//  MLTransparentNavigation.h
//  MiLamp
//
//  Created by luhaobo on 16/8/17.
//  Copyright © 2016年 Yeelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TransparentNavigationDelegate <NSObject>
@optional
- (BOOL)getRealTimeEnableTransparentNavigation;
- (void)mlNavigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController;
@end

@interface MLTransparentNavigation : NSObject<UINavigationControllerDelegate>
@property (nonatomic, weak) id<TransparentNavigationDelegate> transparentDelegate;
- (void)setEnableTransparentNavigation:(BOOL)enableTransparentNavigation navigationController:(UINavigationController *)navigationController;
@end
