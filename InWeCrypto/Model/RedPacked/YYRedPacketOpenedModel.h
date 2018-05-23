//
//  YYRedPacketOpenedModel.h
//  FBG
//
//  Created by yy on 2018/5/1.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYRedPacketDetailModel;

@interface YYRedPacketOpenedModel : NSObject

@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, assign) NSInteger redbag_id;
@property (nonatomic, copy) NSString *redbag_addr;
@property (nonatomic, copy) NSString *draw_addr;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *tx_id;
@property (nonatomic, copy) NSString *value;

@property (nonatomic, assign) RedBagTXStatus tx_status; // 红包打开状态, 1.打开成功,-1打开失败
@property (nonatomic, assign) NSInteger tx_block; // 订单快高
@property (nonatomic, strong) YYRedPacketDetailModel *redbag;

@end
