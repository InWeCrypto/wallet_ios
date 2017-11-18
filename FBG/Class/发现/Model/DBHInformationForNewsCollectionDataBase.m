//
//  DBHInformationForNewsCollectionDataBase.m
//
//  Created by   on 2017/11/15
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForNewsCollectionDataBase.h"
#import "DBHInformationForNewsCollectionData.h"


NSString *const kDBHInformationForNewsCollectionDataBaseCode = @"code";
NSString *const kDBHInformationForNewsCollectionDataBaseData = @"data";
NSString *const kDBHInformationForNewsCollectionDataBaseMsg = @"msg";
NSString *const kDBHInformationForNewsCollectionDataBaseUrl = @"url";


@interface DBHInformationForNewsCollectionDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForNewsCollectionDataBase

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
            self.code = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataBaseCode fromDictionary:dict] doubleValue];
    NSObject *receivedDBHInformationForNewsCollectionData = [dict objectForKey:kDBHInformationForNewsCollectionDataBaseData];
    NSMutableArray *parsedDBHInformationForNewsCollectionData = [NSMutableArray array];
    
    if ([receivedDBHInformationForNewsCollectionData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationForNewsCollectionData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationForNewsCollectionData addObject:[DBHInformationForNewsCollectionData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationForNewsCollectionData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationForNewsCollectionData addObject:[DBHInformationForNewsCollectionData modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationForNewsCollectionData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHInformationForNewsCollectionData];
            self.msg = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHInformationForNewsCollectionDataBaseCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHInformationForNewsCollectionDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHInformationForNewsCollectionDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHInformationForNewsCollectionDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHInformationForNewsCollectionDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHInformationForNewsCollectionDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHInformationForNewsCollectionDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHInformationForNewsCollectionDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForNewsCollectionDataBase *copy = [[DBHInformationForNewsCollectionDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
