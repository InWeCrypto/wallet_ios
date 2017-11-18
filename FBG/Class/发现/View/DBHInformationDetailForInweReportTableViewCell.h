//
//  DBHInformationDetailForInweReportTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectInweTypeBlock)(NSInteger inweType);

@interface DBHInformationDetailForInweReportTableViewCell : UITableViewCell

/**
 0:视频 1:图文
 */
@property (nonatomic, assign) NSInteger inweReportType;

/**
 数据
 */
@property (nonatomic, copy) NSArray *dataSource;

/**
 选择INWE类型回调
 */
- (void)selectInweTypeBlock:(SelectInweTypeBlock)selectInweTypeBlock;

@end
