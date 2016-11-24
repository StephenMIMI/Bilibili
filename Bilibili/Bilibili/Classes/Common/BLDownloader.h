//
//  BLDownloader.h
//  Bilibili
//
//  Created by qianfeng on 16/11/23.
//  Copyright © 2016年 zhb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLDownloader : NSObject

+ (void)downloadWithURLString:(NSString *)urlString success:(void(^)(NSData *data))successBlock fail:(void(^)(NSError *error))failBlock;

@end
