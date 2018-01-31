//
//  DBHMyFavoriteTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHHistoricalInformationModelData;
@class DBHProjectHomeNewsModelData;
@class DBHExchangeNoticeModelData;
@class DBHCandyBowlModelData;

@interface DBHMyFavoriteTableViewCell : DBHBaseTableViewCell

/**
 资讯信息
 */
@property (nonatomic, strong) DBHHistoricalInformationModelData *model;

/**
 项目资讯数据
 */
@property (nonatomic, strong) DBHProjectHomeNewsModelData *infomationModel;

/**
 交易所公告
 */
@property (nonatomic, strong) DBHExchangeNoticeModelData *exchangeNoticeModel;

/**
 CandyBowl
 */
@property (nonatomic, strong) DBHCandyBowlModelData *candyBowlModel;

@end
