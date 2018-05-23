//
//  YYRedPacketPackagingViewController.h
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "BaseViewController.h"

#define REDPACKET_PACKAGING_STORYBOARD_ID @"REDPACKET_PACKAGING"

typedef enum _package_type {
    PackageTypeCash = 0,
    PackageTypeRedPacket
}PackageType;

@interface YYRedPacketPackagingViewController : BaseViewController

@property (nonatomic, assign) PackageType packageType; // 礼金打包还是红包创建
@property (nonatomic, strong) YYRedPacketDetailModel *model;
@property (nonatomic, strong) NSMutableArray *ethWalletsArray;
@property (nonatomic, assign) NSInteger from; // from == 2 detail进来的
/**
 红包授权
 */

@end
