//
//  DBHInformationForMoneyConditionModelDataBase.h
//
//  Created by   on 2017/11/20
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBHInformationForMoneyConditionModelData;

@interface DBHInformationForMoneyConditionModelDataBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double code;
@property (nonatomic, strong) DBHInformationForMoneyConditionModelData *data;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *url;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
