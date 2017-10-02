//
//  FindBannerModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/6.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface FindBannerModel : BaseModel
/*
 id          int         对应文章ID
 detail      array       详情
 
 detail字段说明:
 
 title       string
 img         string
 desc        string      简介
 */
@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * img;
@property (nonatomic, copy) NSString * desc;

@end
