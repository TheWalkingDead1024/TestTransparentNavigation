//
//  SecondViewController.m
//  Test
//
//  Created by luhaobo on 16/8/18.
//  Copyright © 2016年 Yeelink. All rights reserved.
//

#import "SecondViewController.h"
#import "UIViewController+TransparentNavigation.h"
#import "UINavigationBar+Transparent.h"
#import "ThirdViewController.h"

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    [self setMyNavigationBarColor:[UIColor clearColor] lazyShow:NO];
    self.title = @"Two";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setMyNavigationBarColor:[UIColor clearColor] lazyShow:YES];
}

- (IBAction)pushAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ThirdViewController * vc = (ThirdViewController *)[sb instantiateViewControllerWithIdentifier:@"ThirdViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)enableTransparent {
    return YES;
}

@end
