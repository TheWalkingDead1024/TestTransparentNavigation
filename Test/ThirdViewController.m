//
//  ThirdViewController.m
//  Test
//
//  Created by luhaobo on 16/8/18.
//  Copyright © 2016年 Yeelink. All rights reserved.
//

#import "ThirdViewController.h"
#import "UIViewController+TransparentNavigation.h"
#import "UINavigationBar+Transparent.h"
#import "FourthViewController.h"

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor greenColor];
//    [self setMyNavigationBarColor:[UIColor purpleColor] lazyShow:NO];
    self.title = @"Three";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self setMyNavigationBarColor:[UIColor purpleColor] lazyShow:YES];
}

- (IBAction)pushAction:(id)sender {
    //    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    ThirdViewController * vc = (ThirdViewController *)[sb instantiateViewControllerWithIdentifier:@"ThirdViewController"];
    FourthViewController *vc = [[FourthViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
