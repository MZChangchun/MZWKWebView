//
//  ViewController.m
//  MZWKWebView
//
//  Created by Mr.Yang on 16/7/7.
//  Copyright © 2016年 MZ. All rights reserved.
//

#import "ViewController.h"
#import "YYWeb.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidAppear:(BOOL)animated {
    YYWeb * web = [[YYWeb alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:web] animated:1 completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
