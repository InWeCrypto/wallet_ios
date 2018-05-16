//
//  YYRedPacketDetailModel.h
//  FBG
//
//  Created by yy on 2018/5/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
// /redbag/send_record/:id

#import <Foundation/Foundation.h>

@interface YYRedPacketDetailModel : NSObject

@property (nonatomic, assign) NSInteger redPacketId;
@property (nonatomic, copy) NSString *auth_tx_id; // 授权tx_id
@property (nonatomic, copy) NSString *redbag_tx_id; // 发送红包tx_id
@property (nonatomic, copy) NSString *fee_tx_id; // 手续费tx_id
@property (nonatomic, assign) NSInteger redbag_id;// 合约红包ID
@property (nonatomic, copy) NSString *redbag; // 红包金额
@property (nonatomic, copy) NSString *redbag_symbol; // 红包代币
@property (nonatomic, copy) NSString *redbag_addr; // 发红包钱包地址
@property (nonatomic, assign) NSInteger redbag_number; // 红包数量
@property (nonatomic, copy) NSString *fee; // 手续费
@property (nonatomic, copy) NSString *fee_addr; // 手续费地址
@property (nonatomic, assign) NSInteger share_type;
@property (nonatomic, copy) NSString *share_attr;
@property (nonatomic, copy) NSString *share_user;
@property (nonatomic, copy) NSString *share_msg;
@property (nonatomic, copy) NSString *created_at; // 红包创建时间
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *share_theme_url;
@property (nonatomic, assign) RedBagLotteryStatus done; // 红包是否完成
@property (nonatomic, assign) RedBagStatus status; // 红包状态,1.完成,2.礼金打包,3.红包创建中,4.领取中,-2.礼金打包失败(授权失败),-3.红包创建失败,-202 礼包授权pending中, -303.红包创建pending中
@property (nonatomic, assign) NSInteger draw_redbag_number; // 红包已领取个数
@property (nonatomic, assign) NSInteger auth_block; // 授权块高
@property (nonatomic, assign) NSInteger redbag_block; // 红包块高
@property (nonatomic, assign) NSInteger fee_block; // 手续费块高
@property (nonatomic, assign) NSInteger redbag_back_block; // 红包退回块高

@property (nonatomic, copy) NSString *redbag_back; // 红包退回金额
@property (nonatomic, copy) NSString *redbag_back_tx_id; // 红包退回tx_id
@property (nonatomic, copy) NSString *auth_at; // 授权时间
@property (nonatomic, copy) NSString *redbag_at; // 创建红包时间
@property (nonatomic, copy) NSString *redbag_back_at; // 红包退回时间
@property (nonatomic, assign) RedBagTXStatus redbag_back_tx_status;// 红包退回状态
@property (nonatomic, strong) YYRedPacketEthTokenModel *gnt_category; // 红包发送情况

@property (nonatomic, assign) NSInteger current_block; // 当前块高

//@property (nonatomic, strong) YYRedPacketRedBagInfoModel *redbag_info;

@property (nonatomic, strong) NSArray *draws;

@end
