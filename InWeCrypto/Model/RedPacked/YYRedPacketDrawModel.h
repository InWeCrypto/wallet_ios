//
//  YYRedPacketDrawModel.h
//  FBG
//
//  Created by yy on 2018/5/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYRedPacketDrawModel : NSObject

@property (nonatomic, assign) NSInteger drawId;
@property (nonatomic, copy) NSString *redbag_id; // 红包ID
@property (nonatomic, copy) NSString *redbag_addr; // 领取红包地址
@property (nonatomic, copy) NSString *draw_addr; // 领取钱包地址
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *tx_id;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) RedBagTXStatus tx_status; // 领取状态,-1.领取失败,1.领取成功
@property (nonatomic, assign) NSInteger tx_block; // 领取块高

@end
