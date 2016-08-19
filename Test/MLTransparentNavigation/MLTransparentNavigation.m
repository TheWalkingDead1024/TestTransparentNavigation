//
//  MLTransparentNavigation.m
//  MiLamp
//
//  Created by luhaobo on 16/8/17.
//  Copyright © 2016年 Yeelink. All rights reserved.
//

#import "MLTransparentNavigation.h"
#import "MLTransparentNavigationDragPop.h"
#import "MLTransparentNavigationPushAnimator.h"
#import "MLTransparentNavigationPopAnimator.h"
#import "UIViewController+TransparentNavigation.h"

@interface MLTransparentNavigation ()
#warning 鲁好波，这里为什么也是weak
@property (nonatomic, assign) BOOL enableTransparentNavigation;
@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, strong) MLTransparentNavigationDragPop *dragPop;
@property (nonatomic, strong) MLTransparentNavigationPushAnimator *pushAnimator;
@property (nonatomic, strong) MLTransparentNavigationPopAnimator *popAnimator;
@property (nonatomic, weak) id<TransparentNavigationDelegate> lastTransparentDelegate;

@end

@implementation MLTransparentNavigation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pushAnimator = [[MLTransparentNavigationPushAnimator alloc] init];
        self.popAnimator = [[MLTransparentNavigationPopAnimator alloc] init];
        self.dragPop = [[MLTransparentNavigationDragPop alloc] init];
        self.dragPop.popAnimator = self.popAnimator;
    }
    return self;
}

#pragma mark - Public Functions
- (void)wireTo:(UINavigationController *)navigationController {
    self.dragPop.navigationController = navigationController;
    self.navigationController.delegate = self;
}

- (void)unwireTo {
    self.dragPop.navigationController = nil;
    self.navigationController.delegate = nil;
}

- (void)setEnableTransparentNavigation:(BOOL)enableTransparentNavigation navigationController:(UINavigationController *)navigationController {
    self.navigationController = navigationController;
    self.enableTransparentNavigation = enableTransparentNavigation;
}

#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  {
    BOOL fromVCEnableTransparent = NO;
    BOOL toVCEnableTransparent = NO;
    if ([fromVC respondsToSelector:@selector(enableTransparent)]) {
        fromVCEnableTransparent = [fromVC enableTransparent];
    }
    
    if ([toVC respondsToSelector:@selector(enableTransparent)]) {
        toVCEnableTransparent = [toVC enableTransparent];
    }
    
    if (toVCEnableTransparent) {
        self.enableTransparentNavigation = YES;
    } else if (fromVCEnableTransparent && !toVCEnableTransparent) {
        self.enableTransparentNavigation = YES;
    } else {
        self.enableTransparentNavigation = NO;
    }
    
    if (self.enableTransparentNavigation) {
        if (UINavigationControllerOperationPop == operation) {
            return self.popAnimator;
        } else {
            return self.pushAnimator;
        }
    } else {
        return nil;
    }

}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    if (self.enableTransparentNavigation) {
        return self.dragPop.interacting?self.dragPop:nil;
    } else {
        return nil;
    }
}

//- (void)navigationController:(UINavigationController *)navigationController
//      didShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animated {
//    if (self.transparentDelegate && self.transparentDelegate != self.lastTransparentDelegate && [self.transparentDelegate respondsToSelector:@selector(getRealTimeEnableTransparentNavigation)]) {
//        self.enableTransparentNavigation = [self.transparentDelegate getRealTimeEnableTransparentNavigation];
//    } else {
//        self.enableTransparentNavigation = NO;
//    }
//    
//    if (self.transparentDelegate && self.transparentDelegate != self.lastTransparentDelegate && [self.transparentDelegate respondsToSelector:@selector(mlNavigationController:didShowViewController:)]) {
//        [self.transparentDelegate mlNavigationController:navigationController didShowViewController:viewController];
//    }
//    
//}

#pragma mark - Setter & Getter
- (void)setEnableTransparentNavigation:(BOOL)enableTransparentNavigation {
    if (_enableTransparentNavigation != enableTransparentNavigation) {
        _enableTransparentNavigation = enableTransparentNavigation;
    }
    
    if (enableTransparentNavigation) {
        [self wireTo:self.navigationController];
    } else {
        [self unwireTo];
    }
}

//- (void)setTransparentDelegate:(id<TransparentNavigationDelegate>)transparentDelegate {
//    if (_transparentDelegate != transparentDelegate) {
//        self.lastTransparentDelegate = _transparentDelegate;
//        _transparentDelegate = transparentDelegate;
//    }
//}

@end
