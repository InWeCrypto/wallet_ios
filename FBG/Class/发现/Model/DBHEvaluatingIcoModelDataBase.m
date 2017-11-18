//
//  DBHEvaluatingIcoModelDataBase.m
//
//  Created by   on 2017/11/16
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHEvaluatingIcoModelDataBase.h"
#import "DBHEvaluatingIcoModelData.h"


NSString *const kDBHEvaluatingIcoModelDataBaseCode = @"code";
NSString *const kDBHEvaluatingIcoModelDataBaseData = @"data";
NSString *const kDBHEvaluatingIcoModelDataBaseMsg = @"msg";
NSString *const kDBHEvaluatingIcoModelDataBaseUrl = @"url";


@interface DBHEvaluatingIcoModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHEvaluatingIcoModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHEvaluatingIcoModelDataBaseCode fromDictionary:dict] doubleValue];
    NSObject *receivedDBHEvaluatingIcoModelData = [dict objectForKey:kDBHEvaluatingIcoModelDataBaseData];
    NSMutableArray *parsedDBHEvaluatingIcoModelData = [NSMutableArray array];
    
    if ([receivedDBHEvaluatingIcoModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHEvaluatingIcoModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHEvaluatingIcoModelData addObject:[DBHEvaluatingIcoModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHEvaluatingIcoModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHEvaluatingIcoModelData addObject:[DBHEvaluatingIcoModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHEvaluatingIcoModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHEvaluatingIcoModelData];
            self.msg = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHEvaluatingIcoModelDataBaseCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHEvaluatingIcoModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHEvaluatingIcoModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHEvaluatingIcoModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHEvaluatingIcoModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHEvaluatingIcoModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHEvaluatingIcoModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHEvaluatingIcoModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHEvaluatingIcoModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHEvaluatingIcoModelDataBase *copy = [[DBHEvaluatingIcoModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
