//
//  DBHInformationForProjectCollectionModelDataBase.m
//
//  Created by   on 2017/11/16
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForProjectCollectionModelDataBase.h"
#import "DBHInformationForProjectCollectionModelData.h"


NSString *const kDBHInformationForProjectCollectionModelDataBaseCode = @"code";
NSString *const kDBHInformationForProjectCollectionModelDataBaseData = @"data";
NSString *const kDBHInformationForProjectCollectionModelDataBaseMsg = @"msg";
NSString *const kDBHInformationForProjectCollectionModelDataBaseUrl = @"url";


@interface DBHInformationForProjectCollectionModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForProjectCollectionModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataBaseCode fromDictionary:dict] doubleValue];
    NSObject *receivedDBHInformationForProjectCollectionModelData = [dict objectForKey:kDBHInformationForProjectCollectionModelDataBaseData];
    NSMutableArray *parsedDBHInformationForProjectCollectionModelData = [NSMutableArray array];
    
    if ([receivedDBHInformationForProjectCollectionModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationForProjectCollectionModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationForProjectCollectionModelData addObject:[DBHInformationForProjectCollectionModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationForProjectCollectionModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationForProjectCollectionModelData addObject:[DBHInformationForProjectCollectionModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationForProjectCollectionModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHInformationForProjectCollectionModelData];
            self.msg = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHInformationForProjectCollectionModelDataBaseCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHInformationForProjectCollectionModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHInformationForProjectCollectionModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHInformationForProjectCollectionModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHInformationForProjectCollectionModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHInformationForProjectCollectionModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHInformationForProjectCollectionModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHInformationForProjectCollectionModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHInformationForProjectCollectionModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForProjectCollectionModelDataBase *copy = [[DBHInformationForProjectCollectionModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
