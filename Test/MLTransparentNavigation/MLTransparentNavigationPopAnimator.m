//
//  MLTransparentNavigationPopAnimator.m
//  MiLamp
//
//  Created by luhaobo on 16/8/17.
//  Copyright © 2016年 Yeelink. All rights reserved.
//

#import "MLTransparentNavigationPopAnimator.h"
#import "MLTransparentNavigationColorSource.h"
#import "UINavigationBar+Transparent.h"
#import "UIView+Frame.h"

@interface MLTransparentNavigationPopAnimator ()
@property (nonatomic, assign) BOOL animating;
@end

@implementation MLTransparentNavigationPopAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.animating = NO;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning 
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.2f;
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
    
#warning 鲁好波，这里可能存在bug。
    if ([nextColor isEqual:[UIColor clearColor]]) {
        NSLog(@"");
    }
    
    UIView *containerView = [transitionContext containerView];
    UIView *shadowMask = [[UIView alloc] initWithFrame:containerView.bounds];
    shadowMask.backgroundColor = [UIColor blackColor];
    shadowMask.alpha = 0.3;
    
    CGRect finalToFrame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.frame = CGRectOffset(finalToFrame, -finalToFrame.size.width/2, 0);
    
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    [containerView insertSubview:shadowMask aboveSubview:toViewController.view];
    
    BOOL needPushBar = fromViewController.navigationController.tabBarController.tabBar && fromViewController.hidesBottomBarWhenPushed && fromViewController.navigationController.viewControllers.count == 1;
    UITabBar *tabBar = fromViewController.navigationController.tabBarController.tabBar;
    
    if (needPushBar) {
        [fromViewController.navigationController.tabBarController.view sendSubviewToBack:tabBar];
#warning 鲁好波，这个地方有疑问
        tabBar.frame = CGRectMake(toViewController.view.minX, toViewController.view.minY, tabBar.width, tabBar.height);
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    self.animating = YES;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        fromViewController.view.frame = CGRectOffset(fromViewController.view.frame, fromViewController.view.width, 0);
        toViewController.view.frame = finalToFrame;
        shadowMask.alpha = 0.0f;
        if (needPushBar) {
            tabBar.frame = CGRectMake(CGRectGetMinX(finalToFrame), CGRectGetMinY(finalToFrame), tabBar.width, tabBar.height);
        }
        
        if (nextColor) {
            [fromViewController.navigationController.navigationBar df_setBackgroundColor:nextColor];
        }
    } completion:^(BOOL finished) {
        self.animating = NO;
        if (needPushBar) {
            [toViewController.navigationController.tabBarController.view bringSubviewToFront:tabBar];
        }
        [shadowMask removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end
