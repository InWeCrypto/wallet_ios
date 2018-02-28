//
//  DBHWalletManagerForNeoModelList.h
//
//  Created by   on 2018/1/9
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBHWalletManagerForNeoModelCategory;

@interface DBHWalletManagerForNeoModelList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) DBHWalletManagerForNeoModelCategory *category;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) double listIdentifier;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) id deletedAt;
@property (nonatomic, assign) id addressHash160;
@property (nonatomic, assign) double categoryId;
@property (nonatomic, assign) double userId;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSMutableDictionary *tokenStatistics; // 代币统计
@property (nonatomic, strong) NSString *balance; // 数量
@property (nonatomic, assign) BOOL isLookWallet; // 是否观察钱包
@property (nonatomic, assign) BOOL isBackUpMnemonnic; // 是否备份助记词

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
