//
//  DBHAllInformationModelDataBase.m
//
//  Created by   on 2017/11/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHAllInformationModelDataBase.h"
#import "DBHAllInformationModelData.h"


NSString *const kDBHAllInformationModelDataBaseCode = @"code";
NSString *const kDBHAllInformationModelDataBaseData = @"data";
NSString *const kDBHAllInformationModelDataBaseMsg = @"msg";
NSString *const kDBHAllInformationModelDataBaseUrl = @"url";


@interface DBHAllInformationModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHAllInformationModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHAllInformationModelDataBaseCode fromDictionary:dict] doubleValue];
    NSObject *receivedDBHAllInformationModelData = [dict objectForKey:kDBHAllInformationModelDataBaseData];
    NSMutableArray *parsedDBHAllInformationModelData = [NSMutableArray array];
    
    if ([receivedDBHAllInformationModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHAllInformationModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHAllInformationModelData addObject:[DBHAllInformationModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHAllInformationModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHAllInformationModelData addObject:[DBHAllInformationModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHAllInformationModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHAllInformationModelData];
            self.msg = [self objectOrNilForKey:kDBHAllInformationModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHAllInformationModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHAllInformationModelDataBaseCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHAllInformationModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHAllInformationModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHAllInformationModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHAllInformationModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHAllInformationModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHAllInformationModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHAllInformationModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHAllInformationModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHAllInformationModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHAllInformationModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHAllInformationModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHAllInformationModelDataBase *copy = [[DBHAllInformationModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
