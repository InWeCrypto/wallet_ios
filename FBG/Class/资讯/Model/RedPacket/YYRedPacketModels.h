//
//  YYRedPacketModels.h
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

typedef enum _redbag_status {
    RedBagStatusDone = 1,
    RedBagStatusCashPackaging = 2,
    RedBagStatusCreating = 3,
    RedBagStatusOpening = 4,
    RedBagStatusCashPackageFailed = -2,
    RedBagStatusCreateFailed = -3,
    RedBagStatusCashAuthPending = -202, //礼包授权pending中
    RedBagStatusCreatePending = -303 //红包创建pending中
}RedBagStatus;

// 0:新建的未打开  1:在打开中  2:已结束
typedef enum _redbag_info_status {
    RedBagInfoStatusNewUnOpen,
    RedBagInfoStatusOpenning,
    RedBagInfoStatusEnd
}RedBagInfoStatus;

// 开奖状态 // 红包是否开奖,1.已开奖,0.待开奖,2.开奖结束
typedef enum _redbag_done_status {
    RedBagLotteryStatusWait,
    RedBagLotteryStatusHad,
    RedBagLotteryStatusEnd
}RedBagLotteryStatus;

// // 红包退回状态 红包领取状态  红包打开状态 , 1.打开成功,-1打开失败 0 未处理
typedef enum _redbag_back_tx_status {
    RedBagTXStatusPending = 0,
    RedBagTXStatusOpenSuccess = 1,
    RedBagTXStatusOpenFailed = -1
}RedBagTXStatus;

typedef enum _redbag_cell_type {
    RedBagCellTypeCashPackage = 0, // 礼金打包详情
    RedBagCellTypeHanldeFee,    // 手续费
    RedBagCellTypeDrawNum, // 领取数量
    RedBagCellTypeBackNum // 撤回数量
}RedBagCellType;

typedef void(^CompletionBlock) (void);

#import "PPNetworkCache.h"
#import "YYRedPacketSentCountModel.h"
#import "YYRedPacketEthTokenModel.h"
#import "YYRedPacketMySentModel.h"
#import "YYRedPacketOpenedListModel.h"
#import "YYRedPacketOpenedModel.h"
#import "YYRedPacketDrawModel.h"
#import "YYRedPacketRedBagInfoModel.h"
#import "YYRedPacketDetailModel.h"
#import "YYRedPacketConfigGasModel.h"

#define HAS_EMPTY(str) [NSString stringWithFormat:@"  %@  ", str]
