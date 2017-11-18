//
//  DBHInformationForRoastingChartCollectionDataBase.m
//
//  Created by   on 2017/11/14
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForRoastingChartCollectionDataBase.h"
#import "DBHInformationForRoastingChartCollectionData.h"


NSString *const kDBHInformationForRoastingChartCollectionDataBaseCode = @"code";
NSString *const kDBHInformationForRoastingChartCollectionDataBaseData = @"data";
NSString *const kDBHInformationForRoastingChartCollectionDataBaseMsg = @"msg";
NSString *const kDBHInformationForRoastingChartCollectionDataBaseUrl = @"url";


@interface DBHInformationForRoastingChartCollectionDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForRoastingChartCollectionDataBase

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
            self.code = [[self objectOrNilForKey:kDBHInformationForRoastingChartCollectionDataBaseCode fromDictionary:dict] doubleValue];
            self.data = [DBHInformationForRoastingChartCollectionData modelObjectWithDictionary:[dict objectForKey:kDBHInformationForRoastingChartCollectionDataBaseData]];
            self.msg = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHInformationForRoastingChartCollectionDataBaseCode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kDBHInformationForRoastingChartCollectionDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHInformationForRoastingChartCollectionDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHInformationForRoastingChartCollectionDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHInformationForRoastingChartCollectionDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHInformationForRoastingChartCollectionDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHInformationForRoastingChartCollectionDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHInformationForRoastingChartCollectionDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHInformationForRoastingChartCollectionDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForRoastingChartCollectionDataBase *copy = [[DBHInformationForRoastingChartCollectionDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
