//
//  WebViewController.m
//  progress
//
//  Created by mdy1 on 16/4/11.
//  Copyright © 2016年 yixin. All rights reserved.
//

#import "LCTWebViewController.h"

typedef void (^void_block_operation_t)(void);

void delay(CGFloat seconds, void_block_operation_t square)
{
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * (double)(NSEC_PER_SEC)));
  dispatch_after(popTime, dispatch_get_main_queue(), square);
}

@interface LCTWebViewController ()
<
UIWebViewDelegate
>
{
  UIColor *_trackTintColor;
  UIColor *_tintColor;
}
@property BOOL shouldPopItemAfterPopViewController;

@property(nonatomic, weak) id<UINavigationBarDelegate> previousDelegate;

@property(nonatomic,strong) UIWebView *webView;

@property(nonatomic,strong) UIView *progressView;
@property(nonatomic,strong) NSLayoutConstraint *progressWidthConstraint;

@property(nonatomic,strong) UILabel *wordLabel;

@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) UIButton *closeBtn;
@property(nonatomic, strong) UIButton *moreBtn;

@property(nonatomic, strong) UIButton *refreshBtn;
@property(nonatomic, strong) UILabel *refreshLabel;

@end

@implementation LCTWebViewController

-(id)initWithUrl:(NSURL *)url{
  
  self.url = url;
  
  return self;
}

- (void)loadView
{
  self.view = [[UIWebView alloc]initWithFrame:CGRectZero];
  
  self.automaticallyAdjustsScrollViewInsets = YES;
  self.edgesForExtendedLayout = UIRectEdgeAll;
  
  _webView = (UIWebView *)self.view;
  _webView.delegate = self;
  
  [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
  
  for (UIView *subView in [_webView subviews])
  {
    if ([subView isKindOfClass:[UIScrollView class]])
    {
      for (UIView *shadowView in [subView subviews])
      {
        if ([shadowView isKindOfClass:[UIImageView class]])
        {
          [shadowView setHidden:YES];
        }
      }
    }
  }
  
  _webView.opaque = NO;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  //layout navigation bar
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setFrame:CGRectMake(0, 0, 44, 64)];

  [button setImage:[UIImage imageNamed:@"icon_app_back"] forState:UIControlStateNormal];
  [button setBackgroundColor:[UIColor clearColor]];
  [button setContentMode:UIViewContentModeLeft];
  
  [button addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
  self.backBtn = button;
  
  UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
  [close setFrame:CGRectMake(0, 0, 44, 84)];
  
  [close setTitle:@"关闭" forState:UIControlStateNormal];
  close.titleLabel.font = [UIFont systemFontOfSize:12.f];
  [close setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [close setBackgroundColor:[UIColor clearColor]];
  [close setContentMode:UIViewContentModeLeft];
  [close addTarget:self action:@selector(handleClose) forControlEvents:UIControlEventTouchUpInside];
  self.closeBtn = close;
  
  UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
  [more setFrame:CGRectMake(0, 0, 44, 84)];
  [more setImage:[UIImage imageNamed:@"icon_app_more"] forState:UIControlStateNormal];
  [more addTarget:self action:@selector(handleMore) forControlEvents:UIControlEventTouchUpInside];
  [more setBackgroundColor:[UIColor clearColor]];
  [more setContentMode:UIViewContentModeRight];
  self.moreBtn = more;
  
  UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
  [spaceItem setWidth:-17];
  
  self.navigationItem.leftBarButtonItems =@[
                                            spaceItem,
                                            [[UIBarButtonItem alloc]initWithCustomView:button],
                                            [[UIBarButtonItem alloc]initWithCustomView:close],
                                            ];
  
  self.navigationItem.rightBarButtonItems = @[
                                             spaceItem,
                                             [[UIBarButtonItem alloc]initWithCustomView:more],
                                             ];
  
  self.closeBtn.hidden = YES;
  self.moreBtn.hidden = self.moreAction == nil;
  self.backBtn.hidden = self.navigationController.viewControllers.firstObject == self;
  self.view.backgroundColor = [UIColor whiteColor];
  
  if(self.title) self.titleLabel.text = self.title;
  self.navigationItem.titleView = self.titleLabel;
  
  [self layoutProgressView];
  [self layoutRefreshView];
  [self layoutTipsBackgroundWord];
}

- (void)layoutProgressView
{
  self.progressView.translatesAutoresizingMaskIntoConstraints = NO;

  [self.view addSubview:self.progressView];
  self.progressView.backgroundColor = self.trackTintColor;
  
  NSDictionary *viewsDictionary = @{
                                    @"progressView":self.progressView,
                                    };
  
  NSString *vfl = @"V:|-64-[progressView(2.0)]";
  if(self.navigationController.navigationBar.hidden) vfl = @"V:|-0-[progressView(2.0)]";
  
  [self.view addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:vfl
                                           options:0
                                           metrics:nil
                                             views:viewsDictionary]];
  
  NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.progressView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1
                                                                     constant:0];
  [self.view addConstraint:leftConstraint];
  
  NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.progressView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:0];
  [self.view addConstraint:widthConstraint];
  
  self.progressWidthConstraint = widthConstraint;
}

