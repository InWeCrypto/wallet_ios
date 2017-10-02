//
//  ICOListModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/6.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface ICOListModel : BaseModel
/*
 id          int             icoID
 title       string          标题
 img         string
 intro       string          简介
 start_at    string          开始时间,用于列表页面tag显示判断
 end_at      string
 cny         stirng          币种
 block_net   string          区块网络
 address     string          合约地址
 url         string          详情url,直接访问url
 */

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * img;
@property (nonatomic, copy) NSString * intro;
@property (nonatomic, copy) NSString * start_at;
@property (nonatomic, copy) NSString * end_at;
@property (nonatomic, copy) NSString * cny;
@property (nonatomic, copy) NSString * block_net;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * url;

@end
