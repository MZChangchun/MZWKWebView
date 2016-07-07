//
//  MZWebViewController.m
//  CaiHeAPP
//
//  Created by Mr.Yang on 16/4/20.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "MZWebViewController.h"



#import "AppDelegate.h"
#import "LoginViewController.h"

//#import "UIScrollView+UITouch.h"

@interface MZWebViewController()


    
@end

@implementation MZWebViewController

//加载网页
- (void)setUrlName:(NSString *)urlName{
    _urlName = urlName;
    NSURLRequest * request = [MyTool loadUrlName:urlName];
    
    [self.WKView loadRequest:request];
}

- (void)setUrl:(NSString *)url{
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
        [_configuretion.userContentController addScriptMessageHandler:self name:@"setTitle"];
        [_configuretion.userContentController addScriptMessageHandler:self name:@"reLogin"];
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

    NSURL * url = navigationAction.request.URL;
    NSLog(@"url ----- %@", url);
    decisionHandler(WKNavigationActionPolicyAllow);
    
}
//当主框架导航开始
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    self.hud.labelText = @"加载中";
}
//当主框架导航完成
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
//服务重定向时
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"重定向");
}
//加载数据失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self hiddenFHL];
    [MyTool showWarningInformationTitle:@"失败" message:@"链接失败，请检查网络" intoView:self];
}

#pragma mark-WKUIDelegate
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
    //    [self hiddenFHL];
    
    if ([message.name isEqualToString:@"setTitle"]) {
        self.title = message.body;
    }
    else if ([message.name isEqualToString:@"reLogin"]){
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf sessionInvalue];
        });
    } else if ([message.name isEqualToString:@"callPhone"]) {
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf callPhone:message.body];
        });
    }
    
}


//app调用js
- (void)toJavaScript:(WKWebView*)wkView :(NSString *)jsStr{
    [wkView evaluateJavaScript:jsStr completionHandler:nil];
}
//在键盘或者其他控件(下拉框)弹出时禁止webview里面的Content向上移动
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return nil;
}

//设置标题
- (void)setNavBarTitle:(NSString *)barTitle{
    if (![barTitle isEqualToString:@""]) {
        self.navigationItem.title = barTitle;
    }
}


//其他操作，隐藏风火轮
- (void)hiddenFHL{
    if (!_hud) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.hud hide:0];
            weakSelf.hud = nil;
    });
}


//session失效，退出到登录界面
- (void)sessionInvalue
{
    __weak typeof(self) weakSelf = self;
    UIAlertController * warning  =[UIAlertController alertControllerWithTitle:@"提示" message:@"身份信息失效，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf toLoginWithSessionInval];
    }];
    [warning addAction:cancelAction];
    [self presentViewController:warning animated:YES completion:nil];
    
}- (void)toLoginWithSessionInval{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:token];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = [[LoginViewController alloc] init];
}

#pragma mark-拨打电话
- (void)callPhone:(NSString *)number{
    [self hiddenFHL];
    NSLog(@"打电话：%@", number);
    if (![MyTool canCallPhone]) {
        [MyTool showWarningInformationTitle:@"提示" message:@"您的设备不支持电话功能" intoView:self];
        return;
    }
    
    [self.WKView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", number]]]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
