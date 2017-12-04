//
//  DBHQuotationVCModelTimeData.m
//
//  Created by   on 2017/12/2
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHQuotationVCModelTimeData.h"


NSString *const kDBHQuotationVCModelTimeDataPriceCny = @"price_cny";
NSString *const kDBHQuotationVCModelTimeDataVolumeCny24h = @"volume_cny_24h";
NSString *const kDBHQuotationVCModelTimeDataPriceUsd = @"price_usd";
NSString *const kDBHQuotationVCModelTimeDataMinPriceCny24h = @"min_price_cny_24h";
NSString *const kDBHQuotationVCModelTimeDataVolumeUsd24h = @"volume_usd_24h";
NSString *const kDBHQuotationVCModelTimeDataMinPriceUsd24h = @"min_price_usd_24h";
NSString *const kDBHQuotationVCModelTimeDataChange24h = @"change_24h";
NSString *const kDBHQuotationVCModelTimeDataMaxPriceUsd24h = @"max_price_usd_24h";
NSString *const kDBHQuotationVCModelTimeDataMaxPriceCny24h = @"max_price_cny_24h";


@interface DBHQuotationVCModelTimeData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHQuotationVCModelTimeData

@synthesize priceCny = _priceCny;
@synthesize volumeCny24h = _volumeCny24h;
@synthesize priceUsd = _priceUsd;
@synthesize minPriceCny24h = _minPriceCny24h;
@synthesize volumeUsd24h = _volumeUsd24h;
@synthesize minPriceUsd24h = _minPriceUsd24h;
@synthesize change24h = _change24h;
@synthesize maxPriceUsd24h = _maxPriceUsd24h;
@synthesize maxPriceCny24h = _maxPriceCny24h;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.priceCny = [self objectOrNilForKey:kDBHQuotationVCModelTimeDataPriceCny fromDictionary:dict];
            self.volumeCny24h = [self objectOrNilForKey:kDBHQuotationVCModelTimeDataVolumeCny24h fromDictionary:dict];
            self.priceUsd = [self objectOrNilForKey:kDBHQuotationVCModelTimeDataPriceUsd fromDictionary:dict];
            self.minPriceCny24h = [self objectOrNilForKey:kDBHQuotationVCModelTimeDataMinPriceCny24h fromDictionary:dict];
            self.volumeUsd24h = [self objectOrNilForKey:kDBHQuotationVCModelTimeDataVolumeUsd24h fromDictionary:dict];
            self.minPriceUsd24h = [self objectOrNilForKey:kDBHQuotationVCModelTimeDataMinPriceUsd24h fromDictionary:dict];
            self.change24h = [self objectOrNilForKey:kDBHQuotationVCModelTimeDataChange24h fromDictionary:dict];
            self.maxPriceUsd24h = [self objectOrNilForKey:kDBHQuotationVCModelTimeDataMaxPriceUsd24h fromDictionary:dict];
            self.maxPriceCny24h = [self objectOrNilForKey:kDBHQuotationVCModelTimeDataMaxPriceCny24h fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.priceCny forKey:kDBHQuotationVCModelTimeDataPriceCny];
    [mutableDict setValue:self.volumeCny24h forKey:kDBHQuotationVCModelTimeDataVolumeCny24h];
    [mutableDict setValue:self.priceUsd forKey:kDBHQuotationVCModelTimeDataPriceUsd];
    [mutableDict setValue:self.minPriceCny24h forKey:kDBHQuotationVCModelTimeDataMinPriceCny24h];
    [mutableDict setValue:self.volumeUsd24h forKey:kDBHQuotationVCModelTimeDataVolumeUsd24h];
    [mutableDict setValue:self.minPriceUsd24h forKey:kDBHQuotationVCModelTimeDataMinPriceUsd24h];
    [mutableDict setValue:self.change24h forKey:kDBHQuotationVCModelTimeDataChange24h];
    [mutableDict setValue:self.maxPriceUsd24h forKey:kDBHQuotationVCModelTimeDataMaxPriceUsd24h];
    [mutableDict setValue:self.maxPriceCny24h forKey:kDBHQuotationVCModelTimeDataMaxPriceCny24h];

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

    self.priceCny = [aDecoder decodeObjectForKey:kDBHQuotationVCModelTimeDataPriceCny];
    self.volumeCny24h = [aDecoder decodeObjectForKey:kDBHQuotationVCModelTimeDataVolumeCny24h];
    self.priceUsd = [aDecoder decodeObjectForKey:kDBHQuotationVCModelTimeDataPriceUsd];
    self.minPriceCny24h = [aDecoder decodeObjectForKey:kDBHQuotationVCModelTimeDataMinPriceCny24h];
    self.volumeUsd24h = [aDecoder decodeObjectForKey:kDBHQuotationVCModelTimeDataVolumeUsd24h];
    self.minPriceUsd24h = [aDecoder decodeObjectForKey:kDBHQuotationVCModelTimeDataMinPriceUsd24h];
    self.change24h = [aDecoder decodeObjectForKey:kDBHQuotationVCModelTimeDataChange24h];
    self.maxPriceUsd24h = [aDecoder decodeObjectForKey:kDBHQuotationVCModelTimeDataMaxPriceUsd24h];
    self.maxPriceCny24h = [aDecoder decodeObjectForKey:kDBHQuotationVCModelTimeDataMaxPriceCny24h];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_priceCny forKey:kDBHQuotationVCModelTimeDataPriceCny];
    [aCoder encodeObject:_volumeCny24h forKey:kDBHQuotationVCModelTimeDataVolumeCny24h];
    [aCoder encodeObject:_priceUsd forKey:kDBHQuotationVCModelTimeDataPriceUsd];
    [aCoder encodeObject:_minPriceCny24h forKey:kDBHQuotationVCModelTimeDataMinPriceCny24h];
    [aCoder encodeObject:_volumeUsd24h forKey:kDBHQuotationVCModelTimeDataVolumeUsd24h];
    [aCoder encodeObject:_minPriceUsd24h forKey:kDBHQuotationVCModelTimeDataMinPriceUsd24h];
    [aCoder encodeObject:_change24h forKey:kDBHQuotationVCModelTimeDataChange24h];
    [aCoder encodeObject:_maxPriceUsd24h forKey:kDBHQuotationVCModelTimeDataMaxPriceUsd24h];
    [aCoder encodeObject:_maxPriceCny24h forKey:kDBHQuotationVCModelTimeDataMaxPriceCny24h];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHQuotationVCModelTimeData *copy = [[DBHQuotationVCModelTimeData alloc] init];
    
    
    
    if (copy) {

        copy.priceCny = [self.priceCny copyWithZone:zone];
        copy.volumeCny24h = [self.volumeCny24h copyWithZone:zone];
        copy.priceUsd = [self.priceUsd copyWithZone:zone];
        copy.minPriceCny24h = [self.minPriceCny24h copyWithZone:zone];
        copy.volumeUsd24h = [self.volumeUsd24h copyWithZone:zone];
        copy.minPriceUsd24h = [self.minPriceUsd24h copyWithZone:zone];
        copy.change24h = [self.change24h copyWithZone:zone];
        copy.maxPriceUsd24h = [self.maxPriceUsd24h copyWithZone:zone];
        copy.maxPriceCny24h = [self.maxPriceCny24h copyWithZone:zone];
    }
    
    return copy;
}


@end
