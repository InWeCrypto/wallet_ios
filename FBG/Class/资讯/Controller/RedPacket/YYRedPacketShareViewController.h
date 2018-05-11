//
//  YYRedPacketShareViewController.h
//  FBG
//
//  Created by yy on 2018/4/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

#define REDPACKET_SHARE_STORYBOARD_ID @"REDPACKET_SHARE"

@interface YYRedPacketShareViewController : DBHBaseViewController

@property (nonatomic, strong) YYRedPacketDetailModel *model;
@property (nonatomic, assign) NSInteger index; // 0 朋友圈   1 微信  2 qq 5 截图

@end
