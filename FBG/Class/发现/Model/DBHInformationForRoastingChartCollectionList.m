//
//  DBHInformationForRoastingChartCollectionList.m
//
//  Created by   on 2017/11/14
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForRoastingChartCollectionList.h"


NSString *const kDBHInformationForRoastingChartCollectionListId = @"id";
NSString *const kDBHInformationForRoastingChartCollectionListEndAt = @"end_at";
NSString *const kDBHInformationForRoastingChartCollectionListStyle = @"style";
NSString *const kDBHInformationForRoastingChartCollectionListEnable = @"enable";
NSString *const kDBHInformationForRoastingChartCollectionListStatus = @"status";
NSString *const kDBHInformationForRoastingChartCollectionListCreatedAt = @"created_at";
NSString *const kDBHInformationForRoastingChartCollectionListUrlDesc = @"url_desc";
NSString *const kDBHInformationForRoastingChartCollectionListUrl = @"url";
NSString *const kDBHInformationForRoastingChartCollectionListEnName = @"en_name";
NSString *const kDBHInformationForRoastingChartCollectionListImg = @"img";
NSString *const kDBHInformationForRoastingChartCollectionListDesc = @"desc";
NSString *const kDBHInformationForRoastingChartCollectionListStartAt = @"start_at";
NSString *const kDBHInformationForRoastingChartCollectionListIcon = @"icon";
NSString *const kDBHInformationForRoastingChartCollectionListUpdatedAt = @"updated_at";
NSString *const kDBHInformationForRoastingChartCollectionListUrlIcon = @"url_icon";
NSString *const kDBHInformationForRoastingChartCollectionListUrlImg = @"url_img";
NSString *const kDBHInformationForRoastingChartCollectionListLongName = @"long_name";
NSString *const kDBHInformationForRoastingChartCollectionListName = @"name";
NSString *const kDBHInformationForRoastingChartCollectionListSort = @"sort";


@interface DBHInformationForRoastingChartCollectionList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForRoastingChartCollectionList

