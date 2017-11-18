//
//  DBHInformationDetailModelProjectTimePrices.m
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailModelProjectTimePrices.h"


NSString *const kDBHInformationDetailModelProjectTimePricesEnName = @"en_name";
NSString *const kDBHInformationDetailModelProjectTimePricesCurrentUrl = @"current_url";
NSString *const kDBHInformationDetailModelProjectTimePricesName = @"name";
NSString *const kDBHInformationDetailModelProjectTimePricesLongName = @"long_name";
NSString *const kDBHInformationDetailModelProjectTimePricesKLineDataUrl = @"k_line_data_url";


@interface DBHInformationDetailModelProjectTimePrices ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailModelProjectTimePrices

@synthesize enName = _enName;
@synthesize currentUrl = _currentUrl;
@synthesize name = _name;
@synthesize longName = _longName;
@synthesize kLineDataUrl = _kLineDataUrl;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.enName = [self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesEnName fromDictionary:dict];
            self.currentUrl = [self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesCurrentUrl fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesName fromDictionary:dict];
            self.longName = [self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesLongName fromDictionary:dict];
            self.kLineDataUrl = [self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesKLineDataUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.enName forKey:kDBHInformationDetailModelProjectTimePricesEnName];
    [mutableDict setValue:self.currentUrl forKey:kDBHInformationDetailModelProjectTimePricesCurrentUrl];
    [mutableDict setValue:self.name forKey:kDBHInformationDetailModelProjectTimePricesName];
    [mutableDict setValue:self.longName forKey:kDBHInformationDetailModelProjectTimePricesLongName];
    [mutableDict setValue:self.kLineDataUrl forKey:kDBHInformationDetailModelProjectTimePricesKLineDataUrl];

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

    self.enName = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectTimePricesEnName];
    self.currentUrl = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectTimePricesCurrentUrl];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectTimePricesName];
    self.longName = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectTimePricesLongName];
    self.kLineDataUrl = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectTimePricesKLineDataUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_enName forKey:kDBHInformationDetailModelProjectTimePricesEnName];
    [aCoder encodeObject:_currentUrl forKey:kDBHInformationDetailModelProjectTimePricesCurrentUrl];
    [aCoder encodeObject:_name forKey:kDBHInformationDetailModelProjectTimePricesName];
    [aCoder encodeObject:_longName forKey:kDBHInformationDetailModelProjectTimePricesLongName];
    [aCoder encodeObject:_kLineDataUrl forKey:kDBHInformationDetailModelProjectTimePricesKLineDataUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailModelProjectTimePrices *copy = [[DBHInformationDetailModelProjectTimePrices alloc] init];
    
    
    
    if (copy) {

        copy.enName = [self.enName copyWithZone:zone];
        copy.currentUrl = [self.currentUrl copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.longName = [self.longName copyWithZone:zone];
        copy.kLineDataUrl = [self.kLineDataUrl copyWithZone:zone];
    }
    
    return copy;
}


@end
