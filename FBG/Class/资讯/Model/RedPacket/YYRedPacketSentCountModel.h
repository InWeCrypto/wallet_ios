//
//  YYRedPacketSentCountModel.h
//  FBG
//
//  Created by yy on 2018/4/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYRedPacketSentCountModel : NSObject

@property (nonatomic, assign) NSInteger all; // 全部
@property (nonatomic, assign) NSInteger fail;  // 发送失败
@property (nonatomic, assign) NSInteger success; // 发送成功
@property (nonatomic, assign) NSInteger create; // 创建中
@property (nonatomic, assign) NSInteger send; // 发送中

@end
