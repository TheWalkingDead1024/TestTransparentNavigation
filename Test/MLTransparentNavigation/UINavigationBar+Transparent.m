//
//  UINavigationBar+Transparent.m
//  MiLamp
//
//  Created by luhaobo on 16/8/17.
//  Copyright © 2016年 Yeelink. All rights reserved.
//

#import "UINavigationBar+Transparent.h"
#import <objc/runtime.h>
#import "UIScreen+Frame.h"

static void *kBackgroundViewKey = &kBackgroundViewKey;
static void *kStatusBarMaskKey = &kStatusBarMaskKey;

@implementation UINavigationBar (Transparent)

#pragma mark - Public Functions

- (void)df_setStatusBarMaskColor:(UIColor *)color {
    if (!self.statusBarMask) {
        self.statusBarMask = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen width], 20)];
        if (self.backgroundView) {
            [self insertSubview:self.statusBarMask aboveSubview:self.backgroundView];
        } else {
            [self insertSubview:self.statusBarMask atIndex:0];
        }
        self.statusBarMask.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        [self.statusBarMask mas_makeConstraints:^(MASConstraintMaker *make) {/*Cannot modify constraints for UINavigationBar managed by a controller or will crash*/
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(-20);
//            make.height.mas_equalTo(20);
//        }];
    }
    self.statusBarMask.backgroundColor = color;
}

- (void)df_setBackgroundColor:(UIColor *)color {
    if (!self.backgroundView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.shadowImage = [UIImage new];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen width], 64)];
        self.backgroundView.userInteractionEnabled = NO;
        if (self.statusBarMask) {
            [self insertSubview:self.backgroundView belowSubview:self.statusBarMask];
        } else {
            [self insertSubview:self.backgroundView atIndex:0];
        }
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(-20);
//            make.height.mas_equalTo(64);
//        }];
    }
    self.backgroundView.backgroundColor = color;
}

- (void)df_reset {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    [self.statusBarMask removeFromSuperview];
    self.statusBarMask = nil;
}

#pragma mark - Setter & Getter

- (UIView *)backgroundView {
    return objc_getAssociatedObject(self, &kBackgroundViewKey);
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    [self willChangeValueForKey:@"backgroundView"];
    objc_setAssociatedObject(self, &kBackgroundViewKey, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"backgroundView"];
}

- (UIView *)statusBarMask {
    return objc_getAssociatedObject(self, &kStatusBarMaskKey);
}

- (void)setStatusBarMask:(UIView *)statusBarMask
{
    [self willChangeValueForKey:@"statusBarMask"];
    objc_setAssociatedObject(self, &kStatusBarMaskKey, statusBarMask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"statusBarMask"];
}

@end
