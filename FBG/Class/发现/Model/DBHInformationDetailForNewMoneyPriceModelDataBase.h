//
//  DBHInformationDetailForNewMoneyPriceModelDataBase.h
//
//  Created by   on 2017/11/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBHInformationDetailForNewMoneyPriceModelData;

@interface DBHInformationDetailForNewMoneyPriceModelDataBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double code;
@property (nonatomic, strong) DBHInformationDetailForNewMoneyPriceModelData *data;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *url;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
