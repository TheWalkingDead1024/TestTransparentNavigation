//
//  MLTransparentNavigationDragPop.h
//  MiLamp
//
//  Created by luhaobo on 16/8/17.
//  Copyright © 2016年 Yeelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLTransparentNavigationPopAnimator;
@interface MLTransparentNavigationDragPop : UIPercentDrivenInteractiveTransition
@property (nonatomic, readonly) BOOL interacting;
@property (nonatomic, weak) MLTransparentNavigationPopAnimator *popAnimator;
@property (nonatomic, weak) UINavigationController *navigationController;
@end
