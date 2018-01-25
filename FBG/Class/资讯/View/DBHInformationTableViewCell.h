//
//  DBHInformationTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHInformationModelData;

@interface DBHInformationTableViewCell : DBHBaseTableViewCell

/**
 项目信息
 */
@property (nonatomic, strong) DBHInformationModelData *model;

/**
 功能组件标题
 */
@property (nonatomic, copy) NSString *functionalUnitTitle;

@end
