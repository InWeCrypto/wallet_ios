//
//  FindIcoModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/6.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface FindIcoModel : BaseModel
/*
 id          int
 name        string
 img         string          icon图标路径
 */

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * img;

@end
