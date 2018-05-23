//
//  YYRedPacketConfigGasModel.h
//  FBG
//
//  Created by yy on 2018/5/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYRedPacketConfigGasModel : NSObject

@property (nonatomic, assign) NSInteger p_id;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, assign) NSInteger privateValue;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;

@end
