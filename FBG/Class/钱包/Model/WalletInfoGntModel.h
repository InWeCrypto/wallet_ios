//
//  WalletInfoGntModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/8.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface WalletInfoGntModel : BaseModel
/*
 id              int                 用户代币类型ID
 gnt_category_id     int             代币类型ID
 name            string              代币名称
 
 name        string      代币名称
 icon        string      代币图标路径
 cap         array       钱包类型当前行情
 
 "id": 1,
 "category_id": 1,
 "name": "SNT",
 "created_at": "2017-07-30 23:01:27",
 "updated_at": "2017-08-15 18:55:59",
 "icon": "http://Whale wallet.oss-cn-shenzhen.aliyuncs.com/7071bdd3-1366-3866-932b-6893a2e03a07.png",
 "address": "0xd9d700125b05f26df706f7190fa3be40c29af2fa",
 "gas": "11"
 
 "id": 10,
 "user_id": 1,
 "gnt_category_id": 1,
 "name": "SNT",
 "created_at": "2017-08-16 14:22:58",
 "updated_at": "2017-08-16 14:22:58",
 "wallet_id": 23,
 "balance": "0x0000000000000000000000000000000000000000000000000000000000000000",
 "gnt_category": {
 "id": 1,
 "category_id": 1,
 "name": "SNT",
 "created_at": "2017-07-30 23:01:27",
 "updated_at": "2017-08-15 18:55:59",
 "icon": "http://Whale wallet.oss-cn-shenzhen.aliyuncs.com/7071bdd3-1366-3866-932b-6893a2e03a07.png",
 "address": "0xd9d700125b05f26df706f7190fa3be40c29af2fa",
 "gas": "11",
 "cap": {
 "id": 12831458,
 "asset_id": "omisego",
 "name": "OmiseGo",
 "symbol": "OMG",
 "rank": "14",
 "price_usd": "6.49145",
 "price_btc": "0.00152059",
 "volume_usd_24h": "82698400.0",
 "market_cap_usd": "638187588.0",
 "available_supply": "98312024.0",
 "total_supply": "140245398.0",
 "percent_change_1h": "-0.37",
 "percent_change_24h": "-8.19",
 "percent_change_7d": "116.54",
 "last_updated": "1502738361",
 "price_cny": "43.28888347",
 "volume_cny_24h": "551482550.24",
 "market_cap_cny": "4255817751.0"
 }
 }
 */
@property (nonatomic, assign) int id;
@property (nonatomic, assign) int gnt_category_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * balance;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * price_cny;
@property (nonatomic, copy) NSString * price_usd;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * symbol;
@property (nonatomic, assign) int gas;
@property (nonatomic, assign) int wallet_id;
@property (nonatomic, copy) NSString * flag;

@property (nonatomic, assign) BOOL isAdd;

@end
