//
//  ViewController.m
//  progress
//
//  Created by mdy1 on 16/4/8.
//  Copyright © 2016年 yixin. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((screenWidth - 150)/2, (screenHeight - 50)/2, 150, 50)];
    [btn setTitle:@"百度一下" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    WebViewController *vc = [[WebViewController alloc]initWithUrl:url];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
