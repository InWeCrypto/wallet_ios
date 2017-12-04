//
//  DBHInformationForNewsCollectionModelDataBase.m
//
//  Created by   on 2017/11/22
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForNewsCollectionModelDataBase.h"
#import "DBHInformationForNewsCollectionModelData.h"


NSString *const kDBHInformationForNewsCollectionModelDataBaseCode = @"code";
NSString *const kDBHInformationForNewsCollectionModelDataBaseData = @"data";
NSString *const kDBHInformationForNewsCollectionModelDataBaseMsg = @"msg";
NSString *const kDBHInformationForNewsCollectionModelDataBaseUrl = @"url";


@interface DBHInformationForNewsCollectionModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForNewsCollectionModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataBaseCode fromDictionary:dict] doubleValue];
    NSObject *receivedDBHInformationForNewsCollectionModelData = [dict objectForKey:kDBHInformationForNewsCollectionModelDataBaseData];
    NSMutableArray *parsedDBHInformationForNewsCollectionModelData = [NSMutableArray array];
    
    if ([receivedDBHInformationForNewsCollectionModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationForNewsCollectionModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationForNewsCollectionModelData addObject:[DBHInformationForNewsCollectionModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationForNewsCollectionModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationForNewsCollectionModelData addObject:[DBHInformationForNewsCollectionModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationForNewsCollectionModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHInformationForNewsCollectionModelData];
            self.msg = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHInformationForNewsCollectionModelDataBaseCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHInformationForNewsCollectionModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHInformationForNewsCollectionModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHInformationForNewsCollectionModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHInformationForNewsCollectionModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHInformationForNewsCollectionModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHInformationForNewsCollectionModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHInformationForNewsCollectionModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForNewsCollectionModelDataBase *copy = [[DBHInformationForNewsCollectionModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
