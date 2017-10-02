//
//  MonetaryUnitModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/5.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface MonetaryUnitModel : BaseModel
/*
 id              int                 货币单位ID
 name            string              货币单位名称
 user_unit_count int                 0表示用户未选择,1表示用户已选择
 created_at      string              创建时间
 */

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) int user_unit_count;
@property (nonatomic, copy) NSString * created_at;

@end
