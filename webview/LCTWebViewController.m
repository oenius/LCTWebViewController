//
//  WebViewController.m
//  progress
//
//  Created by mdy1 on 16/4/11.
//  Copyright © 2016年 yixin. All rights reserved.
//

#import "LCTWebViewController.h"
#import "LCTNavigationController.h"

@interface LCTWebViewController () <UIWebViewDelegate>

@property(nonatomic, assign) BOOL loading;
@property(nonatomic) BOOL isFirstLoadWeb;
@property(nonatomic) BOOL isFirstAddWord;
@property(strong, nonatomic) NSTimer *timer;

@end

@implementation LCTWebViewController


-(id)initWithUrl:(NSURL *)url{
    self.topView = [[UIView alloc]init];
    self.topView.backgroundColor = [UIColor clearColor];
    self.topView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.topView];
    
    self.webView = [[UIWebView alloc]init];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.delegate = self;
    [self.webView setOpaque:NO];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.backgroundColor = [UIColor clearColor];
    [self addLayoutConstraint];
    
    self.isFirstLoadWeb = YES;
    self.isFirstAddWord = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addProgress];
    
    return self;
}


- (void)addProgress
{
    self.progressView = [[UIProgressView alloc]init];
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.webView addSubview:self.progressView];
    self.progressView.tintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0];
    self.progressView.trackTintColor = [UIColor clearColor];
    NSDictionary *viewsDictionary = @{@"webView":self.webView,
                                      @"progressView":self.progressView,
                                      @"view":self.view};
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[progressView]-0-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[progressView(2.0)]"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]];
}

- (void)addLayoutConstraint
{
    NSDictionary *viewsDictionary = @{@"webView":self.webView,
                                      @"topView":self.topView,
                                      @"view":self.view};

    //约束1 横向
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView]-0-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]];
    [self.view addConstraints:
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[topView]-0-|"
                                            options:0
                                            metrics:nil
                                              views:viewsDictionary]];
    //约束2 纵向
    [self.view addConstraints:
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[webView]-0-|"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]];
    [self.view addConstraints:
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[topView]-0-|"
                                            options:0
                                            metrics:nil
                                              views:viewsDictionary]];
}

- (void)addBackgroundWord
{
    
    if (self.isFirstAddWord)
    {
        self.isFirstAddWord = NO;
    }
    else    return;
    self.wordLabel = [[UILabel alloc]init];
    self.wordLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topView addSubview:self.wordLabel];
    self.wordLabel.text = @"网页由XXX提供";
    self.wordLabel.textColor = [UIColor lightGrayColor];
    self.wordLabel.textAlignment = NSTextAlignmentCenter;
    NSDictionary *viewsDictionary = @{@"wordLabel":self.wordLabel};
    [self.view addConstraints:
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[wordLabel]-0-|"
                                                 options:0
                                                 metrics:nil
                                                   views:viewsDictionary]];
    [self.view addConstraints:
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[wordLabel(50.0)]"
                                                 options:0
                                                 metrics:nil
                                                   views:viewsDictionary]];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.isFirstLoadWeb)
    {
        self.isFirstLoadWeb = NO;
    }
    else    return;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.loading = YES;
    self.progressView.progress = 0;
    self.progressView.hidden = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(editprogress) userInfo:nil repeats:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.loading = NO;
    if (!webView.isLoading)
    {
        self.isFirstLoadWeb = YES;
        [self addBackgroundWord];
    }
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
            self.progressView.progress += 0.6;
        }
    }
    else
    {
        self.progressView.progress += 0.3;
        if (self.progressView.progress >= 0.9)
        {
            self.progressView.progress = 0.95;
        }
    }
}

@end
