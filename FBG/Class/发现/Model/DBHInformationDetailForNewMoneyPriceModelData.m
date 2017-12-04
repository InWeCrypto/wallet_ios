//
//  DBHInformationDetailForNewMoneyPriceModelData.m
//
//  Created by   on 2017/11/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailForNewMoneyPriceModelData.h"


NSString *const kDBHInformationDetailForNewMoneyPriceModelDataVolume = @"volume";
NSString *const kDBHInformationDetailForNewMoneyPriceModelDataSymbol = @"symbol";
NSString *const kDBHInformationDetailForNewMoneyPriceModelDataMinPrice24h = @"24h_min_price";
NSString *const kDBHInformationDetailForNewMoneyPriceModelDataId = @"id";
NSString *const kDBHInformationDetailForNewMoneyPriceModelDataPrice = @"price";
NSString *const kDBHInformationDetailForNewMoneyPriceModelDataMaxPrice24h = @"24h_max_price";
NSString *const kDBHInformationDetailForNewMoneyPriceModelDataChange24h = @"24h_change";
NSString *const kDBHInformationDetailForNewMoneyPriceModelDataName = @"name";


@interface DBHInformationDetailForNewMoneyPriceModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailForNewMoneyPriceModelData

@synthesize volume = _volume;
@synthesize symbol = _symbol;
@synthesize minPrice24h = _minPrice24h;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize price = _price;
@synthesize maxPrice24h = _maxPrice24h;
@synthesize change24h = _change24h;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.volume = [[self objectOrNilForKey:kDBHInformationDetailForNewMoneyPriceModelDataVolume fromDictionary:dict] doubleValue];
            self.symbol = [self objectOrNilForKey:kDBHInformationDetailForNewMoneyPriceModelDataSymbol fromDictionary:dict];
            self.minPrice24h = [self objectOrNilForKey:kDBHInformationDetailForNewMoneyPriceModelDataMinPrice24h fromDictionary:dict];
            self.dataIdentifier = [self objectOrNilForKey:kDBHInformationDetailForNewMoneyPriceModelDataId fromDictionary:dict];
            self.price = [self objectOrNilForKey:kDBHInformationDetailForNewMoneyPriceModelDataPrice fromDictionary:dict];
            self.maxPrice24h = [self objectOrNilForKey:kDBHInformationDetailForNewMoneyPriceModelDataMaxPrice24h fromDictionary:dict];
            self.change24h = [[self objectOrNilForKey:kDBHInformationDetailForNewMoneyPriceModelDataChange24h fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kDBHInformationDetailForNewMoneyPriceModelDataName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.volume] forKey:kDBHInformationDetailForNewMoneyPriceModelDataVolume];
    [mutableDict setValue:self.symbol forKey:kDBHInformationDetailForNewMoneyPriceModelDataSymbol];
    [mutableDict setValue:self.minPrice24h forKey:kDBHInformationDetailForNewMoneyPriceModelDataMinPrice24h];
    [mutableDict setValue:self.dataIdentifier forKey:kDBHInformationDetailForNewMoneyPriceModelDataId];
    [mutableDict setValue:self.price forKey:kDBHInformationDetailForNewMoneyPriceModelDataPrice];
    [mutableDict setValue:self.maxPrice24h forKey:kDBHInformationDetailForNewMoneyPriceModelDataMaxPrice24h];
    [mutableDict setValue:[NSNumber numberWithDouble:self.change24h] forKey:kDBHInformationDetailForNewMoneyPriceModelDataChange24h];
    [mutableDict setValue:self.name forKey:kDBHInformationDetailForNewMoneyPriceModelDataName];

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

    self.volume = [aDecoder decodeDoubleForKey:kDBHInformationDetailForNewMoneyPriceModelDataVolume];
    self.symbol = [aDecoder decodeObjectForKey:kDBHInformationDetailForNewMoneyPriceModelDataSymbol];
    self.minPrice24h = [aDecoder decodeObjectForKey:kDBHInformationDetailForNewMoneyPriceModelDataMinPrice24h];
    self.dataIdentifier = [aDecoder decodeObjectForKey:kDBHInformationDetailForNewMoneyPriceModelDataId];
    self.price = [aDecoder decodeObjectForKey:kDBHInformationDetailForNewMoneyPriceModelDataPrice];
    self.maxPrice24h = [aDecoder decodeObjectForKey:kDBHInformationDetailForNewMoneyPriceModelDataMaxPrice24h];
    self.change24h = [aDecoder decodeDoubleForKey:kDBHInformationDetailForNewMoneyPriceModelDataChange24h];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationDetailForNewMoneyPriceModelDataName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_volume forKey:kDBHInformationDetailForNewMoneyPriceModelDataVolume];
    [aCoder encodeObject:_symbol forKey:kDBHInformationDetailForNewMoneyPriceModelDataSymbol];
    [aCoder encodeObject:_minPrice24h forKey:kDBHInformationDetailForNewMoneyPriceModelDataMinPrice24h];
    [aCoder encodeObject:_dataIdentifier forKey:kDBHInformationDetailForNewMoneyPriceModelDataId];
    [aCoder encodeObject:_price forKey:kDBHInformationDetailForNewMoneyPriceModelDataPrice];
    [aCoder encodeObject:_maxPrice24h forKey:kDBHInformationDetailForNewMoneyPriceModelDataMaxPrice24h];
    [aCoder encodeDouble:_change24h forKey:kDBHInformationDetailForNewMoneyPriceModelDataChange24h];
    [aCoder encodeObject:_name forKey:kDBHInformationDetailForNewMoneyPriceModelDataName];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailForNewMoneyPriceModelData *copy = [[DBHInformationDetailForNewMoneyPriceModelData alloc] init];
    
    
    
    if (copy) {

        copy.volume = self.volume;
        copy.symbol = [self.symbol copyWithZone:zone];
        copy.minPrice24h = [self.minPrice24h copyWithZone:zone];
        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.price = [self.price copyWithZone:zone];
        copy.maxPrice24h = [self.maxPrice24h copyWithZone:zone];
        copy.change24h = self.change24h;
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
