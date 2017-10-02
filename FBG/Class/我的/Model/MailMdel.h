//
//  MailMdel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/4.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface MailMdel : BaseModel
/*
 id          int         联系人记录ID
 category_id     int     对应钱包类型
 name        string          名称
 address     string          钱包地址
 remark      string          备注
 wallet      array       如果该钱包地址未关联到具体的钱包记录,则该值为null
 
 wallet字段说明:
 
 user    array
 
 img         string          联系人头像路径
 */

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int category_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * userImg;
@property (nonatomic, copy) NSString * img;

@end