- (void)layoutRefreshView
{
  UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [refreshBtn setImage:[UIImage imageNamed:@"icon_app_refresh"] forState:UIControlStateNormal];
  [refreshBtn addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventTouchUpInside];
  refreshBtn.backgroundColor = [UIColor clearColor];
  
  [self.view addSubview:refreshBtn];
  refreshBtn.translatesAutoresizingMaskIntoConstraints = NO;
  self.refreshBtn = refreshBtn;
  
  UILabel *refreshLabel = [[UILabel alloc]initWithFrame:CGRectZero];
  refreshLabel.textAlignment = NSTextAlignmentCenter;
  refreshLabel.font = [UIFont systemFontOfSize:15.f];
  refreshLabel.text = @"加载出错了哦，点击重试";
  
  [self.view addSubview:refreshLabel];
  refreshLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.refreshLabel = refreshLabel;
  
  [self.view addConstraint:
   [NSLayoutConstraint constraintWithItem:refreshBtn
                                attribute:NSLayoutAttributeCenterX
                                relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                attribute:NSLayoutAttributeCenterX
                               multiplier:1
                                 constant:0]];
  [self.view addConstraint:
   [NSLayoutConstraint constraintWithItem:refreshBtn
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                attribute:NSLayoutAttributeCenterY
                               multiplier:1
                                 constant:0]];
  
  [self.view addConstraint:
   [NSLayoutConstraint constraintWithItem:refreshLabel
                                attribute:NSLayoutAttributeCenterX
                                relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                attribute:NSLayoutAttributeCenterX
                               multiplier:1
                                 constant:0]];
  [self.view addConstraint:
   [NSLayoutConstraint constraintWithItem:refreshLabel
                                attribute:NSLayoutAttributeTop
                                relatedBy:NSLayoutRelationEqual
                                   toItem:refreshBtn
                                attribute:NSLayoutAttributeBottom
                               multiplier:1
                                 constant:8]];
  
  refreshBtn.hidden = YES;
  refreshLabel.hidden = YES;
}

- (void)layoutTipsBackgroundWord
{
  self.wordLabel = [[UILabel alloc]init];
  self.wordLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.wordLabel];
  self.wordLabel.text = @"";
  self.wordLabel.textColor = [UIColor blackColor];
  self.wordLabel.textAlignment = NSTextAlignmentCenter;
  self.wordLabel.font = [UIFont systemFontOfSize:12.f];
  
  NSDictionary *viewsDictionary = @{@"wordLabel":self.wordLabel};
  [self.view addConstraints:
  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[wordLabel]-0-|"
                                               options:0
                                               metrics:nil
                                                 views:viewsDictionary]];
  
  if(self.navigationController.navigationBar && !self.navigationController.navigationBar.hidden)
  {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[wordLabel(50.0)]"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]];
  }
  else
  {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-38-[wordLabel(50.0)]"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]];
  }
}

#pragma mark - getter 

- (UIView *)progressView
{
  if(!_progressView)
  {
    _progressView = [[UIView alloc]initWithFrame:CGRectZero];
  }
  return _progressView;
}

- (UILabel *)titleLabel
{
  if(!_titleLabel)
  {
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:12.f];
    _titleLabel.textColor = self.tintColor;
    _titleLabel.backgroundColor = [UIColor clearColor];
  }
  return _titleLabel;
}

- (UIColor *)tintColor
{
  if(!_tintColor)
  {
    _tintColor = [UIColor blackColor];
  }
  return _tintColor;
}

- (UIColor *)trackTintColor
{
  if(!_trackTintColor)
  {
    _trackTintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0];
  }
  return _trackTintColor;
}

- (void)setMoreAction:(void (^)())moreAction
{
  self.moreBtn.hidden = moreAction == nil;
  _moreAction = moreAction;
}

- (void)setTintColor:(UIColor *)tintColor
{
  self.titleLabel.textColor = tintColor;
  _tintColor = tintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
  self.progressView.backgroundColor = trackTintColor;
  _trackTintColor = trackTintColor;
}

