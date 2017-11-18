//
//  DBHInformationDetailModelProjectMarkets.m
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailModelProjectMarkets.h"


NSString *const kDBHInformationDetailModelProjectMarketsEnName = @"en_name";
NSString *const kDBHInformationDetailModelProjectMarketsName = @"name";
NSString *const kDBHInformationDetailModelProjectMarketsLongName = @"long_name";
NSString *const kDBHInformationDetailModelProjectMarketsUrl = @"url";


@interface DBHInformationDetailModelProjectMarkets ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailModelProjectMarkets

@synthesize enName = _enName;
@synthesize name = _name;
@synthesize longName = _longName;
@synthesize url = _url;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.enName = [self objectOrNilForKey:kDBHInformationDetailModelProjectMarketsEnName fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationDetailModelProjectMarketsName fromDictionary:dict];
            self.longName = [self objectOrNilForKey:kDBHInformationDetailModelProjectMarketsLongName fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationDetailModelProjectMarketsUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.enName forKey:kDBHInformationDetailModelProjectMarketsEnName];
    [mutableDict setValue:self.name forKey:kDBHInformationDetailModelProjectMarketsName];
    [mutableDict setValue:self.longName forKey:kDBHInformationDetailModelProjectMarketsLongName];
    [mutableDict setValue:self.url forKey:kDBHInformationDetailModelProjectMarketsUrl];

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

    self.enName = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectMarketsEnName];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectMarketsName];
    self.longName = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectMarketsLongName];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectMarketsUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_enName forKey:kDBHInformationDetailModelProjectMarketsEnName];
    [aCoder encodeObject:_name forKey:kDBHInformationDetailModelProjectMarketsName];
    [aCoder encodeObject:_longName forKey:kDBHInformationDetailModelProjectMarketsLongName];
    [aCoder encodeObject:_url forKey:kDBHInformationDetailModelProjectMarketsUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailModelProjectMarkets *copy = [[DBHInformationDetailModelProjectMarkets alloc] init];
    
    
    
    if (copy) {

        copy.enName = [self.enName copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.longName = [self.longName copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
