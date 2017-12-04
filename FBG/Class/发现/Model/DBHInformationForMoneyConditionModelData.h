//
//  DBHInformationForMoneyConditionModelData.h
//
//  Created by   on 2017/11/20
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationForMoneyConditionModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *volume;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *change24;
@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *maxPrice24;
@property (nonatomic, strong) NSString *minPrice24;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
