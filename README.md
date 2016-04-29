## 预热
> LCTWebViewController 是 [JARVIS](www.jarvis.studio) 小组成员 [李晨涛](https://github.com/lllcccttt) 的项目。而在 Code Review 中， 我除了在代码风格，逻辑 和 实现上修正代码了以外，还加入了一些扩展， 所以就有了现在的 LCTWebViewController。
> 为了防止误判适用场景  ，先抛出来一些资源。
> 1. 如果你需要的in app Safari 组件, 那么在 WWDC 2015 中介绍的 [Introducing Safari View Controller](Introducing Safari View Controller) 会更适合你。
> 2. 如果单单是模仿微信 webView， Github 上的相关实践也是有一些的， 比如 Roxsora 的实现 [RxWebViewController](https://github.com/Roxasora/RxWebViewController)， 已经有了700+的star， 所以现在就打算集成到自己 app 中的同学，可以尝试这个Pod， 因为它已经更稳定。

> LCTWebViewController 在 UI 和功能 上和微信，微博都有极大的类似，但同时也适用于特定的Hybrid交互优化的场景，我会在自己的项目中使用，并维护他，并也会日益完善。

## 基于 LCTWebViewController 实现 Teambition 的端应用

> 通过设置LCTWebViewController 的 alwaysPushInNewWebController 为 YES， 便实现了 Teambition 的端应用。
> 原理，按照 LCTWebViewController 的实现，LCTWebViewController 会针对 NSURLRequest 生成 LCTWebViewController 的对象实例，并在 NavigationController 实例中压栈。
> 这种跳转体验更接近 Native 交互体验。

So we code:

```
self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
NSURL *url = [NSURL URLWithString:@"http://www.teambition.com"];

LCTWebViewController *webViewController = [[LCTWebViewController alloc]initWithUrl:url];
webViewController.trackTintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0];
webViewController.tintColor = [UIColor blackColor];
webViewController.alwaysPushInNewWebController = YES;
webViewController.title = @"Teambition";

[webViewController setMoreAction:^{
  UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:@[@""] applicationActivities:nil];
  [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
}];

UINavigationController *navigatoinController = [[UINavigationController alloc]initWithRootViewController:webViewController];
self.window.rootViewController = navigatoinController;
[self.window makeKeyAndVisible];

```
Run & Preview:

![teambition.gif](http://upload-images.jianshu.io/upload_images/1693266-0ee9cf64206c29d9.gif?imageMogr2/auto-orient/strip)

## 基于 LCTWebViewController 实现类微信，微博 的 in app WebView

Now we change

```
  webViewController.alwaysPushInNewWebController = NO;

```

Run & Preview:
![teambition.gif](http://upload-images.jianshu.io/upload_images/1693266-871aa684aaa307c0.gif?imageMogr2/auto-orient/strip)

## LCTWebViewController 特性 

- [x]  支持iOS7以后的 navigationBar 半透明Blur效果
- [x]  支持顶部 loading 线条加载动画
- [x]  支持加载失败 UI，并点击重新加载
- [x]  支持基于正则表达式的过滤 URL 请求
- [x]  支持 “由*提供” 文案
- [x]  支持对外代理LCTWebViewDelegate
- [x]  & of course CocoaPods supported
- [ ]  如果需要我会实现 swift 版本

## Hybrid混合编程
> 14年加入豆瓣，而实践Hybrid也是在豆瓣的这段时间。豆瓣一刻的文章的图文混排的排版时完全基于 WebView 渲染的 Html 文本。 
> 在交互上和 Native 几乎零差异。 关于 豆瓣 Hybrid 如果想了解更多，可以看这篇文章[豆瓣App混合开发实践](https://mp.weixin.qq.com/s?__biz=MzA3ODg4MDk0Ng==&mid=403327635&idx=1&sn=e95eaa8f25c206385bc6451af92829ef&scene=1&srcid=0429A5QsBR9LnQSZV3RDIK4f&key=b28b03434249256b43b2addb830aede2399572defede72ffdf04a2dfe70c46c06ceb644417dd69621139d0c0b550774e&ascene=0&uin=MTMzODgyNTU%3D&devicetype=iMac+MacBookPro10%2C1+OSX+OSX+10.11+build(15A282b)&version=11000004&pass_ticket=b4Zi7PT2WeFPAirl4bjfYh2PH6mbFE3sSaGoCehULAo%3D)。
> 相信大多数企业级应用，都或多或少的加入了 H5 的 Hybrid混编实践。比如：脉脉（难道不是陌陌）的人脉办事界面，多数是H5体验，并且体验很好。

### LCTWebViewController - Navtive 与 H5 互调
> LCTWebViewController 对 Native 和 H5 的互调做了进一步的封装，使其更佳语义化。

So 现在可以注册一个 Command 给 LCTWebViewController 实例。


```
  [webViewController addCMD:@"alert" forKey:@"kAlert" action:^BOOL(LCTWebViewController *webViewController, NSString *action, NSDictionary *params) {
    if([action isEqualToString:@"alert"] && [[[UIDevice currentDevice] systemVersion]floatValue] >= 8.0)
    {
      NSString *title = [params objectForKey:@"title"];
      NSString *message = [params objectForKey:@"message"];
      
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
      [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    return YES;
  }];
```

H5 通过 CMD 调用 Native 

```
 <a href='cmd://alert?title=LCTWebViewController&message=Hello LCTWebViewController Command'>Hybrid CMD</a>
```

Native 通过执行 js code 调用 H5 

```
  [webViewController evaluateScript:@""];
```

## 什么还在Hybrid？！

>  虽然React Native 还没有到1.0版本，身边的很多朋友在新的项目里已经开始完全基于 React Native 开发应用。React Native 除了性能上比传统的 H5 Hybrid 应用更具有优势以外。

*PS* LCTWebViewController 还不够完善，我想多听听大家的意见，感兴趣的小伙伴，欢迎PR。

*PPS* 谢谢鼓励师的拿铁
