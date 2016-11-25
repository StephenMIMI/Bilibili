//
//  CommonBannerCell.h
//  Bilibili
//
//  Created by qianfeng on 16/11/25.
//  Copyright © 2016年 zhb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCDataModel;
@interface CommonBannerCell : UITableViewCell

+ (CommonBannerCell *)createBannerViewFor:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath dataModel:(RCDataModel *)dataModel;
@end
