//
//  MLTransparentNavigationPushAnimator.m
//  MiLamp
//
//  Created by luhaobo on 16/8/17.
//  Copyright © 2016年 Yeelink. All rights reserved.
//

#import "MLTransparentNavigationPushAnimator.h"
#import "MLTransparentNavigationColorSource.h"
#import "UINavigationBar+Transparent.h"
#import "UIView+Frame.h"

@implementation MLTransparentNavigationPushAnimator

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //    id<MLTransparentNavigationColorSource> fromColorSource;
    id<MLTransparentNavigationColorSource> toColorSource;
    
    //    if ([fromViewController conformsToProtocol:@protocol(MLTransparentNavigationColorSource)]) {
    //        fromColorSource = (id<MLTransparentNavigationColorSource>)fromViewController;
    //    }
    
    if ([toViewController conformsToProtocol:@protocol(MLTransparentNavigationColorSource)]) {
        toColorSource = (id<MLTransparentNavigationColorSource>)toViewController;
    }
    
    UIColor *nextColor;
    if ([toColorSource respondsToSelector:@selector(navigationBarColor)]) {
        nextColor = [toColorSource navigationBarColor];
    }
    
    UIView *containerView = [transitionContext containerView];
    UIView *shadowMask = [[UIView alloc] initWithFrame:containerView.bounds];
    shadowMask.backgroundColor = [UIColor blackColor];
    shadowMask.alpha = 0.0;
    [containerView addSubview:shadowMask];
    [containerView addSubview:toViewController.view];
    
    CGRect originalFromFrame = fromViewController.view.frame;
    CGRect finalToFrame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.frame = CGRectOffset(finalToFrame, finalToFrame.size.width, 0);
    
#warning 鲁好波，navigationcontroller的childviewcontrollers和viewcontrollers是一样的吗？打印出来貌似是一样的。
    BOOL needPushBar = toViewController.navigationController.tabBarController && toViewController.navigationController.childViewControllers.count == 2 && toViewController.hidesBottomBarWhenPushed;
    UITabBar *tabBar = toViewController.navigationController.tabBarController.tabBar;
    
    if (needPushBar) {
        [toViewController.navigationController.tabBarController.view sendSubviewToBack:tabBar];
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        toViewController.view.frame = finalToFrame;
        fromViewController.view.frame = CGRectOffset(originalFromFrame, -originalFromFrame.size.width/2, 0);
        shadowMask.alpha = 0.3f;
        if (needPushBar) {
            tabBar.frame = CGRectMake(fromViewController.view.minX, fromViewController.view.minY, tabBar.width, tabBar.height);
        }
        
        if (nextColor) {
            [fromViewController.navigationController.navigationBar df_setBackgroundColor:nextColor];
        }
    } completion:^(BOOL finished) {
#warning 鲁好波，这段代码写的很奇怪
        if (needPushBar) {
            [toViewController.navigationController.tabBarController.view bringSubviewToFront:tabBar];
        }
        [shadowMask removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end
