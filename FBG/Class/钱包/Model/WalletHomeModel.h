//
//  WalletHomeModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/16.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface WalletHomeModel : BaseModel
/*
 balance     string      钱包余额(16进制)
 category        array
 
 category字段说明:
 
 name        string      钱包类型
 cap         array       钱包类型当前行情
 
 cap字段说明:
 
 price_usd       string      美刀
 price_btc       string      btc
 price_cny       string      人民币
 
 {
 "id": 21,
 "user_id": 1,
 "category_id": 1,
 "name": "观察钱包测试",
 "address": "0x2a6aa2121e8e2158a4087969675099204ec5da98",
 "created_at": "2017-08-15 23:46:41",
 "updated_at": "2017-08-15 23:46:41",
 "deleted_at": null,
 "balance": "0x28456757671e2fe0",
 "category": {
 "id": 1,
 "name": "ETH",
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
 }
 */

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * balance;
@property (nonatomic, copy) NSString * category_name;
@property (nonatomic, copy) NSString * price_cny;
@property (nonatomic, copy) NSString * price_usd;

@end
