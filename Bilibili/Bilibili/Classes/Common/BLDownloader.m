//
//  BLDownloader.m
//  Bilibili
//
//  Created by qianfeng on 16/11/23.
//  Copyright © 2016年 zhb. All rights reserved.
//

#import "BLDownloader.h"

@implementation BLDownloader

+ (void)downloadWithURLString:(NSString *)urlString success:(void (^)(NSData *))successBlock fail:(void (^)(NSError *))failBlock {

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    //1.创建NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    //2.创建request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //设置返回的数据是原始的二进制数据,默认是JSON
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failBlock(error);
        }else {
            //请求成功
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            if (res.statusCode == 200) {
                successBlock(responseObject);
            }else {
                //请求数据失败
                NSError *err = [NSError errorWithDomain:urlString code:res.statusCode userInfo:@{@"msg":@"下载失败"}];
                failBlock(err);
            }
        }
    }];
    [task resume];
}

@end
