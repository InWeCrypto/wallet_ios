//
//  DBHInformationForRoastingChartCollectionModelList.m
//
//  Created by   on 2017/11/22
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForRoastingChartCollectionModelList.h"


NSString *const kDBHInformationForRoastingChartCollectionModelListId = @"id";
NSString *const kDBHInformationForRoastingChartCollectionModelListEndAt = @"end_at";
NSString *const kDBHInformationForRoastingChartCollectionModelListStyle = @"style";
NSString *const kDBHInformationForRoastingChartCollectionModelListEnable = @"enable";
NSString *const kDBHInformationForRoastingChartCollectionModelListStatus = @"status";
NSString *const kDBHInformationForRoastingChartCollectionModelListCreatedAt = @"created_at";
NSString *const kDBHInformationForRoastingChartCollectionModelListUrlDesc = @"url_desc";
NSString *const kDBHInformationForRoastingChartCollectionModelListUrl = @"url";
NSString *const kDBHInformationForRoastingChartCollectionModelListEnName = @"en_name";
NSString *const kDBHInformationForRoastingChartCollectionModelListImg = @"img";
NSString *const kDBHInformationForRoastingChartCollectionModelListDesc = @"desc";
NSString *const kDBHInformationForRoastingChartCollectionModelListStartAt = @"start_at";
NSString *const kDBHInformationForRoastingChartCollectionModelListIcon = @"icon";
NSString *const kDBHInformationForRoastingChartCollectionModelListUpdatedAt = @"updated_at";
NSString *const kDBHInformationForRoastingChartCollectionModelListUrlIcon = @"url_icon";
NSString *const kDBHInformationForRoastingChartCollectionModelListUrlImg = @"url_img";
NSString *const kDBHInformationForRoastingChartCollectionModelListSort = @"sort";
NSString *const kDBHInformationForRoastingChartCollectionModelListName = @"name";
NSString *const kDBHInformationForRoastingChartCollectionModelListLongName = @"long_name";


