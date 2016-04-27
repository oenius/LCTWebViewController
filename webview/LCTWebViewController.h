//
//  WebViewController.h
//  progress
//
//  Created by mdy1 on 16/4/11.
//  Copyright © 2016年 yixin. All rights reserved.
//

#import "ViewController.h"

@interface LCTWebViewController : UIViewController

@property(nonatomic,strong) UIWebView *webView;

@property(nonatomic,strong) UIProgressView *progressView;

@property(nonatomic,strong) UIView *topView;

@property(nonatomic,strong) UILabel *wordLabel;


@property(nonatomic) NSURL *url;

- (id)initWithUrl:(NSURL *)url;

@end
