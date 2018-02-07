//
//  DBHProjectOverviewViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@class DBHProjectDetailInformationModelDataBase;

@interface DBHProjectOverviewViewController : DBHBaseViewController

/**
 项目详细信息
 */
@property (nonatomic, strong) DBHProjectDetailInformationModelDataBase *projectDetailModel;

@end
