//
//  QNNetworkToolTest.m
//  ZhiMaDi
//
//  Created by haijie on 16/5/23.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

#import "QNNetworkToolTest.h"

@implementation QNNetworkToolTest
+ (void)setFormDataRequest:(NSMutableURLRequest *)request fromData:(NSDictionary *)formdata{
    NSString *boundary = @"12436041281943726692693274280";
    //设置请求体中内容
    NSMutableString *bodyString = [[NSMutableString alloc]init];
    int count = (int)([[formdata allKeys] count]-1);
    for (int i=count; i>=0; i--) {
        
        NSString *key = [formdata allKeys][i];
        NSString *value = [formdata allValues][i];
        if ([key isEqualToString:@"accessToken"]) {
            value = [value substringToIndex:32];
        }
        
        [bodyString appendFormat:@"-----------------------------%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",boundary,key,value];
    }
    
    [bodyString appendFormat:@"-----------------------------%@--\r\n", boundary];
    NSMutableData *bodyData = [[NSMutableData alloc]initWithLength:0];
    NSData *bodyStringData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [bodyData appendData:bodyStringData];
    
    NSString *contentLength = [NSString stringWithFormat:@"%ld",(long)[bodyData length]];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=---------------------------%@", boundary];
    
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:contentLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:bodyData];
    [request setHTTPMethod:@"POST"];
}
@end
