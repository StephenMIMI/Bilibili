//
//  RecommendModel.m
//  Bilibili
//
//  Created by qianfeng on 16/11/23.
//  Copyright © 2016年 zhb. All rights reserved.
//

#import "RecommendModel.h"

@implementation RecommendModel

@end

@implementation RCDataModel

@end

@implementation RCBanner

@end

@implementation RCBannerDetail

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"bannerhash":@"hash", @"bannerId":@"id"}];
}
@end

@implementation RCBodyData

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"datagoto":@"id"}];
}

@end