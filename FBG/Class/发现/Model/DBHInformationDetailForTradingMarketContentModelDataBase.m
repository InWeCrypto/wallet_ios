//
//  DBHInformationDetailForTradingMarketContentModelDataBase.m
//
//  Created by   on 2017/11/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailForTradingMarketContentModelDataBase.h"
#import "DBHInformationDetailForTradingMarketContentModelData.h"


NSString *const kDBHInformationDetailForTradingMarketContentModelDataBaseCode = @"code";
NSString *const kDBHInformationDetailForTradingMarketContentModelDataBaseData = @"data";
NSString *const kDBHInformationDetailForTradingMarketContentModelDataBaseMsg = @"msg";
NSString *const kDBHInformationDetailForTradingMarketContentModelDataBaseUrl = @"url";


@interface DBHInformationDetailForTradingMarketContentModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailForTradingMarketContentModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHInformationDetailForTradingMarketContentModelDataBaseCode fromDictionary:dict] doubleValue];
    NSObject *receivedDBHInformationDetailForTradingMarketContentModelData = [dict objectForKey:kDBHInformationDetailForTradingMarketContentModelDataBaseData];
    NSMutableArray *parsedDBHInformationDetailForTradingMarketContentModelData = [NSMutableArray array];
    
    if ([receivedDBHInformationDetailForTradingMarketContentModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationDetailForTradingMarketContentModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationDetailForTradingMarketContentModelData addObject:[DBHInformationDetailForTradingMarketContentModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationDetailForTradingMarketContentModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationDetailForTradingMarketContentModelData addObject:[DBHInformationDetailForTradingMarketContentModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationDetailForTradingMarketContentModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHInformationDetailForTradingMarketContentModelData];
            self.msg = [self objectOrNilForKey:kDBHInformationDetailForTradingMarketContentModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationDetailForTradingMarketContentModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHInformationDetailForTradingMarketContentModelDataBaseCode];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.data) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHInformationDetailForTradingMarketContentModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHInformationDetailForTradingMarketContentModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHInformationDetailForTradingMarketContentModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHInformationDetailForTradingMarketContentModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHInformationDetailForTradingMarketContentModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHInformationDetailForTradingMarketContentModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationDetailForTradingMarketContentModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHInformationDetailForTradingMarketContentModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHInformationDetailForTradingMarketContentModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHInformationDetailForTradingMarketContentModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHInformationDetailForTradingMarketContentModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailForTradingMarketContentModelDataBase *copy = [[DBHInformationDetailForTradingMarketContentModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