@interface DBHInformationForRoastingChartCollectionModelList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForRoastingChartCollectionModelList

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
@synthesize sort = _sort;
@synthesize name = _name;
@synthesize longName = _longName;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.listIdentifier = [[self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListId fromDictionary:dict] doubleValue];
            self.endAt = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListEndAt fromDictionary:dict];
            self.style = [[self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListStyle fromDictionary:dict] doubleValue];
            self.enable = [[self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListEnable fromDictionary:dict] doubleValue];
            self.status = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListStatus fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListCreatedAt fromDictionary:dict];
            self.urlDesc = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListUrlDesc fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListUrl fromDictionary:dict];
            self.enName = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListEnName fromDictionary:dict];
            self.img = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListImg fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListDesc fromDictionary:dict];
            self.startAt = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListStartAt fromDictionary:dict];
            self.icon = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListIcon fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListUpdatedAt fromDictionary:dict];
            self.urlIcon = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListUrlIcon fromDictionary:dict];
            self.urlImg = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListUrlImg fromDictionary:dict];
            self.sort = [[self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListSort fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListName fromDictionary:dict];
            self.longName = [self objectOrNilForKey:kDBHInformationForRoastingChartCollectionModelListLongName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.listIdentifier] forKey:kDBHInformationForRoastingChartCollectionModelListId];
    [mutableDict setValue:self.endAt forKey:kDBHInformationForRoastingChartCollectionModelListEndAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.style] forKey:kDBHInformationForRoastingChartCollectionModelListStyle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.enable] forKey:kDBHInformationForRoastingChartCollectionModelListEnable];
    [mutableDict setValue:self.status forKey:kDBHInformationForRoastingChartCollectionModelListStatus];
    [mutableDict setValue:self.createdAt forKey:kDBHInformationForRoastingChartCollectionModelListCreatedAt];
    [mutableDict setValue:self.urlDesc forKey:kDBHInformationForRoastingChartCollectionModelListUrlDesc];
    [mutableDict setValue:self.url forKey:kDBHInformationForRoastingChartCollectionModelListUrl];
    [mutableDict setValue:self.enName forKey:kDBHInformationForRoastingChartCollectionModelListEnName];
    [mutableDict setValue:self.img forKey:kDBHInformationForRoastingChartCollectionModelListImg];
    [mutableDict setValue:self.desc forKey:kDBHInformationForRoastingChartCollectionModelListDesc];
    [mutableDict setValue:self.startAt forKey:kDBHInformationForRoastingChartCollectionModelListStartAt];
    [mutableDict setValue:self.icon forKey:kDBHInformationForRoastingChartCollectionModelListIcon];
    [mutableDict setValue:self.updatedAt forKey:kDBHInformationForRoastingChartCollectionModelListUpdatedAt];
    [mutableDict setValue:self.urlIcon forKey:kDBHInformationForRoastingChartCollectionModelListUrlIcon];
    [mutableDict setValue:self.urlImg forKey:kDBHInformationForRoastingChartCollectionModelListUrlImg];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kDBHInformationForRoastingChartCollectionModelListSort];
    [mutableDict setValue:self.name forKey:kDBHInformationForRoastingChartCollectionModelListName];
    [mutableDict setValue:self.longName forKey:kDBHInformationForRoastingChartCollectionModelListLongName];

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

    self.listIdentifier = [aDecoder decodeDoubleForKey:kDBHInformationForRoastingChartCollectionModelListId];
    self.endAt = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListEndAt];
    self.style = [aDecoder decodeDoubleForKey:kDBHInformationForRoastingChartCollectionModelListStyle];
    self.enable = [aDecoder decodeDoubleForKey:kDBHInformationForRoastingChartCollectionModelListEnable];
    self.status = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListStatus];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListCreatedAt];
    self.urlDesc = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListUrlDesc];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListUrl];
    self.enName = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListEnName];
    self.img = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListImg];
    self.desc = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListDesc];
    self.startAt = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListStartAt];
    self.icon = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListIcon];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListUpdatedAt];
    self.urlIcon = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListUrlIcon];
    self.urlImg = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListUrlImg];
    self.sort = [aDecoder decodeDoubleForKey:kDBHInformationForRoastingChartCollectionModelListSort];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListName];
    self.longName = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelListLongName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_listIdentifier forKey:kDBHInformationForRoastingChartCollectionModelListId];
    [aCoder encodeObject:_endAt forKey:kDBHInformationForRoastingChartCollectionModelListEndAt];
    [aCoder encodeDouble:_style forKey:kDBHInformationForRoastingChartCollectionModelListStyle];
    [aCoder encodeDouble:_enable forKey:kDBHInformationForRoastingChartCollectionModelListEnable];
    [aCoder encodeObject:_status forKey:kDBHInformationForRoastingChartCollectionModelListStatus];
    [aCoder encodeObject:_createdAt forKey:kDBHInformationForRoastingChartCollectionModelListCreatedAt];
    [aCoder encodeObject:_urlDesc forKey:kDBHInformationForRoastingChartCollectionModelListUrlDesc];
    [aCoder encodeObject:_url forKey:kDBHInformationForRoastingChartCollectionModelListUrl];
    [aCoder encodeObject:_enName forKey:kDBHInformationForRoastingChartCollectionModelListEnName];
    [aCoder encodeObject:_img forKey:kDBHInformationForRoastingChartCollectionModelListImg];
    [aCoder encodeObject:_desc forKey:kDBHInformationForRoastingChartCollectionModelListDesc];
    [aCoder encodeObject:_startAt forKey:kDBHInformationForRoastingChartCollectionModelListStartAt];
    [aCoder encodeObject:_icon forKey:kDBHInformationForRoastingChartCollectionModelListIcon];
    [aCoder encodeObject:_updatedAt forKey:kDBHInformationForRoastingChartCollectionModelListUpdatedAt];
    [aCoder encodeObject:_urlIcon forKey:kDBHInformationForRoastingChartCollectionModelListUrlIcon];
    [aCoder encodeObject:_urlImg forKey:kDBHInformationForRoastingChartCollectionModelListUrlImg];
    [aCoder encodeDouble:_sort forKey:kDBHInformationForRoastingChartCollectionModelListSort];
    [aCoder encodeObject:_name forKey:kDBHInformationForRoastingChartCollectionModelListName];
    [aCoder encodeObject:_longName forKey:kDBHInformationForRoastingChartCollectionModelListLongName];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForRoastingChartCollectionModelList *copy = [[DBHInformationForRoastingChartCollectionModelList alloc] init];
    
    
    
    if (copy) {

        copy.listIdentifier = self.listIdentifier;
        copy.endAt = [self.endAt copyWithZone:zone];
        copy.style = self.style;
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
        copy.sort = self.sort;
        copy.name = [self.name copyWithZone:zone];
        copy.longName = [self.longName copyWithZone:zone];
    }
    
    return copy;
}


@end
