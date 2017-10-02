//
//  WalletTypeModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/9.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface WalletTypeModel : BaseModel
/*
 id              int                 钱包类型ID
 name            string              类型名称
 gas             stirng
 icon            string
 address     string              合约地址
 */
@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * gas;
@property (nonatomic, copy) NSString * icon;

@end
