//
//  WebViewController.h
//  progress
//
//  Created by mdy1 on 16/4/11.
//  Copyright © 2016年 yixin. All rights reserved.
//

#import "ViewController.h"

@interface WebViewController : ViewController

@property(nonatomic,strong) IBOutlet UIWebView *webView;

@property(nonatomic,strong) IBOutlet UIProgressView *progressView;


@property(nonatomic) BOOL loading;
@property(nonatomic) BOOL isLoading;
@property(strong, nonatomic) NSTimer *timer;
@property(nonatomic) NSURL *url;

- (id)initWithUrl:(NSURL *)url;

@end
