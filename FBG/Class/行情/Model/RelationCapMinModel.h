//
//  RelationCapMin.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface RelationCapMinModel : BaseModel
/*
 {
 "id": 383120,
 "asset_id": "omisego",
 "name": "OmiseGo",
 "symbol": "OMG",
 "rank": "14",
 "price_usd_first": "6.491450",
 "price_usd_last": "6.491450",
 "price_usd_low": "6.491450",
 "price_usd_high": "6.491450",
 "price_btc_first": "0.001521",
 "price_btc_last": "0.001521",
 "price_btc_low": "0.001521",
 "price_btc_high": "0.001521",
 "price_cny_first": "43.288883",
 "price_cny_last": "43.288883",
 "price_cny_low": "43.288883",
 "price_cny_high": "43.288883",
 "last_updated": "1502738361",
 "timestamp": 1502738516,
 "_group": "pricecoinmarketcap"
 }
 
 price_usd_first     string      0点开盘美刀成交价格
 price_usd_last      string      当前美刀成交价格
 price_usd_low       string          当天美刀成交最低价
 price_usd_high      string      当天美刀成交最高价
 timestamp               string      时间戳,更新时间
 */

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * price_usd_first;
@property (nonatomic, copy) NSString * price_usd_last;
@property (nonatomic, copy) NSString * price_usd_low;
@property (nonatomic, copy) NSString * price_usd_high;

@property (nonatomic, copy) NSString * price_cny_first;
@property (nonatomic, copy) NSString * price_cny_last;
@property (nonatomic, copy) NSString * price_cny_low;
@property (nonatomic, copy) NSString * price_cny_high;

@property (nonatomic, copy) NSString * timestamp;

@end
