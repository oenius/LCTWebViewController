//
//  WebViewController.h
//  progress
//
//  Created by mdy1 on 16/4/11.
//  Copyright © 2016年 yixin. All rights reserved.
//

#import "ViewController.h"

///---------------
/// @name LCTWebViewController
///---------------

@protocol LCTWebViewDelegate <NSObject>

@optional
- (BOOL)lctWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)lctWebViewDidStartLoad:(UIWebView *)webView;
- (void)lctWebViewDidFinishLoad:(UIWebView *)webView;
- (void)lctWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end

@interface LCTWebViewController : UIViewController

///---------------
/// @name properties for appearance
///---------------

@property(nonatomic, weak) id<LCTWebViewDelegate> delegate;

/**
 return the url current loading
 */

@property(nonatomic, strong, readonly) NSURL *url;
@property(nonatomic, strong, readonly) UIWebView *webView;

@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property(nonatomic, strong, readonly) UIButton *closeBtn;
@property(nonatomic, strong, readonly) UIButton *moreBtn;

@property(nonatomic, strong, readonly) UIButton *refreshBtn;
@property(nonatomic, strong, readonly) UILabel *refreshLabel;

/**
 tintColor for label title color
 */
@property(nonatomic, strong) UIColor *tintColor;

/**
 trackTintColor for top progress view indicator color
 */
@property(nonatomic, strong) UIColor *trackTintColor;

/**
 if YES request will always push in a new viewController container
 default is NO
 */
@property(nonatomic, assign) BOOL alwaysPushInNewWebController;

/**
 the action should be set if u need the more button action in the right
 */
@property(nonatomic, copy) void(^moreAction)();

/**
init webViewController
 */
- (id)initWithUrl:(NSURL *)url;

- (void)setCMDScheme;

- (void)addCMD:(NSString *)cmd forKey:(NSString *)key action:(BOOL(^)(LCTWebViewController *webViewController,NSString *action, NSDictionary *params))action;
- (void)removeCMDForKey:(NSString *)key;
- (void)removeAllCMDs;

- (void)evaluateScript:(NSString *)script;

@end
