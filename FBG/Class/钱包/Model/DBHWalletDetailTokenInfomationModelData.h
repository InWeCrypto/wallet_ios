//
//  DBHWalletDetailTokenInfomationModelData.h
//
//  Created by   on 2018/1/9
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHWalletDetailTokenInfomationModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *priceCny;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *priceUsd;
@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *canExtractbalance;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, copy) NSString *gas;
@property (nonatomic, copy) NSString *decimals; // 小数位数
@property (nonatomic, copy) NSString *noExtractbalance; // 不可提取

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
