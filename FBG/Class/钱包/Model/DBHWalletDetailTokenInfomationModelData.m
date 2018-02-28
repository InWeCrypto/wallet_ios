//
//  DBHWalletDetailTokenInfomationModelData.m
//
//  Created by   on 2018/1/9
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHWalletDetailTokenInfomationModelData.h"


NSString *const kDBHWalletDetailTokenInfomationModelDataPriceCny = @"price_cny";
NSString *const kDBHWalletDetailTokenInfomationModelDataAddress = @"address";
NSString *const kDBHWalletDetailTokenInfomationModelDataPriceUsd = @"price_usd";
NSString *const kDBHWalletDetailTokenInfomationModelDataId = @"id";
NSString *const kDBHWalletDetailTokenInfomationModelDataBalance = @"balance";
NSString *const kDBHWalletDetailTokenInfomationModelDataFlag = @"flag";
NSString *const kDBHWalletDetailTokenInfomationModelDataCanExtractbalance = @"canExtractbalance";
NSString *const kDBHWalletDetailTokenInfomationModelDataIcon = @"icon";
NSString *const kDBHWalletDetailTokenInfomationModelDataName = @"name";


@interface DBHWalletDetailTokenInfomationModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHWalletDetailTokenInfomationModelData

@synthesize priceCny = _priceCny;
@synthesize address = _address;
@synthesize priceUsd = _priceUsd;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize balance = _balance;
@synthesize flag = _flag;
@synthesize canExtractbalance = _canExtractbalance;
@synthesize icon = _icon;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.priceCny = [self objectOrNilForKey:kDBHWalletDetailTokenInfomationModelDataPriceCny fromDictionary:dict];
            self.address = [self objectOrNilForKey:kDBHWalletDetailTokenInfomationModelDataAddress fromDictionary:dict];
            self.priceUsd = [self objectOrNilForKey:kDBHWalletDetailTokenInfomationModelDataPriceUsd fromDictionary:dict];
            self.dataIdentifier = [self objectOrNilForKey:kDBHWalletDetailTokenInfomationModelDataId fromDictionary:dict];
            self.balance = [self objectOrNilForKey:kDBHWalletDetailTokenInfomationModelDataBalance fromDictionary:dict];
            self.flag = [self objectOrNilForKey:kDBHWalletDetailTokenInfomationModelDataFlag fromDictionary:dict];
            self.canExtractbalance = [self objectOrNilForKey:kDBHWalletDetailTokenInfomationModelDataCanExtractbalance fromDictionary:dict];
            self.icon = [self objectOrNilForKey:kDBHWalletDetailTokenInfomationModelDataIcon fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHWalletDetailTokenInfomationModelDataName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.priceCny forKey:kDBHWalletDetailTokenInfomationModelDataPriceCny];
    [mutableDict setValue:self.address forKey:kDBHWalletDetailTokenInfomationModelDataAddress];
    [mutableDict setValue:self.priceUsd forKey:kDBHWalletDetailTokenInfomationModelDataPriceUsd];
    [mutableDict setValue:self.dataIdentifier forKey:kDBHWalletDetailTokenInfomationModelDataId];
    [mutableDict setValue:self.balance forKey:kDBHWalletDetailTokenInfomationModelDataBalance];
    [mutableDict setValue:self.flag forKey:kDBHWalletDetailTokenInfomationModelDataFlag];
    [mutableDict setValue:self.canExtractbalance forKey:kDBHWalletDetailTokenInfomationModelDataCanExtractbalance];
    [mutableDict setValue:self.icon forKey:kDBHWalletDetailTokenInfomationModelDataIcon];
    [mutableDict setValue:self.name forKey:kDBHWalletDetailTokenInfomationModelDataName];

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

    self.priceCny = [aDecoder decodeObjectForKey:kDBHWalletDetailTokenInfomationModelDataPriceCny];
    self.address = [aDecoder decodeObjectForKey:kDBHWalletDetailTokenInfomationModelDataAddress];
    self.priceUsd = [aDecoder decodeObjectForKey:kDBHWalletDetailTokenInfomationModelDataPriceUsd];
    self.dataIdentifier = [aDecoder decodeObjectForKey:kDBHWalletDetailTokenInfomationModelDataId];
    self.balance = [aDecoder decodeObjectForKey:kDBHWalletDetailTokenInfomationModelDataBalance];
    self.flag = [aDecoder decodeObjectForKey:kDBHWalletDetailTokenInfomationModelDataFlag];
    self.canExtractbalance = [aDecoder decodeObjectForKey:kDBHWalletDetailTokenInfomationModelDataCanExtractbalance];
    self.icon = [aDecoder decodeObjectForKey:kDBHWalletDetailTokenInfomationModelDataIcon];
    self.name = [aDecoder decodeObjectForKey:kDBHWalletDetailTokenInfomationModelDataName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_priceCny forKey:kDBHWalletDetailTokenInfomationModelDataPriceCny];
    [aCoder encodeObject:_address forKey:kDBHWalletDetailTokenInfomationModelDataAddress];
    [aCoder encodeObject:_priceUsd forKey:kDBHWalletDetailTokenInfomationModelDataPriceUsd];
    [aCoder encodeObject:_dataIdentifier forKey:kDBHWalletDetailTokenInfomationModelDataId];
    [aCoder encodeObject:_balance forKey:kDBHWalletDetailTokenInfomationModelDataBalance];
    [aCoder encodeObject:_flag forKey:kDBHWalletDetailTokenInfomationModelDataFlag];
    [aCoder encodeObject:_canExtractbalance forKey:kDBHWalletDetailTokenInfomationModelDataCanExtractbalance];
    [aCoder encodeObject:_icon forKey:kDBHWalletDetailTokenInfomationModelDataIcon];
    [aCoder encodeObject:_name forKey:kDBHWalletDetailTokenInfomationModelDataName];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHWalletDetailTokenInfomationModelData *copy = [[DBHWalletDetailTokenInfomationModelData alloc] init];
    
    
    
    if (copy) {

        copy.priceCny = [self.priceCny copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.priceUsd = [self.priceUsd copyWithZone:zone];
        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.balance = [self.balance copyWithZone:zone];
        copy.flag = [self.flag copyWithZone:zone];
        copy.canExtractbalance = [self.canExtractbalance copyWithZone:zone];
        copy.icon = [self.icon copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
