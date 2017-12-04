//
//  DBHInformationForRoastingChartCollectionModelDataBase.m
//
//  Created by   on 2017/11/22
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForRoastingChartCollectionModelDataBase.h"
#import "DBHInformationForRoastingChartCollectionModelData.h"


NSString *const kDBHInformationForRoastingChartCollectionModelDataBaseCode = @"code";
NSString *const kDBHInformationForRoastingChartCollectionModelDataBaseData = @"data";
NSString *const kDBHInformationForRoastingChartCollectionModelDataBaseMsg = @"msg";
NSString *const kDBHInformationForRoastingChartCollectionModelDataBaseUrl = @"url";


@interface DBHInformationForRoastingChartCollectionModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForRoastingChartCollectionModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelDataBaseCode fromDictionary:dict] doubleValue];
            self.data = [DBHInformationForRoastingChartCollectionModelData modelObjectWithDictionary:[dict objectForKey:kDBHInformationForRoastingChartCollectionModelDataBaseData]];
            self.msg = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHInformationForRoastingChartCollectionModelDataBaseCode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kDBHInformationForRoastingChartCollectionModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHInformationForRoastingChartCollectionModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHInformationForRoastingChartCollectionModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHInformationForRoastingChartCollectionModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHInformationForRoastingChartCollectionModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHInformationForRoastingChartCollectionModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHInformationForRoastingChartCollectionModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHInformationForRoastingChartCollectionModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForRoastingChartCollectionModelDataBase *copy = [[DBHInformationForRoastingChartCollectionModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
