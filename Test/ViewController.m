//
//  ViewController.m
//  Test
//
//  Created by luhaobo on 16/8/18.
//  Copyright © 2016年 Yeelink. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "UIViewController+TransparentNavigation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor yellowColor];
    [self setMyNavigationBarColor:[UIColor blueColor] lazyShow:NO];
    self.title = @"One";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setMyNavigationBarColor:[UIColor blueColor] lazyShow:YES];
}

- (IBAction)pushAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondViewController * vc = (SecondViewController *)[sb instantiateViewControllerWithIdentifier:@"SecondViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
