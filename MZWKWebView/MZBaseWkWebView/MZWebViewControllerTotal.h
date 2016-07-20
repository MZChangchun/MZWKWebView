//
//  MZWebViewController.h
//  CaiHeAPP
//
//  Created by Mr.Yang on 16/4/20.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MBProgressHUD.h>
#import <MessageUI/MessageUI.h>//信息电话

@interface MZWebViewController : UIViewController<UIActionSheetDelegate ,NSURLConnectionDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIScrollViewDelegate>

@property (nonatomic, strong)WKWebView * WKView;
@property (nonatomic, strong)WKWebViewConfiguration *configuretion;

@property (nonatomic, copy)NSString * urlName;
@property (nonatomic, copy)NSString * url;

@property (nonatomic, weak)MBProgressHUD *hud;
//其他操作，隐藏风火轮
- (void)hiddenFHL;
@end
