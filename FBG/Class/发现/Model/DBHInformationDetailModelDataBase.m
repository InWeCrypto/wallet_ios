//
//  DBHInformationDetailModelDataBase.m
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailModelDataBase.h"
#import "DBHInformationDetailModelData.h"


NSString *const kDBHInformationDetailModelDataBaseCode = @"code";
NSString *const kDBHInformationDetailModelDataBaseData = @"data";
NSString *const kDBHInformationDetailModelDataBaseMsg = @"msg";
NSString *const kDBHInformationDetailModelDataBaseUrl = @"url";


@interface DBHInformationDetailModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHInformationDetailModelDataBaseCode fromDictionary:dict] doubleValue];
            self.data = [DBHInformationDetailModelData modelObjectWithDictionary:[dict objectForKey:kDBHInformationDetailModelDataBaseData]];
            self.msg = [self objectOrNilForKey:kDBHInformationDetailModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationDetailModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHInformationDetailModelDataBaseCode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kDBHInformationDetailModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHInformationDetailModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHInformationDetailModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHInformationDetailModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHInformationDetailModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHInformationDetailModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHInformationDetailModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailModelDataBase *copy = [[DBHInformationDetailModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
