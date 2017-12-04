//
//  AddQuotesVCModelData.m
//
//  Created by   on 2017/12/2
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "AddQuotesVCModelData.h"
#import "AddQuotesVCModelUserTicker.h"


NSString *const kAddQuotesVCModelDataId = @"id";
NSString *const kAddQuotesVCModelDataEnable = @"enable";
NSString *const kAddQuotesVCModelDataUnit = @"unit";
NSString *const kAddQuotesVCModelDataUserTicker = @"user_ticker";
NSString *const kAddQuotesVCModelDataCreatedAt = @"created_at";
NSString *const kAddQuotesVCModelDataWebSite = @"web_site";
NSString *const kAddQuotesVCModelDataEnName = @"en_name";
NSString *const kAddQuotesVCModelDataImg = @"img";
NSString *const kAddQuotesVCModelDataKey = @"key";
NSString *const kAddQuotesVCModelDataDesc = @"desc";
NSString *const kAddQuotesVCModelDataUpdatedAt = @"updated_at";
NSString *const kAddQuotesVCModelDataEnLongName = @"en_long_name";
NSString *const kAddQuotesVCModelDataLongName = @"long_name";
NSString *const kAddQuotesVCModelDataName = @"name";
NSString *const kAddQuotesVCModelDataSort = @"sort";


@interface AddQuotesVCModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AddQuotesVCModelData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize enable = _enable;
@synthesize unit = _unit;
@synthesize userTicker = _userTicker;
@synthesize createdAt = _createdAt;
@synthesize webSite = _webSite;
@synthesize enName = _enName;
@synthesize img = _img;
@synthesize key = _key;
@synthesize desc = _desc;
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
            self.dataIdentifier = [[self objectOrNilForKey:kAddQuotesVCModelDataId fromDictionary:dict] doubleValue];
            self.enable = [[self objectOrNilForKey:kAddQuotesVCModelDataEnable fromDictionary:dict] doubleValue];
            self.unit = [self objectOrNilForKey:kAddQuotesVCModelDataUnit fromDictionary:dict];
            self.userTicker = [AddQuotesVCModelUserTicker modelObjectWithDictionary:[dict objectForKey:kAddQuotesVCModelDataUserTicker]];
            self.createdAt = [self objectOrNilForKey:kAddQuotesVCModelDataCreatedAt fromDictionary:dict];
            self.webSite = [self objectOrNilForKey:kAddQuotesVCModelDataWebSite fromDictionary:dict];
            self.enName = [self objectOrNilForKey:kAddQuotesVCModelDataEnName fromDictionary:dict];
            self.img = [self objectOrNilForKey:kAddQuotesVCModelDataImg fromDictionary:dict];
            self.key = [self objectOrNilForKey:kAddQuotesVCModelDataKey fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kAddQuotesVCModelDataDesc fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kAddQuotesVCModelDataUpdatedAt fromDictionary:dict];
            self.enLongName = [self objectOrNilForKey:kAddQuotesVCModelDataEnLongName fromDictionary:dict];
            self.longName = [self objectOrNilForKey:kAddQuotesVCModelDataLongName fromDictionary:dict];
            self.name = [self objectOrNilForKey:kAddQuotesVCModelDataName fromDictionary:dict];
            self.sort = [[self objectOrNilForKey:kAddQuotesVCModelDataSort fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kAddQuotesVCModelDataId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.enable] forKey:kAddQuotesVCModelDataEnable];
    [mutableDict setValue:self.unit forKey:kAddQuotesVCModelDataUnit];
    [mutableDict setValue:[self.userTicker dictionaryRepresentation] forKey:kAddQuotesVCModelDataUserTicker];
    [mutableDict setValue:self.createdAt forKey:kAddQuotesVCModelDataCreatedAt];
    [mutableDict setValue:self.webSite forKey:kAddQuotesVCModelDataWebSite];
    [mutableDict setValue:self.enName forKey:kAddQuotesVCModelDataEnName];
    [mutableDict setValue:self.img forKey:kAddQuotesVCModelDataImg];
    [mutableDict setValue:self.key forKey:kAddQuotesVCModelDataKey];
    [mutableDict setValue:self.desc forKey:kAddQuotesVCModelDataDesc];
    [mutableDict setValue:self.updatedAt forKey:kAddQuotesVCModelDataUpdatedAt];
    [mutableDict setValue:self.enLongName forKey:kAddQuotesVCModelDataEnLongName];
    [mutableDict setValue:self.longName forKey:kAddQuotesVCModelDataLongName];
    [mutableDict setValue:self.name forKey:kAddQuotesVCModelDataName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kAddQuotesVCModelDataSort];

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

    self.dataIdentifier = [aDecoder decodeDoubleForKey:kAddQuotesVCModelDataId];
    self.enable = [aDecoder decodeDoubleForKey:kAddQuotesVCModelDataEnable];
    self.unit = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataUnit];
    self.userTicker = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataUserTicker];
    self.createdAt = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataCreatedAt];
    self.webSite = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataWebSite];
    self.enName = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataEnName];
    self.img = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataImg];
    self.key = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataKey];
    self.desc = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataDesc];
    self.updatedAt = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataUpdatedAt];
    self.enLongName = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataEnLongName];
    self.longName = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataLongName];
    self.name = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataName];
    self.sort = [aDecoder decodeDoubleForKey:kAddQuotesVCModelDataSort];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_dataIdentifier forKey:kAddQuotesVCModelDataId];
    [aCoder encodeDouble:_enable forKey:kAddQuotesVCModelDataEnable];
    [aCoder encodeObject:_unit forKey:kAddQuotesVCModelDataUnit];
    [aCoder encodeObject:_userTicker forKey:kAddQuotesVCModelDataUserTicker];
    [aCoder encodeObject:_createdAt forKey:kAddQuotesVCModelDataCreatedAt];
    [aCoder encodeObject:_webSite forKey:kAddQuotesVCModelDataWebSite];
    [aCoder encodeObject:_enName forKey:kAddQuotesVCModelDataEnName];
    [aCoder encodeObject:_img forKey:kAddQuotesVCModelDataImg];
    [aCoder encodeObject:_key forKey:kAddQuotesVCModelDataKey];
    [aCoder encodeObject:_desc forKey:kAddQuotesVCModelDataDesc];
    [aCoder encodeObject:_updatedAt forKey:kAddQuotesVCModelDataUpdatedAt];
    [aCoder encodeObject:_enLongName forKey:kAddQuotesVCModelDataEnLongName];
    [aCoder encodeObject:_longName forKey:kAddQuotesVCModelDataLongName];
    [aCoder encodeObject:_name forKey:kAddQuotesVCModelDataName];
    [aCoder encodeDouble:_sort forKey:kAddQuotesVCModelDataSort];
}

- (id)copyWithZone:(NSZone *)zone {
    AddQuotesVCModelData *copy = [[AddQuotesVCModelData alloc] init];
    
    
    
    if (copy) {

        copy.dataIdentifier = self.dataIdentifier;
        copy.enable = self.enable;
        copy.unit = [self.unit copyWithZone:zone];
        copy.userTicker = [self.userTicker copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.webSite = [self.webSite copyWithZone:zone];
        copy.enName = [self.enName copyWithZone:zone];
        copy.img = [self.img copyWithZone:zone];
        copy.key = [self.key copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.enLongName = [self.enLongName copyWithZone:zone];
        copy.longName = [self.longName copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.sort = self.sort;
    }
    
    return copy;
}


@end
