//
//  MZWebViewController.m
//  CaiHeAPP
//
//  Created by Mr.Yang on 16/4/20.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "MZWebViewController.h"

@interface MZWebViewController()
    
@end

@implementation MZWebViewController



- (void)setUrl:(NSString *)url{
    if (self.WKView.loading) {
        [self.WKView stopLoading];
    }
    _url = url;
    [self.WKView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (MBProgressHUD *)hud{
    if (!_hud) {
        
        _hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:1];
    }
    return _hud;
}

- (WKWebViewConfiguration *)configuretion{
    if (!_configuretion) {
        _configuretion = [[WKWebViewConfiguration alloc] init];
        _configuretion.preferences = [[WKPreferences alloc] init];
        _configuretion.preferences.minimumFontSize = 15;
        _configuretion.preferences.javaScriptEnabled = true;
        _configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false;
        _configuretion.processPool = [[WKProcessPool alloc] init];
        _configuretion.userContentController = [[WKUserContentController alloc] init];
        [_configuretion.userContentController addScriptMessageHandler:self name:@"你自己的js"];
       
    }
    
    return _configuretion;
}

- (WKWebView *)WKView
{
    if (!_WKView) {
        _WKView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:self.configuretion];
        [self.view addSubview:_WKView];
        
        _WKView.navigationDelegate = self;
        _WKView.UIDelegate = self;
        _WKView.scrollView.delegate = self;
        _WKView.scrollView.bounces = 0;
        _WKView.scrollView.showsVerticalScrollIndicator = 0;
        _WKView.scrollView.showsHorizontalScrollIndicator = 0;
        [self.view addSubview:_WKView];
    }
    return _WKView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark- WKNavigationDelegate

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    self.hud.labelText = @"加载中";
    //获取链接
    NSURL * url = navigationAction.request.URL;
    NSLog(@"url ----- %@", url);
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    self.hud.labelText = @"加载中";
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self hiddenFHL];
    
    if (self.WKView.title != nil && ![self.WKView.title  isEqual: @""] && ![self.WKView.title  isEqual: @"无"]) {
        [self setNavBarTitle:self.WKView.title];
    }
    else
    {
        [self setNavBarTitle:@""];
    }
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"重定向");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self hiddenFHL];

}

#pragma mark-解决iOS8无法显示
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    WKFrameInfo * frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    [self hiddenFHL];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // We must call back js
        completionHandler();
    }]];
    [self presentViewController:alert animated:1 completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    [self hiddenFHL];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnullaction) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnullaction) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"%@", message);
}

#pragma mark-JS回调 -WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"-----name---%@\n---------Message---%@", message.name, message.body);
        [self hiddenFHL];
    
//   你自己的js交互
    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
     [self hiddenFHL];
    return nil;
}


- (void)setNavBarTitle:(NSString *)barTitle{
    if (![barTitle isEqualToString:@""]) {
        self.navigationItem.title = barTitle;
    }
}


- (void)hiddenFHL{
    if (!_hud) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hide:0];
            _hud = nil;
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
