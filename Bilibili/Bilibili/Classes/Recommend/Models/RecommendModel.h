//
//  RecommendModel.h
//  Bilibili
//
//  Created by qianfeng on 16/11/23.
//  Copyright © 2016年 zhb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class RCBanner;
@protocol RCDataModel;
@protocol RCBannerDetail;
@protocol RCBodyData;

@interface RecommendModel : JSONModel

@property (nonatomic, strong)NSNumber<Optional> *code;
@property (nonatomic, strong)NSArray<Optional, RCDataModel> *data;
@property (nonatomic, copy)NSString<Optional> *message;

@end


@interface RCDataModel : JSONModel

@property (nonatomic, strong)RCBanner<Optional> *banner;
@property (nonatomic, strong)NSArray<Optional, RCBodyData> *body;
@property (nonatomic, copy)NSString<Optional> *param;
@property (nonatomic, copy)NSString<Optional> *style;
@property (nonatomic, copy)NSString<Optional> *title;
@property (nonatomic, copy)NSString<Optional> *type;
@property (nonatomic, assign)NSNumber<Optional> *cellHeight;
@end

@interface RCBanner : JSONModel

@property (nonatomic, strong)NSArray<Optional, RCBannerDetail> *top;
@end

@interface RCBannerDetail : JSONModel

@property (nonatomic, copy)NSString<Optional> *bannerhash;//hash
@property (nonatomic, strong)NSNumber<Optional> *bannerId;//id
@property (nonatomic, copy)NSString<Optional> *image;
@property (nonatomic, strong)NSNumber<Optional> *is_ad;
@property (nonatomic, copy)NSString<Optional> *title;
@property (nonatomic, copy)NSString<Optional> *uri;
@end

@interface RCBodyData : JSONModel

@property (nonatomic, copy)NSString<Optional> *cover;
@property (nonatomic, strong)NSNumber<Optional> *danmaku;
@property (nonatomic, copy)NSString<Optional> *datagoto;//goto
@property (nonatomic, copy)NSString<Optional> *param;
@property (nonatomic, strong)NSNumber<Optional> *play;
@property (nonatomic, copy)NSString<Optional> *title;
@property (nonatomic, copy)NSString<Optional> *uri;
@end