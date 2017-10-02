//
//  RemindModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/9.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"
#import "RemindRelationNotificationModel.h"
#import "RelationCapModel.h"
#import "RelationCapMinModel.h"

@interface RemindModel : BaseModel
/*
 
 "id": 1,
 "name": "OMG",
 "flag": "OMG",
 "token": "OMG",
 "url": "https://OMG",
 "created_at": "2017-08-07 17:17:12",
 "updated_at": "2017-08-14 17:45:57",
 "relation_notification_count": 1,
 "relationCap": [],
 "relationCapMin": [],
 "relation_notification": [
 {
 "id": 2,
 "market_id": 1,
 "user_id": 1,
 "upper_limit": "1",
 "lower_limit": "1",
 "created_at": "2017-08-13 00:48:36",
 "updated_at": "2017-08-13 00:48:36"
 }
 ]
 
 
 id          int             行情分类ID
 name        string          网站名称
 flag        string          行情标记,用于显示以及关联行情实时数据
 token       string          网站token
 url         string          网站url
 created_at  string          创建时间
 relation_notification_count int         用户是否已添加提醒,0表示没有添加
 relation_notification   array       用户提醒信息, relation_notification_count为0是,本字段返回空数组
 relation_cap            array       最新行情信息
 
 relation_notification字段子集说明:
 
 upper_limit     string      上限
 lower_limit     string      下限
 
 relation_cap字段说明:
 
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
 */

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * flag;
@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * created_at;
@property (nonatomic, copy) NSString * source;
@property (nonatomic, assign) int relation_notification_count;
@property (nonatomic, strong) RemindRelationNotificationModel * relation_notification;
@property (nonatomic, strong) RelationCapModel * relationCap;
@property (nonatomic, strong) RelationCapMinModel * relationCapMin;

@property (nonatomic, assign) BOOL isDelate;
@property (nonatomic, assign) BOOL isEdit;

@end
