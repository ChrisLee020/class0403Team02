//
//  DownLoad.m
//  PianKe
//
//  Created by Chris on 16/7/21.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import "DownLoad.h"

@implementation DownLoad

+ (void)downLoadWithUrl:(NSString *)urls postBody:(NSString *)postBody resultBlock:(Block)resultBlock
{
    if (postBody)
    {
    
        NSURL *url = [NSURL URLWithString:urls];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"POST";
        
        request.HTTPBody = [postBody dataUsingEncoding:NSUTF8StringEncoding];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            
    //        通过block将请求到的数据传到外面
            resultBlock(data);
            
        }];
        
        [task resume];
        
    }
    else
    {
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        [[session dataTaskWithURL:[NSURL URLWithString:urls]completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            resultBlock(data);
            
        }]resume];
    }
}

@end
