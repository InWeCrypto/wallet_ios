//
//  ICOListModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/5.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface ICOOrderListModel : BaseModel
/*
 id              int                 订单ID
 user_id     int                 付款人ID
 wallet_id       int                 钱包ID
 trade_no        string              交易单号
 pay_address     string              付款地址
 receive_address     stirng          收款地址
 fee             string              交易金额
 handle_fee      string              手续费
 hash            strig
 created_at      string          订单创建时间
 ico             array               ico信息
 
 ico字段说明:
 
 title       string          标题
 cny         stirng          币种
 */

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int user_id;
@property (nonatomic, assign) int wallet_id;
@property (nonatomic, copy) NSString * trade_no;
@property (nonatomic, copy) NSString * pay_address;
@property (nonatomic, copy) NSString * receive_address;
@property (nonatomic, copy) NSString * fee;
@property (nonatomic, copy) NSString * handle_fee;
@property (nonatomic, copy) NSString * created_at;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * cny;


@end
