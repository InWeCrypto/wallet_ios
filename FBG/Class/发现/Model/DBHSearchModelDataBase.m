//
//  DBHSearchModelDataBase.m
//
//  Created by   on 2017/11/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHSearchModelDataBase.h"
#import "DBHSearchModelData.h"


NSString *const kDBHSearchModelDataBaseCode = @"code";
NSString *const kDBHSearchModelDataBaseData = @"data";
NSString *const kDBHSearchModelDataBaseMsg = @"msg";
NSString *const kDBHSearchModelDataBaseUrl = @"url";


@interface DBHSearchModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHSearchModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHSearchModelDataBaseCode fromDictionary:dict] doubleValue];
    NSObject *receivedDBHSearchModelData = [dict objectForKey:kDBHSearchModelDataBaseData];
    NSMutableArray *parsedDBHSearchModelData = [NSMutableArray array];
    
    if ([receivedDBHSearchModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHSearchModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHSearchModelData addObject:[DBHSearchModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHSearchModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHSearchModelData addObject:[DBHSearchModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHSearchModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHSearchModelData];
            self.msg = [self objectOrNilForKey:kDBHSearchModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHSearchModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHSearchModelDataBaseCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHSearchModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHSearchModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHSearchModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHSearchModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHSearchModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHSearchModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHSearchModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHSearchModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHSearchModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHSearchModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHSearchModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHSearchModelDataBase *copy = [[DBHSearchModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
