//
//  YYRedPacketOpenViewController.h
//  FBG
//
//  Created by yy on 2018/5/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "BaseViewController.h"

#define REDPACKET_OPEN_STORYBOARD_ID @"REDPACKET_OPEN"

@interface YYRedPacketOpenViewController : BaseViewController

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) YYRedPacketDetailModel *model;

@end