@synthesize listIdentifier = _listIdentifier;
@synthesize endAt = _endAt;
@synthesize style = _style;
@synthesize enable = _enable;
@synthesize status = _status;
@synthesize createdAt = _createdAt;
@synthesize urlDesc = _urlDesc;
@synthesize url = _url;
@synthesize enName = _enName;
@synthesize img = _img;
@synthesize desc = _desc;
@synthesize startAt = _startAt;
@synthesize icon = _icon;
@synthesize updatedAt = _updatedAt;
@synthesize urlIcon = _urlIcon;
@synthesize urlImg = _urlImg;
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
            self.listIdentifier = [[self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListId fromDictionary:dict] doubleValue];
            self.endAt = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListEndAt fromDictionary:dict];
            self.style = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListStyle fromDictionary:dict];
            self.enable = [[self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListEnable fromDictionary:dict] doubleValue];
            self.status = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListStatus fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListCreatedAt fromDictionary:dict];
            self.urlDesc = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListUrlDesc fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListUrl fromDictionary:dict];
            self.enName = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListEnName fromDictionary:dict];
            self.img = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListImg fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListDesc fromDictionary:dict];
            self.startAt = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListStartAt fromDictionary:dict];
            self.icon = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListIcon fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListUpdatedAt fromDictionary:dict];
            self.urlIcon = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListUrlIcon fromDictionary:dict];
            self.urlImg = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListUrlImg fromDictionary:dict];
            self.longName = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListLongName fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListName fromDictionary:dict];
            self.sort = [[self objectOrNilForKey:kDBHInformationForRoastingChartCollectionListSort fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.listIdentifier] forKey:kDBHInformationForRoastingChartCollectionListId];
    [mutableDict setValue:self.endAt forKey:kDBHInformationForRoastingChartCollectionListEndAt];
    [mutableDict setValue:self.style forKey:kDBHInformationForRoastingChartCollectionListStyle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.enable] forKey:kDBHInformationForRoastingChartCollectionListEnable];
    [mutableDict setValue:self.status forKey:kDBHInformationForRoastingChartCollectionListStatus];
    [mutableDict setValue:self.createdAt forKey:kDBHInformationForRoastingChartCollectionListCreatedAt];
    [mutableDict setValue:self.urlDesc forKey:kDBHInformationForRoastingChartCollectionListUrlDesc];
    [mutableDict setValue:self.url forKey:kDBHInformationForRoastingChartCollectionListUrl];
    [mutableDict setValue:self.enName forKey:kDBHInformationForRoastingChartCollectionListEnName];
    [mutableDict setValue:self.img forKey:kDBHInformationForRoastingChartCollectionListImg];
    [mutableDict setValue:self.desc forKey:kDBHInformationForRoastingChartCollectionListDesc];
    [mutableDict setValue:self.startAt forKey:kDBHInformationForRoastingChartCollectionListStartAt];
    [mutableDict setValue:self.icon forKey:kDBHInformationForRoastingChartCollectionListIcon];
    [mutableDict setValue:self.updatedAt forKey:kDBHInformationForRoastingChartCollectionListUpdatedAt];
    [mutableDict setValue:self.urlIcon forKey:kDBHInformationForRoastingChartCollectionListUrlIcon];
    [mutableDict setValue:self.urlImg forKey:kDBHInformationForRoastingChartCollectionListUrlImg];
    [mutableDict setValue:self.longName forKey:kDBHInformationForRoastingChartCollectionListLongName];
    [mutableDict setValue:self.name forKey:kDBHInformationForRoastingChartCollectionListName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kDBHInformationForRoastingChartCollectionListSort];

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

    self.listIdentifier = [aDecoder decodeDoubleForKey:kDBHInformationForRoastingChartCollectionListId];
    self.endAt = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListEndAt];
    self.style = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListStyle];
    self.enable = [aDecoder decodeDoubleForKey:kDBHInformationForRoastingChartCollectionListEnable];
    self.status = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListStatus];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListCreatedAt];
    self.urlDesc = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListUrlDesc];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListUrl];
    self.enName = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListEnName];
    self.img = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListImg];
    self.desc = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListDesc];
    self.startAt = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListStartAt];
    self.icon = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListIcon];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListUpdatedAt];
    self.urlIcon = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListUrlIcon];
    self.urlImg = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListUrlImg];
    self.longName = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListLongName];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionListName];
    self.sort = [aDecoder decodeDoubleForKey:kDBHInformationForRoastingChartCollectionListSort];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_listIdentifier forKey:kDBHInformationForRoastingChartCollectionListId];
    [aCoder encodeObject:_endAt forKey:kDBHInformationForRoastingChartCollectionListEndAt];
    [aCoder encodeObject:_style forKey:kDBHInformationForRoastingChartCollectionListStyle];
    [aCoder encodeDouble:_enable forKey:kDBHInformationForRoastingChartCollectionListEnable];
    [aCoder encodeObject:_status forKey:kDBHInformationForRoastingChartCollectionListStatus];
    [aCoder encodeObject:_createdAt forKey:kDBHInformationForRoastingChartCollectionListCreatedAt];
    [aCoder encodeObject:_urlDesc forKey:kDBHInformationForRoastingChartCollectionListUrlDesc];
    [aCoder encodeObject:_url forKey:kDBHInformationForRoastingChartCollectionListUrl];
    [aCoder encodeObject:_enName forKey:kDBHInformationForRoastingChartCollectionListEnName];
    [aCoder encodeObject:_img forKey:kDBHInformationForRoastingChartCollectionListImg];
    [aCoder encodeObject:_desc forKey:kDBHInformationForRoastingChartCollectionListDesc];
    [aCoder encodeObject:_startAt forKey:kDBHInformationForRoastingChartCollectionListStartAt];
    [aCoder encodeObject:_icon forKey:kDBHInformationForRoastingChartCollectionListIcon];
    [aCoder encodeObject:_updatedAt forKey:kDBHInformationForRoastingChartCollectionListUpdatedAt];
    [aCoder encodeObject:_urlIcon forKey:kDBHInformationForRoastingChartCollectionListUrlIcon];
    [aCoder encodeObject:_urlImg forKey:kDBHInformationForRoastingChartCollectionListUrlImg];
    [aCoder encodeObject:_longName forKey:kDBHInformationForRoastingChartCollectionListLongName];
    [aCoder encodeObject:_name forKey:kDBHInformationForRoastingChartCollectionListName];
    [aCoder encodeDouble:_sort forKey:kDBHInformationForRoastingChartCollectionListSort];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForRoastingChartCollectionList *copy = [[DBHInformationForRoastingChartCollectionList alloc] init];
    
    
    
    if (copy) {

        copy.listIdentifier = self.listIdentifier;
        copy.endAt = [self.endAt copyWithZone:zone];
        copy.style = [self.style copyWithZone:zone];
        copy.enable = self.enable;
        copy.status = [self.status copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.urlDesc = [self.urlDesc copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.enName = [self.enName copyWithZone:zone];
        copy.img = [self.img copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.startAt = [self.startAt copyWithZone:zone];
        copy.icon = [self.icon copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.urlIcon = [self.urlIcon copyWithZone:zone];
        copy.urlImg = [self.urlImg copyWithZone:zone];
        copy.longName = [self.longName copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.sort = self.sort;
    }
    
    return copy;
}


@end
