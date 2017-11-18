//
//  DBHInformationDetailForTradingMarketContentModelData.m
//
//  Created by   on 2017/11/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailForTradingMarketContentModelData.h"


NSString *const kDBHInformationDetailForTradingMarketContentModelDataPairce = @"pairce";
NSString *const kDBHInformationDetailForTradingMarketContentModelDataSource = @"source";
NSString *const kDBHInformationDetailForTradingMarketContentModelDataSort = @"sort";
NSString *const kDBHInformationDetailForTradingMarketContentModelDataUpdate = @"update";
NSString *const kDBHInformationDetailForTradingMarketContentModelDataVolumPercent = @"volum_percent";
NSString *const kDBHInformationDetailForTradingMarketContentModelDataVolum24 = @"volum_24";
NSString *const kDBHInformationDetailForTradingMarketContentModelDataPair = @"pair";


@interface DBHInformationDetailForTradingMarketContentModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailForTradingMarketContentModelData

@synthesize pairce = _pairce;
@synthesize source = _source;
@synthesize sort = _sort;
@synthesize update = _update;
@synthesize volumPercent = _volumPercent;
@synthesize volum24 = _volum24;
@synthesize pair = _pair;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.pairce = [self objectOrNilForKey:kDBHInformationDetailForTradingMarketContentModelDataPairce fromDictionary:dict];
            self.source = [self objectOrNilForKey:kDBHInformationDetailForTradingMarketContentModelDataSource fromDictionary:dict];
            self.sort = [self objectOrNilForKey:kDBHInformationDetailForTradingMarketContentModelDataSort fromDictionary:dict];
            self.update = [self objectOrNilForKey:kDBHInformationDetailForTradingMarketContentModelDataUpdate fromDictionary:dict];
            self.volumPercent = [self objectOrNilForKey:kDBHInformationDetailForTradingMarketContentModelDataVolumPercent fromDictionary:dict];
            self.volum24 = [self objectOrNilForKey:kDBHInformationDetailForTradingMarketContentModelDataVolum24 fromDictionary:dict];
            self.pair = [self objectOrNilForKey:kDBHInformationDetailForTradingMarketContentModelDataPair fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.pairce forKey:kDBHInformationDetailForTradingMarketContentModelDataPairce];
    [mutableDict setValue:self.source forKey:kDBHInformationDetailForTradingMarketContentModelDataSource];
    [mutableDict setValue:self.sort forKey:kDBHInformationDetailForTradingMarketContentModelDataSort];
    [mutableDict setValue:self.update forKey:kDBHInformationDetailForTradingMarketContentModelDataUpdate];
    [mutableDict setValue:self.volumPercent forKey:kDBHInformationDetailForTradingMarketContentModelDataVolumPercent];
    [mutableDict setValue:self.volum24 forKey:kDBHInformationDetailForTradingMarketContentModelDataVolum24];
    [mutableDict setValue:self.pair forKey:kDBHInformationDetailForTradingMarketContentModelDataPair];

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

    self.pairce = [aDecoder decodeObjectForKey:kDBHInformationDetailForTradingMarketContentModelDataPairce];
    self.source = [aDecoder decodeObjectForKey:kDBHInformationDetailForTradingMarketContentModelDataSource];
    self.sort = [aDecoder decodeObjectForKey:kDBHInformationDetailForTradingMarketContentModelDataSort];
    self.update = [aDecoder decodeObjectForKey:kDBHInformationDetailForTradingMarketContentModelDataUpdate];
    self.volumPercent = [aDecoder decodeObjectForKey:kDBHInformationDetailForTradingMarketContentModelDataVolumPercent];
    self.volum24 = [aDecoder decodeObjectForKey:kDBHInformationDetailForTradingMarketContentModelDataVolum24];
    self.pair = [aDecoder decodeObjectForKey:kDBHInformationDetailForTradingMarketContentModelDataPair];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_pairce forKey:kDBHInformationDetailForTradingMarketContentModelDataPairce];
    [aCoder encodeObject:_source forKey:kDBHInformationDetailForTradingMarketContentModelDataSource];
    [aCoder encodeObject:_sort forKey:kDBHInformationDetailForTradingMarketContentModelDataSort];
    [aCoder encodeObject:_update forKey:kDBHInformationDetailForTradingMarketContentModelDataUpdate];
    [aCoder encodeObject:_volumPercent forKey:kDBHInformationDetailForTradingMarketContentModelDataVolumPercent];
    [aCoder encodeObject:_volum24 forKey:kDBHInformationDetailForTradingMarketContentModelDataVolum24];
    [aCoder encodeObject:_pair forKey:kDBHInformationDetailForTradingMarketContentModelDataPair];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailForTradingMarketContentModelData *copy = [[DBHInformationDetailForTradingMarketContentModelData alloc] init];
    
    
    
    if (copy) {

        copy.pairce = [self.pairce copyWithZone:zone];
        copy.source = [self.source copyWithZone:zone];
        copy.sort = [self.sort copyWithZone:zone];
        copy.update = [self.update copyWithZone:zone];
        copy.volumPercent = [self.volumPercent copyWithZone:zone];
        copy.volum24 = [self.volum24 copyWithZone:zone];
        copy.pair = [self.pair copyWithZone:zone];
    }
    
    return copy;
}


@end
