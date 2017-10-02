//
//  FindArticleModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/6.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface FindArticleModel : BaseModel
/*
 id          int         文章ID
 detail      array       详情
 created_at  string      发表时间
 
 detail字段说明:
 
 title       string
 img         string
 desc        string      简介
 content     string      文章内容
 */

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * created_at;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * img;
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, copy) NSString * content;

@end
