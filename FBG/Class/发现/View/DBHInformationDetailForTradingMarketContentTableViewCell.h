//
//  DBHInformationDetailForTradingMarketContentTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBHInformationDetailForTradingMarketContentModelData;

@interface DBHInformationDetailForTradingMarketContentTableViewCell : UITableViewCell

/**
 是否为数据
 */
@property (nonatomic, assign) BOOL isData;

/**
 交易情况
 */
@property (nonatomic, strong) DBHInformationDetailForTradingMarketContentModelData *model;

@end
