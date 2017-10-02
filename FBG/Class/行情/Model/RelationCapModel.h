//
//  RelationCurrent.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface RelationCapModel : BaseModel
/*
 {
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
 
 price_usd           string          当前兑换美元价格
 price_btc           string          当前兑换btc价格
 volume_usd_24h  string          24小时内美元交易总量
 market_cap_usd  string
 available_supply    string
 total_supply        string
 percent_change_1h   string
 percent_change_24h  string
 percent_change_7d   strng
 last_updated        string          更新时间,时间戳
 price_cny           string          当前兑换人民币价格
 volume_cny_24h      string
 market_cap_cny      string
 }
 */

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * price_usd;
@property (nonatomic, copy) NSString * price_btc;
@property (nonatomic, copy) NSString * price_cny;
@property (nonatomic, copy) NSString * volume_cny_24h;
@property (nonatomic, copy) NSString * volume_usd_24h;
@property (nonatomic, copy) NSString * last_updated;
@property (nonatomic, copy) NSString * percent_change_24h;

@end
