//
//  YYRedPacketSendSecondViewController.h
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "BaseViewController.h"

#define REDPACKET_SEND_SECOND_STORYBOARD_ID @"REDPACKET_SEND_SECOND_ID" 

@interface YYRedPacketSendSecondViewController : BaseViewController

@property (nonatomic, strong) YYRedPacketDetailModel *model;
@property (nonatomic, strong) NSMutableArray *ethWalletsArray;
@property (nonatomic, assign) BOOL isReCreate;

@end
