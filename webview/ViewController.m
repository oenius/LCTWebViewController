//
//  ViewController.m
//  progress
//
//  Created by mdy1 on 16/4/8.
//  Copyright © 2016年 yixin. All rights reserved.
//

#import "ViewController.h"
#import "LCTWebViewController.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((screenWidth - 150)/2, (screenHeight - 50)/2, 150, 50)];
    [btn setTitle:@"Trello" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click{
    NSURL *url = [NSURL URLWithString:@"http://www.teambition.com"];
    LCTWebViewController *vc = [[LCTWebViewController alloc]initWithUrl:url];
    vc.trackTintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0];
    vc.tintColor = [UIColor blackColor];
    vc.alwaysPushInNewWebController = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
