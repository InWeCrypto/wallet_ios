//
//  YYRedPacketSuccessViewController.h
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

#define REDPACKET_SUCCESS_STORYBOARD_ID @"REDPACKET_SUCCESS"

@interface YYRedPacketSuccessViewController : UITableViewController

@property (nonatomic, strong) YYRedPacketOpenedModel *model;

/**
 返回到第几级
 */
@property (nonatomic, assign) NSInteger backIndex;

@property (nonatomic, assign) BOOL isFromOpen; // 如果从拆红包界面push过来，就应该backindex = 2;

@end
