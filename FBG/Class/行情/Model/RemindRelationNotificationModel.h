//
//  RemindRelationNotificationModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/9.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface RemindRelationNotificationModel : BaseModel

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * upper_limit;
@property (nonatomic, copy) NSString * lower_limit;

@end
