//
//  QuotationModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/7.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"
#import "RelationCapModel.h"
#import "RelationCapMinModel.h"

/*
 {
 "id": 1,
 "name": "OMG",
 "flag": "OMG",
 "token": "OMG",
 "url": "https://OMG",
 "created_at": "2017-08-07 17:17:12",
 "updated_at": "2017-08-14 17:45:57",
 "relationCapMin": {},
 "relationCap": {}
 
 id          int             行情分类ID
 name        string          网站名称
 flag        string          行情标记,用于显示以及关联行情实时数据
 token       string          网站token
 url         string          网站url
 created_at  string          创建时间
 relation_user_count int     0表示没选择,1表示已选择   isll 才会出现
 }
 */

@interface QuotationModel : BaseModel

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * flag;
@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * created_at;
@property (nonatomic, copy) NSString * updated_at;
@property (nonatomic, copy) NSString * source;
@property (nonatomic, assign) int relation_user_count;
@property (nonatomic, strong) RelationCapModel * relationCap;
@property (nonatomic, strong) RelationCapMinModel * relationCapMin;

@end
