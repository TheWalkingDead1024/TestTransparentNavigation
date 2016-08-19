//
//  MLTransparentNavigationDragPop.m
//  MiLamp
//
//  Created by luhaobo on 16/8/17.
//  Copyright © 2016年 Yeelink. All rights reserved.
//

#import "MLTransparentNavigationDragPop.h"
#import "MLTransparentNavigationPopAnimator.h"

@interface MLTransparentNavigationDragPop ()
@property (nonatomic, assign) BOOL interacting;
@end

@implementation MLTransparentNavigationDragPop
@synthesize completionSpeed = _completionSpeed;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.interacting = NO;
    }
    return self;
}

#pragma mark - Setter
- (void)setNavigationController:(UINavigationController *)navigationController {
    if (_navigationController != navigationController) {
        _navigationController = navigationController;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_navigationController.view addGestureRecognizer:panGesture];
    }
}

- (void)setCompletionSpeed:(CGFloat)completionSpeed {
    _completionSpeed = completionSpeed;
}
#pragma mark - Getter
- (CGFloat)completionSpeed {
#warning 鲁好波，键盘速度，后半截？
    return MAX((CGFloat)0.5, 1 - self.percentComplete);
}

#pragma mark - Actions
- (void)handlePan:(UIPanGestureRecognizer *)panGesture {
    CGPoint offset = [panGesture translationInView:panGesture.view];
    CGPoint velocity = [panGesture velocityInView:panGesture.view];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            if (!self.popAnimator.animating) {
                self.interacting = YES;
                if (velocity.x > 0 && self.navigationController.viewControllers.count > 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            break;
        case UIGestureRecognizerStateChanged:
            if (self.interacting) {
                CGFloat progress = offset.x/panGesture.view.bounds.size.width;
                progress = MAX(progress, 0);
                [self updateInteractiveTransition:progress];
            }
            break;
        case UIGestureRecognizerStateEnded:
            if (self.interacting) {
                if ([panGesture velocityInView:panGesture.view].x > 0) {
                    [self finishInteractiveTransition];
                } else {
                    [self cancelInteractiveTransition];
                }
                self.interacting = NO;
            }
            break;
        case UIGestureRecognizerStateCancelled:
            if (self.interacting) {
                [self cancelInteractiveTransition];
                self.interacting = NO;
            }
            break;
        default:
            break;
    }
}

@end
