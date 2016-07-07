//
//  MyTool.h
//  xuesheng
//
//  Created by Mr.Yang on 16/6/7.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyTool : NSObject

//判断是否能够打电话
+ (BOOL)canCallPhone;

//普通警告框
+ (void)showWarningInformationTitle:(NSString *)title message:(NSString *)mess intoView:(UIViewController *)viewControll;

//单例，保存config文件
+ (NSDictionary *)shareConfig;

//加载本地URL
+ (NSURLRequest *)loadUrlName:(NSString *)urlName;

//获取沙盒数据
+(NSString *)getDataWithName:(NSString *)name;

//设置沙盒数据







//返回按钮
+ (UIButton *)backButt;
//soap请求
+ (NSMutableURLRequest *)createRequestOFSOAPWith:(NSArray *)array URL:(NSString *)url authenticationName:(NSString *)name;
//根据方法名截取返回的有用信息在转给json解析,最终转换成字典；
+ (NSDictionary *)xmlToJsonWithNsstring:(NSData *)result withMethodName:(NSString *)methodName;
@end
