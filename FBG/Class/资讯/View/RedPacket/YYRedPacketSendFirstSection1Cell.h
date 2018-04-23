//
//  YYRedPacketSendFirstSection1Cell.h
//  FBG
//
//  Created by yy on 2018/4/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

#define REDPACKET_SEND_SECTION1_CELL_ID @"REDPACKET_SEND_SECTION1_CELL"
#define REDPACKET_SEND_SECTION1_CELL_HEIGHT 60

@interface YYRedPacketSendFirstSection1Cell : DBHBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

- (void)setData:(id)data selectedIdentifier:(NSString *)selectedIdentifier;

@end
