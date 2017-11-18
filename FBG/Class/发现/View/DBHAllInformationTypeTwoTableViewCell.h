//
//  DBHAllInformationTypeTwoTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBHAllInformationModelData;
@class DBHInformationDetailForInweModelData;

@interface DBHAllInformationTypeTwoTableViewCell : UITableViewCell

/**
 快讯数据
 */
@property (nonatomic, strong) DBHAllInformationModelData *model;

@property (nonatomic, strong) DBHInformationDetailForInweModelData *inweModel;

@end
