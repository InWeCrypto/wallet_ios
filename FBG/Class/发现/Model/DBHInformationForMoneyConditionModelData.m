//
//  DBHInformationForMoneyConditionModelData.m
//
//  Created by   on 2017/11/20
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForMoneyConditionModelData.h"


NSString *const kDBHInformationForMoneyConditionModelDataVolume = @"volume";
NSString *const kDBHInformationForMoneyConditionModelDataSymbol = @"symbol";
NSString *const kDBHInformationForMoneyConditionModelDataChange24 = @"24h_change";
NSString *const kDBHInformationForMoneyConditionModelDataId = @"id";
NSString *const kDBHInformationForMoneyConditionModelDataPrice = @"price";
NSString *const kDBHInformationForMoneyConditionModelDataMaxPrice24 = @"24h_max_price";
NSString *const kDBHInformationForMoneyConditionModelDataMinPrice24 = @"24h_min_price";
NSString *const kDBHInformationForMoneyConditionModelDataName = @"name";


@interface DBHInformationForMoneyConditionModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForMoneyConditionModelData

@synthesize volume = _volume;
@synthesize symbol = _symbol;
@synthesize change24 = _change24;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize price = _price;
@synthesize maxPrice24 = _maxPrice24;
@synthesize minPrice24 = _minPrice24;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.volume = [self objectOrNilForKey:kDBHInformationForMoneyConditionModelDataVolume fromDictionary:dict];
            self.symbol = [self objectOrNilForKey:kDBHInformationForMoneyConditionModelDataSymbol fromDictionary:dict];
            self.change24 = [self objectOrNilForKey:kDBHInformationForMoneyConditionModelDataChange24 fromDictionary:dict];
            self.dataIdentifier = [self objectOrNilForKey:kDBHInformationForMoneyConditionModelDataId fromDictionary:dict];
            self.price = [self objectOrNilForKey:kDBHInformationForMoneyConditionModelDataPrice fromDictionary:dict];
            self.maxPrice24 = [self objectOrNilForKey:kDBHInformationForMoneyConditionModelDataMaxPrice24 fromDictionary:dict];
            self.minPrice24 = [self objectOrNilForKey:kDBHInformationForMoneyConditionModelDataMinPrice24 fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationForMoneyConditionModelDataName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.volume forKey:kDBHInformationForMoneyConditionModelDataVolume];
    [mutableDict setValue:self.symbol forKey:kDBHInformationForMoneyConditionModelDataSymbol];
    [mutableDict setValue:self.change24 forKey:kDBHInformationForMoneyConditionModelDataChange24];
    [mutableDict setValue:self.dataIdentifier forKey:kDBHInformationForMoneyConditionModelDataId];
    [mutableDict setValue:self.price forKey:kDBHInformationForMoneyConditionModelDataPrice];
    [mutableDict setValue:self.maxPrice24 forKey:kDBHInformationForMoneyConditionModelDataMaxPrice24];
    [mutableDict setValue:self.minPrice24 forKey:kDBHInformationForMoneyConditionModelDataMinPrice24];
    [mutableDict setValue:self.name forKey:kDBHInformationForMoneyConditionModelDataName];

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

    self.volume = [aDecoder decodeObjectForKey:kDBHInformationForMoneyConditionModelDataVolume];
    self.symbol = [aDecoder decodeObjectForKey:kDBHInformationForMoneyConditionModelDataSymbol];
    self.change24 = [aDecoder decodeObjectForKey:kDBHInformationForMoneyConditionModelDataChange24];
    self.dataIdentifier = [aDecoder decodeObjectForKey:kDBHInformationForMoneyConditionModelDataId];
    self.price = [aDecoder decodeObjectForKey:kDBHInformationForMoneyConditionModelDataPrice];
    self.maxPrice24 = [aDecoder decodeObjectForKey:kDBHInformationForMoneyConditionModelDataMaxPrice24];
    self.minPrice24 = [aDecoder decodeObjectForKey:kDBHInformationForMoneyConditionModelDataMinPrice24];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationForMoneyConditionModelDataName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_volume forKey:kDBHInformationForMoneyConditionModelDataVolume];
    [aCoder encodeObject:_symbol forKey:kDBHInformationForMoneyConditionModelDataSymbol];
    [aCoder encodeObject:_change24 forKey:kDBHInformationForMoneyConditionModelDataChange24];
    [aCoder encodeObject:_dataIdentifier forKey:kDBHInformationForMoneyConditionModelDataId];
    [aCoder encodeObject:_price forKey:kDBHInformationForMoneyConditionModelDataPrice];
    [aCoder encodeObject:_maxPrice24 forKey:kDBHInformationForMoneyConditionModelDataMaxPrice24];
    [aCoder encodeObject:_minPrice24 forKey:kDBHInformationForMoneyConditionModelDataMinPrice24];
    [aCoder encodeObject:_name forKey:kDBHInformationForMoneyConditionModelDataName];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForMoneyConditionModelData *copy = [[DBHInformationForMoneyConditionModelData alloc] init];
    
    
    
    if (copy) {

        copy.volume = [self.volume copyWithZone:zone];
        copy.symbol = [self.symbol copyWithZone:zone];
        copy.change24 = [self.change24 copyWithZone:zone];
        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.price = [self.price copyWithZone:zone];
        copy.maxPrice24 = [self.maxPrice24 copyWithZone:zone];
        copy.minPrice24 = [self.minPrice24 copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
