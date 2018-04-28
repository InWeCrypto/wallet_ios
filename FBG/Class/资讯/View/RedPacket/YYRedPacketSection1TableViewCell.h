//
//  YYRedPacketSection1TableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
@class YYRedPacketMySentListModel;

#define REDPACKET_SECTION1_CELL_HEIGHT 80
#define REDPACKET_SECTION1_CELL_ID @"REDPACKET_SECTION1_CELL"

@interface YYRedPacketSection1TableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) YYRedPacketMySentListModel *model;

@end