#pragma mark - UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  
  if([self.delegate respondsToSelector:@selector(lctWebView:shouldStartLoadWithRequest:navigationType:)])
  {
    return [self.delegate lctWebView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
  }
  
  if(!webView.request || webView.isLoading || !self.alwaysPushInNewWebController)
  {
    self.progressView.alpha = 1;
    self.progressWidthConstraint.constant = 0;
    [self.progressView setNeedsLayout];
    [self.progressView layoutIfNeeded];
    
    return YES;
  }
  
  LCTWebViewController *controller = [[LCTWebViewController alloc]initWithUrl:request.URL];
  controller.trackTintColor = self.trackTintColor;
  controller.tintColor = self.tintColor;
  controller.delegate = self.delegate;
  controller.alwaysPushInNewWebController = self.alwaysPushInNewWebController;
  [self.navigationController pushViewController:controller animated:YES];
  return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  
  self.url = webView.request.URL;
  
  [UIView animateWithDuration:1.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.progressWidthConstraint.constant = CGRectGetWidth(self.view.frame) * 0.8;
    [self.progressView setNeedsLayout];
    [self.progressView layoutIfNeeded];
  } completion:nil];
  
  self.wordLabel.text = @"";
  [self.view sendSubviewToBack:self.wordLabel];
  
  //make failure view hidden

  self.refreshBtn.hidden = YES;
  self.refreshLabel.hidden = YES;
  
  if([self.delegate respondsToSelector:@selector(lctWebViewDidStartLoad:)])
  {
    [self.delegate lctWebViewDidStartLoad:webView];
  }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  
  //remove privious UIView Animation
  [CATransaction begin];
  [self.progressView.layer removeAllAnimations];
  [CATransaction commit];

  //add animtion for loading finished action
  self.progressWidthConstraint.constant = CGRectGetWidth(self.view.frame);
  [UIView animateWithDuration:0.25 animations:^{
    [self.progressView setNeedsLayout];
    [self.progressView layoutIfNeeded];
  } completion:^(BOOL finished) {
    if(finished)
    {
      delay(0.6, ^{
        self.progressView.alpha = 0;
      });
    }
  }];
  
  self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
  if(self.title) self.titleLabel.text = self.title;
  self.navigationItem.titleView = self.titleLabel;
  
  self.wordLabel.text = [NSString stringWithFormat:@"网页由 %@ 提供",[webView.request.URL host]];
  [self.view sendSubviewToBack:self.wordLabel];
  

  self.closeBtn.hidden = ![webView canGoBack];
  self.backBtn.hidden = !([webView canGoBack] || self.navigationController.viewControllers.firstObject != self);
  
  if([self.delegate respondsToSelector:@selector(lctWebViewDidFinishLoad:)])
  {
    [self.delegate lctWebViewDidFinishLoad:webView];
  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  
  //add animtion for loading finished action
  self.progressWidthConstraint.constant = CGRectGetWidth(self.view.frame);
  [UIView animateWithDuration:0.25 animations:^{
    [self.progressView setNeedsLayout];
    [self.progressView layoutIfNeeded];
  } completion:^(BOOL finished) {
    if(finished)
    {
      delay(0.9, ^{
        self.progressView.alpha = 0;
      });
    }
  }];
  
  self.refreshBtn.hidden = NO;
  self.refreshLabel.hidden = NO;
  
  if([self.delegate respondsToSelector:@selector(lctWebView:didFailLoadWithError:)])
  {
    [self.delegate lctWebView:webView didFailLoadWithError:error];
  }
}

#pragma mark - navigation bar delegate

- (void)handleClose
{
  [self dismissViewControllerAnimated:YES completion:nil];
  
  NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
  NSMutableArray *filteredControllers = [[NSMutableArray alloc]initWithCapacity:viewControllers.count];
  
  //filtered all LCTWebviewcontroller
  for(UIViewController *controlller in viewControllers)
  {
    if([controlller isKindOfClass:[LCTWebViewController class]] && self.navigationController.viewControllers.firstObject != self)
    {
      [viewControllers removeObject:controlller];
      break;
    }
    [filteredControllers addObject:controlller];
  }
  
  [self.navigationController setViewControllers:filteredControllers animated:YES];
}

#pragma mark - action

- (void)handleBack
{
  //web view back action
  if ([self.navigationController.topViewController isKindOfClass:[LCTWebViewController class]]) {
    LCTWebViewController* webVC = (LCTWebViewController*)self.navigationController.topViewController;
    if ([webVC.webView canGoBack]) {
      [webVC.webView goBack];
      return;
    }else{
    [self.navigationController popViewControllerAnimated:YES];
      return;
    }
  }else{
    [self.navigationController popViewControllerAnimated:YES];
    return ;
  }
}

- (void)handleMore
{
  if(self.moreAction) self.moreAction();
}

- (void)handleRefresh
{
  self.refreshLabel.hidden = YES;
  self.refreshBtn.hidden = YES;
  [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

@end
