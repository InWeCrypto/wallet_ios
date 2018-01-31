//
//  DBHProjectOverviewNoTradingForRelevantInformationTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHProjectDetailInformationModelDataBase;

@interface DBHProjectOverviewNoTradingForRelevantInformationTableViewCell : DBHBaseTableViewCell

/**
 相关信息
 */
@property (nonatomic, strong) DBHProjectDetailInformationModelDataBase *projectDetailModel;

@end
