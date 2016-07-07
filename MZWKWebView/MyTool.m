//
//  MyTool.m
//  xuesheng
//
//  Created by Mr.Yang on 16/6/7.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "MyTool.h"

@implementation MyTool
//判断是否能够打电话
+ (BOOL)canCallPhone{

    NSString * deviceType = [UIDevice currentDevice].model;
    NSLog(@"-------%@", deviceType);
    if ([deviceType isEqualToString:@"iPod touch"] ||[deviceType isEqualToString:@"iPad"] ||[deviceType isEqualToString:@"iPhone Simulator"]) {
        return false;
    }else{
#if TARGET_IPHONE_SIMULATOR//模拟器
       return false;
#elif TARGET_OS_IPHONE//真机
        return true;
#endif
        
    }
}

//普通警告框
+ (void)showWarningInformationTitle:(NSString *)title message:(NSString *)mess intoView:(UIViewController *)viewControll
{
    if (IOS_VERSION >= 8.0) {
        UIAlertController * warning  =[UIAlertController alertControllerWithTitle:title message:mess preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [warning addAction:cancelAction];
        [viewControll presentViewController:warning animated:YES completion:nil];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:mess delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}

//单例，保存config文件
+ (NSDictionary *)shareConfig{
    
    
    static NSDictionary * sharedDic = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
        sharedDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    });
    return sharedDic;
    
}

//加载本地URL
+ (NSURLRequest *)loadUrlName:(NSString *)urlName{
    NSLog(@"----------%@", [MyTool shareConfig][urlName]);
    NSURL * url = [NSURL URLWithString:[MyTool shareConfig][urlName]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    return request;
    
}

//获取沙盒数据
+(NSString *)getDataWithName:(NSString *)name{
    return nil;
}




//返回按钮
+ (UIButton *)backButt{
    UIButton * butt = [UIButton buttonWithType:UIButtonTypeCustom];
    butt.frame = CGRectMake(0, 40.0, 30.0, 30.0);
    [butt setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    return butt;
}
//soap请求
+ (NSMutableURLRequest *)createRequestOFSOAPWith:(NSArray *)array URL:(NSString *)url authenticationName:(NSString *)name{
    
    NSString * json = @"";
    NSString * tempStr = @"";
    NSString * tempStr2 = @"";
    NSString *soapStr = @"";
    if(array.count == 1){
        json = [NSString stringWithFormat:@"<%@>%@</%@>", array[0][@"name"], array[0][@"value"], array[0][@"name"]];
        soapStr =
        [NSString stringWithFormat:
         @ "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
         "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
         "<soap12:Body>"
         "<%@ xmlns=\"http://tempuri.org/\">"
         "%@"
         "</%@>"//方法名
         "</soap12:Body>"
         "</soap12:Envelope>", name, json, name];
        NSLog(@"-------------json%@", soapStr);
    }else if (!array){
        soapStr =
        [NSString stringWithFormat:
         @ "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
         "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
         "<soap12:Body>"
         "<%@ xmlns=\"http://tempuri.org/\">"
         "</%@>"//方法名
         "</soap12:Body>"
         "</soap12:Envelope>", name, name];
    }else{
        for (int i = 0; i < array.count; i ++) {
            
            if (i == 0) {
                
                json = [NSString stringWithFormat:@"[{\"%@\":\"\%@\"",array[i][@"name"], array[i][@"value"]];
                
            }else if (i == array.count - 1){
                
                tempStr = [NSString stringWithFormat:@",\"%@\":\"\%@\"}]",array[i][@"name"], array[i][@"value"]];
                tempStr2 = [json stringByAppendingString:tempStr];
                json = tempStr2;
                
            }else{
                
                tempStr = [NSString stringWithFormat:@",\"%@\":\"\%@\"",array[i][@"name"], array[i][@"value"]];
                tempStr2 = [json stringByAppendingString:tempStr];
                json = tempStr2;
                
            }
        }
        soapStr =
        [NSString stringWithFormat:
         @ "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
         "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
         "<soap12:Body>"
         "<%@ xmlns=\"http://tempuri.org/\">"
         "<json>%@</json>"
         "</%@>"//方法名
         "</soap12:Body>"
         "</soap12:Envelope>", name, json, name];
    }
    NSLog(@"---%@",soapStr);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[MyTool shareConfig][url] ]];
    request.timeoutInterval = 60;
    // 访问方式
    [request setHTTPMethod:@"POST"];
    
    // 设置请求头(请求头也可以不设置，前两个设不设置都一样，应该默认的，但是SOAPAction我怎么都设置不对，不设置也可以，干脆不设置了)
    [request addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%zd", soapStr.length] forHTTPHeaderField:@"Content-Length"];
    NSString * stringhttp = [NSString stringWithFormat:@"http://tempuri.org/%@", name];
    [request addValue:stringhttp forHTTPHeaderField:@"SOAPAction"];
    
    // body内容
    [request setHTTPBody:[soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
//根据方法名截取返回的有用信息在转给json解析,最终转换成字典；
+ (NSDictionary *)xmlToJsonWithNsstring:(NSData *)result withMethodName:(NSString *)methodName{
    
    NSString * dst = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    
    NSLog(@"dst-----%@", dst);
    NSString * methBegin = [NSString stringWithFormat:@"<%@>", methodName];
    NSString * methEnd = [NSString stringWithFormat:@"</%@>", methodName];
    NSArray * dstOneArray = [dst componentsSeparatedByString:methBegin];
    if (dstOneArray.count == 2) {
        NSString *temp = dstOneArray[1];
        NSArray * dstTwoArray = [temp componentsSeparatedByString:methEnd];
        if (dstTwoArray.count == 2) {
            NSString * lastDataStr = dstTwoArray[0];
            NSData * data = [lastDataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            return dic;
        }else{
            return nil;
        }
    }
    else
    {
        return nil;
    }
}
@end
