//
//  DBHInformationForMoneyConditionModelDataBase.m
//
//  Created by   on 2017/11/20
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForMoneyConditionModelDataBase.h"
#import "DBHInformationForMoneyConditionModelData.h"


NSString *const kDBHInformationForMoneyConditionModelDataBaseCode = @"code";
NSString *const kDBHInformationForMoneyConditionModelDataBaseData = @"data";
NSString *const kDBHInformationForMoneyConditionModelDataBaseMsg = @"msg";
NSString *const kDBHInformationForMoneyConditionModelDataBaseUrl = @"url";


@interface DBHInformationForMoneyConditionModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForMoneyConditionModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHInformationForMoneyConditionModelDataBaseCode fromDictionary:dict] doubleValue];
            self.data = [DBHInformationForMoneyConditionModelData modelObjectWithDictionary:[dict objectForKey:kDBHInformationForMoneyConditionModelDataBaseData]];
            self.msg = [self objectOrNilForKey:kDBHInformationForMoneyConditionModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationForMoneyConditionModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHInformationForMoneyConditionModelDataBaseCode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kDBHInformationForMoneyConditionModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHInformationForMoneyConditionModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHInformationForMoneyConditionModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHInformationForMoneyConditionModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHInformationForMoneyConditionModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHInformationForMoneyConditionModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationForMoneyConditionModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHInformationForMoneyConditionModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHInformationForMoneyConditionModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHInformationForMoneyConditionModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHInformationForMoneyConditionModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForMoneyConditionModelDataBase *copy = [[DBHInformationForMoneyConditionModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
