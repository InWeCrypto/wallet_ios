//
//  DBHInformationDetailForNewMoneyPriceModelDataBase.m
//
//  Created by   on 2017/11/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailForNewMoneyPriceModelDataBase.h"
#import "DBHInformationDetailForNewMoneyPriceModelData.h"


NSString *const kDBHInformationDetailForNewMoneyPriceModelDataBaseCode = @"code";
NSString *const kDBHInformationDetailForNewMoneyPriceModelDataBaseData = @"data";
NSString *const kDBHInformationDetailForNewMoneyPriceModelDataBaseMsg = @"msg";
NSString *const kDBHInformationDetailForNewMoneyPriceModelDataBaseUrl = @"url";


@interface DBHInformationDetailForNewMoneyPriceModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailForNewMoneyPriceModelDataBase

@synthesize code = _code;
@synthesize data = _data;
@synthesize msg = _msg;
@synthesize url = _url;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.code = [[self objectOrNilForKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseCode fromDictionary:dict] doubleValue];
            self.data = [DBHInformationDetailForNewMoneyPriceModelData modelObjectWithDictionary:[dict objectForKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseData]];
            self.msg = [self objectOrNilForKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseCode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseUrl];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    self.code = [aDecoder decodeDoubleForKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHInformationDetailForNewMoneyPriceModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailForNewMoneyPriceModelDataBase *copy = [[DBHInformationDetailForNewMoneyPriceModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
