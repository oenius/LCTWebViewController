//
//  WebViewController.m
//  progress
//
//  Created by mdy1 on 16/4/11.
//  Copyright © 2016年 yixin. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@end

@implementation WebViewController

-(id)initWithUrl:(NSURL *)url{
  self.automaticallyAdjustsScrollViewInsets = YES;
  self.edgesForExtendedLayout = UIRectEdgeAll;
//
//    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
//    self.webView.delegate = self;
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//  
//  //VFL |-(0)-view-(0)-| | mansory
//  
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.webView];
//    
//    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2.0)];
//    [self.webView addSubview:self.progressView];
//    self.progressView.tintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0];
//    self.progressView.trackTintColor = [UIColor clearColor];
  
    return self;
}

- (void)loadView
{
  UIWebView *webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
  [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
  self.view = webView;
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    self.progressView.progress = 0;
    self.progressView.hidden = NO;
    self.loading = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(editprogress) userInfo:nil repeats:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.loading = NO;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)editprogress
{
    if (!self.loading)
    {
        if (self.progressView.progress >= 1)
        {
            self.progressView.hidden = YES;
            [self.timer invalidate];
        }
        else
        {
            self.progressView.progress += 0.5;
        }
    }
    else
    {
        self.progressView.progress += 0.05;
        if (self.progressView.progress >= 0.9)
        {
            self.progressView.progress = 0.9;
        }
    }
}

@end
