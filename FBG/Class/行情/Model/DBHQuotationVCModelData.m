//
//  DBHQuotationVCModelData.m
//
//  Created by   on 2017/12/2
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHQuotationVCModelData.h"
#import "DBHQuotationVCModelTimeData.h"


NSString *const kDBHQuotationVCModelDataId = @"id";
NSString *const kDBHQuotationVCModelDataEnable = @"enable";
NSString *const kDBHQuotationVCModelDataUnit = @"unit";
NSString *const kDBHQuotationVCModelDataCreatedAt = @"created_at";
NSString *const kDBHQuotationVCModelDataWebSite = @"web_site";
NSString *const kDBHQuotationVCModelDataTimeData = @"time_data";
NSString *const kDBHQuotationVCModelDataDesc = @"desc";
NSString *const kDBHQuotationVCModelDataEnName = @"en_name";
NSString *const kDBHQuotationVCModelDataImg = @"img";
NSString *const kDBHQuotationVCModelDataKey = @"key";
NSString *const kDBHQuotationVCModelDataUpdatedAt = @"updated_at";
NSString *const kDBHQuotationVCModelDataEnLongName = @"en_long_name";
NSString *const kDBHQuotationVCModelDataLongName = @"long_name";
NSString *const kDBHQuotationVCModelDataName = @"name";
NSString *const kDBHQuotationVCModelDataSort = @"sort";


@interface DBHQuotationVCModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHQuotationVCModelData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize enable = _enable;
@synthesize unit = _unit;
@synthesize createdAt = _createdAt;
@synthesize webSite = _webSite;
@synthesize timeData = _timeData;
@synthesize desc = _desc;
@synthesize enName = _enName;
@synthesize img = _img;
@synthesize key = _key;
@synthesize updatedAt = _updatedAt;
@synthesize enLongName = _enLongName;
@synthesize longName = _longName;
@synthesize name = _name;
@synthesize sort = _sort;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.dataIdentifier = [self objectOrNilForKey:kDBHQuotationVCModelDataId fromDictionary:dict];
            self.enable = [self objectOrNilForKey:kDBHQuotationVCModelDataEnable fromDictionary:dict];
            self.unit = [self objectOrNilForKey:kDBHQuotationVCModelDataUnit fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kDBHQuotationVCModelDataCreatedAt fromDictionary:dict];
            self.webSite = [self objectOrNilForKey:kDBHQuotationVCModelDataWebSite fromDictionary:dict];
            self.timeData = [DBHQuotationVCModelTimeData modelObjectWithDictionary:[dict objectForKey:kDBHQuotationVCModelDataTimeData]];
            self.desc = [self objectOrNilForKey:kDBHQuotationVCModelDataDesc fromDictionary:dict];
            self.enName = [self objectOrNilForKey:kDBHQuotationVCModelDataEnName fromDictionary:dict];
            self.img = [self objectOrNilForKey:kDBHQuotationVCModelDataImg fromDictionary:dict];
            self.key = [self objectOrNilForKey:kDBHQuotationVCModelDataKey fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kDBHQuotationVCModelDataUpdatedAt fromDictionary:dict];
            self.enLongName = [self objectOrNilForKey:kDBHQuotationVCModelDataEnLongName fromDictionary:dict];
            self.longName = [self objectOrNilForKey:kDBHQuotationVCModelDataLongName fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHQuotationVCModelDataName fromDictionary:dict];
            self.sort = [self objectOrNilForKey:kDBHQuotationVCModelDataSort fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.dataIdentifier forKey:kDBHQuotationVCModelDataId];
    [mutableDict setValue:self.enable forKey:kDBHQuotationVCModelDataEnable];
    [mutableDict setValue:self.unit forKey:kDBHQuotationVCModelDataUnit];
    [mutableDict setValue:self.createdAt forKey:kDBHQuotationVCModelDataCreatedAt];
    [mutableDict setValue:self.webSite forKey:kDBHQuotationVCModelDataWebSite];
    [mutableDict setValue:[self.timeData dictionaryRepresentation] forKey:kDBHQuotationVCModelDataTimeData];
    [mutableDict setValue:self.desc forKey:kDBHQuotationVCModelDataDesc];
    [mutableDict setValue:self.enName forKey:kDBHQuotationVCModelDataEnName];
    [mutableDict setValue:self.img forKey:kDBHQuotationVCModelDataImg];
    [mutableDict setValue:self.key forKey:kDBHQuotationVCModelDataKey];
    [mutableDict setValue:self.updatedAt forKey:kDBHQuotationVCModelDataUpdatedAt];
    [mutableDict setValue:self.enLongName forKey:kDBHQuotationVCModelDataEnLongName];
    [mutableDict setValue:self.longName forKey:kDBHQuotationVCModelDataLongName];
    [mutableDict setValue:self.name forKey:kDBHQuotationVCModelDataName];
    [mutableDict setValue:self.sort forKey:kDBHQuotationVCModelDataSort];

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

    self.dataIdentifier = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataId];
    self.enable = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataEnable];
    self.unit = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataUnit];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataCreatedAt];
    self.webSite = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataWebSite];
    self.timeData = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataTimeData];
    self.desc = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataDesc];
    self.enName = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataEnName];
    self.img = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataImg];
    self.key = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataKey];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataUpdatedAt];
    self.enLongName = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataEnLongName];
    self.longName = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataLongName];
    self.name = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataName];
    self.sort = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataSort];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_dataIdentifier forKey:kDBHQuotationVCModelDataId];
    [aCoder encodeObject:_enable forKey:kDBHQuotationVCModelDataEnable];
    [aCoder encodeObject:_unit forKey:kDBHQuotationVCModelDataUnit];
    [aCoder encodeObject:_createdAt forKey:kDBHQuotationVCModelDataCreatedAt];
    [aCoder encodeObject:_webSite forKey:kDBHQuotationVCModelDataWebSite];
    [aCoder encodeObject:_timeData forKey:kDBHQuotationVCModelDataTimeData];
    [aCoder encodeObject:_desc forKey:kDBHQuotationVCModelDataDesc];
    [aCoder encodeObject:_enName forKey:kDBHQuotationVCModelDataEnName];
    [aCoder encodeObject:_img forKey:kDBHQuotationVCModelDataImg];
    [aCoder encodeObject:_key forKey:kDBHQuotationVCModelDataKey];
    [aCoder encodeObject:_updatedAt forKey:kDBHQuotationVCModelDataUpdatedAt];
    [aCoder encodeObject:_enLongName forKey:kDBHQuotationVCModelDataEnLongName];
    [aCoder encodeObject:_longName forKey:kDBHQuotationVCModelDataLongName];
    [aCoder encodeObject:_name forKey:kDBHQuotationVCModelDataName];
    [aCoder encodeObject:_sort forKey:kDBHQuotationVCModelDataSort];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHQuotationVCModelData *copy = [[DBHQuotationVCModelData alloc] init];
    
    
    
    if (copy) {

        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.enable = [self.enable copyWithZone:zone];
        copy.unit = [self.unit copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.webSite = [self.webSite copyWithZone:zone];
        copy.timeData = [self.timeData copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.enName = [self.enName copyWithZone:zone];
        copy.img = [self.img copyWithZone:zone];
        copy.key = [self.key copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.enLongName = [self.enLongName copyWithZone:zone];
        copy.longName = [self.longName copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.sort = [self.sort copyWithZone:zone];
    }
    
    return copy;
}


@end
