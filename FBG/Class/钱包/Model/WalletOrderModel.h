//
//  WalletOrderModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/10.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface WalletOrderModel : BaseModel
/*
 id              int                 订单ID
 user_id     int                 付款人ID
 wallet_id       int                 钱包ID
 trade_no        string              交易单号
 pay_address     string              付款地址
 receive_address     stirng          收款地址
 remark          string              备注
 fee             string              交易金额
 handle_fee      string              手续费
 hash            strig
 status          int                 0失败,1打包中,2交易成功
 finished_at     string          交易完成时间
 created_at      string          订单创建时间
 */

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int user_id;
@property (nonatomic, assign) int wallet_id;
@property (nonatomic, copy) NSString * trade_no;
@property (nonatomic, copy) NSString * pay_address;
@property (nonatomic, copy) NSString * receive_address;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * fee;
@property (nonatomic, copy) NSString * handle_fee;
@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString * finished_at;
@property (nonatomic, copy) NSString * updated_at;
@property (nonatomic, copy) NSString * created_at;
@property (nonatomic, copy) NSString * block_number;  //当前块高
@property (nonatomic, copy) NSString * maxBlockNumber;  //最大块号 当前
@property (nonatomic, copy) NSString * minBlockNumber;  //最小块号 确认 12
@property (nonatomic, copy) NSString * flag;

@property (nonatomic, assign) BOOL isReceivables; //是否是收款 NO 转账  YES 收款

@end
