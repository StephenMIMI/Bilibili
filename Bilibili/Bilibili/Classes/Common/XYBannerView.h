//
//  XYBannerView.h
//  Bilibili
//
//  Created by qianfeng on 16/11/24.
//  Copyright © 2016年 zhb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCBanner;

@interface XYBannerView : UITableViewCell

+ (XYBannerView *)createBannerViewFor:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath bannerArray:(RCBanner *)bannerArray;
@end
