//
//  DBHInformationDetailForNewMoneyPriceModelData.h
//
//  Created by   on 2017/11/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationDetailForNewMoneyPriceModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double volume;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *minPrice24h;
@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *maxPrice24h;
@property (nonatomic, assign) double change24h;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
