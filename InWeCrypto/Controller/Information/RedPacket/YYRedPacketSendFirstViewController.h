//
//  YYRedPacketSendFirstViewController.h
//  FBG
//
//  Created by yy on 2018/4/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "BaseViewController.h"

#define REDPACKET_SEND_FIRST_STORYBOARD_ID @"REDPACKET_SEND_FIRST_ID"

@interface YYRedPacketSendFirstViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *ethWalletsArr;
@property (nonatomic, strong) YYRedPacketDetailModel *model;

@end
