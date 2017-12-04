//
//  DBHInformationDetailForInweModelDataBase.m
//
//  Created by   on 2017/11/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailForInweModelDataBase.h"
#import "DBHInformationDetailForInweModelData.h"


NSString *const kDBHInformationDetailForInweModelDataBaseCode = @"code";
NSString *const kDBHInformationDetailForInweModelDataBaseData = @"data";
NSString *const kDBHInformationDetailForInweModelDataBaseMsg = @"msg";
NSString *const kDBHInformationDetailForInweModelDataBaseUrl = @"url";


@interface DBHInformationDetailForInweModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailForInweModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataBaseCode fromDictionary:dict] doubleValue];
    NSObject *receivedDBHInformationDetailForInweModelData = [dict objectForKey:kDBHInformationDetailForInweModelDataBaseData];
    NSMutableArray *parsedDBHInformationDetailForInweModelData = [NSMutableArray array];
    
    if ([receivedDBHInformationDetailForInweModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationDetailForInweModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationDetailForInweModelData addObject:[DBHInformationDetailForInweModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationDetailForInweModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationDetailForInweModelData addObject:[DBHInformationDetailForInweModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationDetailForInweModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHInformationDetailForInweModelData];
            self.msg = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHInformationDetailForInweModelDataBaseCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHInformationDetailForInweModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHInformationDetailForInweModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHInformationDetailForInweModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHInformationDetailForInweModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHInformationDetailForInweModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHInformationDetailForInweModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHInformationDetailForInweModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailForInweModelDataBase *copy = [[DBHInformationDetailForInweModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
