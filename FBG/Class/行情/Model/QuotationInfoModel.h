//
//  QuotationInfoModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/8.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"
/*
 price_usd_first     string      0点开盘美刀成交价格
 price_usd_last      string      当前美刀成交价格
 price_usd_low       string          当天美刀成交最低价
 price_usd_high      string      当天美刀成交最高价
 */
@interface QuotationInfoModel : BaseModel

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
