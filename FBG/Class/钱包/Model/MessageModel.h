//
//  MessageModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel
/*
 id          int         消息ID
 title       string
 content     string
 created_at  string
 */

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * created_at;

@end
