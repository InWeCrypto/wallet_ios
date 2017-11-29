//
//  DBHInformationDetailModelProjectTimePrices.m
//
//  Created by   on 2017/11/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailModelProjectTimePrices.h"


NSString *const kDBHInformationDetailModelProjectTimePricesEnName = @"en_name";
NSString *const kDBHInformationDetailModelProjectTimePricesKLineDataUrl = @"k_line_data_url";
NSString *const kDBHInformationDetailModelProjectTimePricesId = @"id";
NSString *const kDBHInformationDetailModelProjectTimePricesCreatedAt = @"created_at";
NSString *const kDBHInformationDetailModelProjectTimePricesLongName = @"long_name";
NSString *const kDBHInformationDetailModelProjectTimePricesProjectId = @"project_id";
NSString *const kDBHInformationDetailModelProjectTimePricesUpdatedAt = @"updated_at";
NSString *const kDBHInformationDetailModelProjectTimePricesName = @"name";
NSString *const kDBHInformationDetailModelProjectTimePricesCurrentUrl = @"current_url";


@interface DBHInformationDetailModelProjectTimePrices ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailModelProjectTimePrices

@synthesize enName = _enName;
@synthesize kLineDataUrl = _kLineDataUrl;
@synthesize projectTimePricesIdentifier = _projectTimePricesIdentifier;
@synthesize createdAt = _createdAt;
@synthesize longName = _longName;
@synthesize projectId = _projectId;
@synthesize updatedAt = _updatedAt;
@synthesize name = _name;
@synthesize currentUrl = _currentUrl;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.enName = [self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesEnName fromDictionary:dict];
            self.kLineDataUrl = [self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesKLineDataUrl fromDictionary:dict];
            self.projectTimePricesIdentifier = [[self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesId fromDictionary:dict] doubleValue];
            self.createdAt = [self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesCreatedAt fromDictionary:dict];
            self.longName = [self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesLongName fromDictionary:dict];
            self.projectId = [[self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesProjectId fromDictionary:dict] doubleValue];
            self.updatedAt = [self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesUpdatedAt fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesName fromDictionary:dict];
            self.currentUrl = [self objectOrNilForKey:kDBHInformationDetailModelProjectTimePricesCurrentUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.enName forKey:kDBHInformationDetailModelProjectTimePricesEnName];
    [mutableDict setValue:self.kLineDataUrl forKey:kDBHInformationDetailModelProjectTimePricesKLineDataUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.projectTimePricesIdentifier] forKey:kDBHInformationDetailModelProjectTimePricesId];
    [mutableDict setValue:self.createdAt forKey:kDBHInformationDetailModelProjectTimePricesCreatedAt];
    [mutableDict setValue:self.longName forKey:kDBHInformationDetailModelProjectTimePricesLongName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.projectId] forKey:kDBHInformationDetailModelProjectTimePricesProjectId];
    [mutableDict setValue:self.updatedAt forKey:kDBHInformationDetailModelProjectTimePricesUpdatedAt];
    [mutableDict setValue:self.name forKey:kDBHInformationDetailModelProjectTimePricesName];
    [mutableDict setValue:self.currentUrl forKey:kDBHInformationDetailModelProjectTimePricesCurrentUrl];

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
    self.kLineDataUrl = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectTimePricesKLineDataUrl];
    self.projectTimePricesIdentifier = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelProjectTimePricesId];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectTimePricesCreatedAt];
    self.longName = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectTimePricesLongName];
    self.projectId = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelProjectTimePricesProjectId];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectTimePricesUpdatedAt];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectTimePricesName];
    self.currentUrl = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectTimePricesCurrentUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_enName forKey:kDBHInformationDetailModelProjectTimePricesEnName];
    [aCoder encodeObject:_kLineDataUrl forKey:kDBHInformationDetailModelProjectTimePricesKLineDataUrl];
    [aCoder encodeDouble:_projectTimePricesIdentifier forKey:kDBHInformationDetailModelProjectTimePricesId];
    [aCoder encodeObject:_createdAt forKey:kDBHInformationDetailModelProjectTimePricesCreatedAt];
    [aCoder encodeObject:_longName forKey:kDBHInformationDetailModelProjectTimePricesLongName];
    [aCoder encodeDouble:_projectId forKey:kDBHInformationDetailModelProjectTimePricesProjectId];
    [aCoder encodeObject:_updatedAt forKey:kDBHInformationDetailModelProjectTimePricesUpdatedAt];
    [aCoder encodeObject:_name forKey:kDBHInformationDetailModelProjectTimePricesName];
    [aCoder encodeObject:_currentUrl forKey:kDBHInformationDetailModelProjectTimePricesCurrentUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailModelProjectTimePrices *copy = [[DBHInformationDetailModelProjectTimePrices alloc] init];
    
    
    
    if (copy) {

        copy.enName = [self.enName copyWithZone:zone];
        copy.kLineDataUrl = [self.kLineDataUrl copyWithZone:zone];
        copy.projectTimePricesIdentifier = self.projectTimePricesIdentifier;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.longName = [self.longName copyWithZone:zone];
        copy.projectId = self.projectId;
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.currentUrl = [self.currentUrl copyWithZone:zone];
    }
    
    return copy;
}


@end
