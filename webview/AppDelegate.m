//
//  AppDelegate.m
//  progress
//
//  Created by mdy1 on 16/4/8.
//  Copyright © 2016年 yixin. All rights reserved.
//

#import "AppDelegate.h"
#import "LCTWebViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
  
  self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
  NSURL *url = [NSURL URLWithString:@"http://www.teambition.com"];
  
  LCTWebViewController *webViewController = [[LCTWebViewController alloc]initWithUrl:url];
  webViewController.alwaysPushInNewWebController = NO;
  webViewController.title = @"Teambition";
  
  [webViewController setMoreAction:^{
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:@[@""] applicationActivities:nil];
    [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
  }];
  
  UINavigationController *navigatoinController = [[UINavigationController alloc]initWithRootViewController:webViewController];
  self.window.rootViewController = navigatoinController;
  [self.window makeKeyAndVisible];
  
    return YES;
}

@end
