//
//  DBHInformationForNewsCollectionData.m
//
//  Created by   on 2017/11/15
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForNewsCollectionData.h"


NSString *const kDBHInformationForNewsCollectionDataAuthor = @"author";
NSString *const kDBHInformationForNewsCollectionDataContent = @"content";
NSString *const kDBHInformationForNewsCollectionDataStyle = @"style";
NSString *const kDBHInformationForNewsCollectionDataStatus = @"status";
NSString *const kDBHInformationForNewsCollectionDataClickRate = @"click_rate";
NSString *const kDBHInformationForNewsCollectionDataTitle = @"title";
NSString *const kDBHInformationForNewsCollectionDataUserId = @"user_id";
NSString *const kDBHInformationForNewsCollectionDataImg = @"img";
NSString *const kDBHInformationForNewsCollectionDataUpdatedAt = @"updated_at";
NSString *const kDBHInformationForNewsCollectionDataSort = @"sort";
NSString *const kDBHInformationForNewsCollectionDataVideo = @"video";
NSString *const kDBHInformationForNewsCollectionDataEnable = @"enable";
NSString *const kDBHInformationForNewsCollectionDataSeoTitle = @"seo_title";
NSString *const kDBHInformationForNewsCollectionDataType = @"type";
NSString *const kDBHInformationForNewsCollectionDataIsScroll = @"is_scroll";
NSString *const kDBHInformationForNewsCollectionDataIsTop = @"is_top";
NSString *const kDBHInformationForNewsCollectionDataId = @"id";
NSString *const kDBHInformationForNewsCollectionDataSubTitle = @"sub_title";
NSString *const kDBHInformationForNewsCollectionDataIsExtendAttr = @"is_extend_attr";
NSString *const kDBHInformationForNewsCollectionDataSeoKeyworks = @"seo_keyworks";
NSString *const kDBHInformationForNewsCollectionDataCreatedAt = @"created_at";
NSString *const kDBHInformationForNewsCollectionDataSeoDesc = @"seo_desc";
NSString *const kDBHInformationForNewsCollectionDataDesc = @"desc";
NSString *const kDBHInformationForNewsCollectionDataIsHot = @"is_hot";
NSString *const kDBHInformationForNewsCollectionDataCategoryId = @"category_id";
NSString *const kDBHInformationForNewsCollectionDataIsComment = @"is_comment";


@interface DBHInformationForNewsCollectionData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForNewsCollectionData

@synthesize author = _author;
@synthesize content = _content;
@synthesize style = _style;
@synthesize status = _status;
@synthesize clickRate = _clickRate;
@synthesize title = _title;
@synthesize userId = _userId;
@synthesize img = _img;
@synthesize updatedAt = _updatedAt;
@synthesize sort = _sort;
@synthesize video = _video;
@synthesize enable = _enable;
@synthesize seoTitle = _seoTitle;
@synthesize type = _type;
@synthesize isScroll = _isScroll;
@synthesize isTop = _isTop;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize subTitle = _subTitle;
@synthesize isExtendAttr = _isExtendAttr;
@synthesize seoKeyworks = _seoKeyworks;
@synthesize createdAt = _createdAt;
@synthesize seoDesc = _seoDesc;
@synthesize desc = _desc;
@synthesize isHot = _isHot;
@synthesize categoryId = _categoryId;
@synthesize isComment = _isComment;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.author = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataAuthor fromDictionary:dict];
            self.content = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataContent fromDictionary:dict];
            self.style = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataStyle fromDictionary:dict];
            self.status = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataStatus fromDictionary:dict] doubleValue];
            self.clickRate = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataClickRate fromDictionary:dict] doubleValue];
            self.title = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataTitle fromDictionary:dict];
            self.userId = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataUserId fromDictionary:dict] doubleValue];
            self.img = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataImg fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataUpdatedAt fromDictionary:dict];
            self.sort = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataSort fromDictionary:dict] doubleValue];
            self.video = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataVideo fromDictionary:dict];
            self.enable = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataEnable fromDictionary:dict] doubleValue];
            self.seoTitle = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataSeoTitle fromDictionary:dict];
            self.type = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataType fromDictionary:dict] doubleValue];
            self.isScroll = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataIsScroll fromDictionary:dict] doubleValue];
            self.isTop = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataIsTop fromDictionary:dict] doubleValue];
            self.dataIdentifier = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataId fromDictionary:dict] doubleValue];
            self.subTitle = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataSubTitle fromDictionary:dict];
            self.isExtendAttr = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataIsExtendAttr fromDictionary:dict] doubleValue];
            self.seoKeyworks = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataSeoKeyworks fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataCreatedAt fromDictionary:dict];
            self.seoDesc = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataSeoDesc fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHInformationForNewsCollectionDataDesc fromDictionary:dict];
            self.isHot = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataIsHot fromDictionary:dict] doubleValue];
            self.categoryId = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataCategoryId fromDictionary:dict] doubleValue];
            self.isComment = [[self objectOrNilForKey:kDBHInformationForNewsCollectionDataIsComment fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.author forKey:kDBHInformationForNewsCollectionDataAuthor];
    [mutableDict setValue:self.content forKey:kDBHInformationForNewsCollectionDataContent];
    [mutableDict setValue:self.style forKey:kDBHInformationForNewsCollectionDataStyle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kDBHInformationForNewsCollectionDataStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.clickRate] forKey:kDBHInformationForNewsCollectionDataClickRate];
    [mutableDict setValue:self.title forKey:kDBHInformationForNewsCollectionDataTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kDBHInformationForNewsCollectionDataUserId];
    [mutableDict setValue:self.img forKey:kDBHInformationForNewsCollectionDataImg];
    [mutableDict setValue:self.updatedAt forKey:kDBHInformationForNewsCollectionDataUpdatedAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kDBHInformationForNewsCollectionDataSort];
    [mutableDict setValue:self.video forKey:kDBHInformationForNewsCollectionDataVideo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.enable] forKey:kDBHInformationForNewsCollectionDataEnable];
    [mutableDict setValue:self.seoTitle forKey:kDBHInformationForNewsCollectionDataSeoTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kDBHInformationForNewsCollectionDataType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isScroll] forKey:kDBHInformationForNewsCollectionDataIsScroll];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isTop] forKey:kDBHInformationForNewsCollectionDataIsTop];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHInformationForNewsCollectionDataId];
    [mutableDict setValue:self.subTitle forKey:kDBHInformationForNewsCollectionDataSubTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isExtendAttr] forKey:kDBHInformationForNewsCollectionDataIsExtendAttr];
    [mutableDict setValue:self.seoKeyworks forKey:kDBHInformationForNewsCollectionDataSeoKeyworks];
    [mutableDict setValue:self.createdAt forKey:kDBHInformationForNewsCollectionDataCreatedAt];
    [mutableDict setValue:self.seoDesc forKey:kDBHInformationForNewsCollectionDataSeoDesc];
    [mutableDict setValue:self.desc forKey:kDBHInformationForNewsCollectionDataDesc];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isHot] forKey:kDBHInformationForNewsCollectionDataIsHot];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHInformationForNewsCollectionDataCategoryId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isComment] forKey:kDBHInformationForNewsCollectionDataIsComment];

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

    self.author = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataAuthor];
    self.content = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataContent];
    self.style = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataStyle];
    self.status = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataStatus];
    self.clickRate = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataClickRate];
    self.title = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataTitle];
    self.userId = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataUserId];
    self.img = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataImg];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataUpdatedAt];
    self.sort = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataSort];
    self.video = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataVideo];
    self.enable = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataEnable];
    self.seoTitle = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataSeoTitle];
    self.type = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataType];
    self.isScroll = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataIsScroll];
    self.isTop = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataIsTop];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataId];
    self.subTitle = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataSubTitle];
    self.isExtendAttr = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataIsExtendAttr];
    self.seoKeyworks = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataSeoKeyworks];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataCreatedAt];
    self.seoDesc = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataSeoDesc];
    self.desc = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionDataDesc];
    self.isHot = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataIsHot];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataCategoryId];
    self.isComment = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionDataIsComment];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_author forKey:kDBHInformationForNewsCollectionDataAuthor];
    [aCoder encodeObject:_content forKey:kDBHInformationForNewsCollectionDataContent];
    [aCoder encodeObject:_style forKey:kDBHInformationForNewsCollectionDataStyle];
    [aCoder encodeDouble:_status forKey:kDBHInformationForNewsCollectionDataStatus];
    [aCoder encodeDouble:_clickRate forKey:kDBHInformationForNewsCollectionDataClickRate];
    [aCoder encodeObject:_title forKey:kDBHInformationForNewsCollectionDataTitle];
    [aCoder encodeDouble:_userId forKey:kDBHInformationForNewsCollectionDataUserId];
    [aCoder encodeObject:_img forKey:kDBHInformationForNewsCollectionDataImg];
    [aCoder encodeObject:_updatedAt forKey:kDBHInformationForNewsCollectionDataUpdatedAt];
    [aCoder encodeDouble:_sort forKey:kDBHInformationForNewsCollectionDataSort];
    [aCoder encodeObject:_video forKey:kDBHInformationForNewsCollectionDataVideo];
    [aCoder encodeDouble:_enable forKey:kDBHInformationForNewsCollectionDataEnable];
    [aCoder encodeObject:_seoTitle forKey:kDBHInformationForNewsCollectionDataSeoTitle];
    [aCoder encodeDouble:_type forKey:kDBHInformationForNewsCollectionDataType];
    [aCoder encodeDouble:_isScroll forKey:kDBHInformationForNewsCollectionDataIsScroll];
    [aCoder encodeDouble:_isTop forKey:kDBHInformationForNewsCollectionDataIsTop];
    [aCoder encodeDouble:_dataIdentifier forKey:kDBHInformationForNewsCollectionDataId];
    [aCoder encodeObject:_subTitle forKey:kDBHInformationForNewsCollectionDataSubTitle];
    [aCoder encodeDouble:_isExtendAttr forKey:kDBHInformationForNewsCollectionDataIsExtendAttr];
    [aCoder encodeObject:_seoKeyworks forKey:kDBHInformationForNewsCollectionDataSeoKeyworks];
    [aCoder encodeObject:_createdAt forKey:kDBHInformationForNewsCollectionDataCreatedAt];
    [aCoder encodeObject:_seoDesc forKey:kDBHInformationForNewsCollectionDataSeoDesc];
    [aCoder encodeObject:_desc forKey:kDBHInformationForNewsCollectionDataDesc];
    [aCoder encodeDouble:_isHot forKey:kDBHInformationForNewsCollectionDataIsHot];
    [aCoder encodeDouble:_categoryId forKey:kDBHInformationForNewsCollectionDataCategoryId];
    [aCoder encodeDouble:_isComment forKey:kDBHInformationForNewsCollectionDataIsComment];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForNewsCollectionData *copy = [[DBHInformationForNewsCollectionData alloc] init];
    
    
    
    if (copy) {

        copy.author = [self.author copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
        copy.style = [self.style copyWithZone:zone];
        copy.status = self.status;
        copy.clickRate = self.clickRate;
        copy.title = [self.title copyWithZone:zone];
        copy.userId = self.userId;
        copy.img = [self.img copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.sort = self.sort;
        copy.video = [self.video copyWithZone:zone];
        copy.enable = self.enable;
        copy.seoTitle = [self.seoTitle copyWithZone:zone];
        copy.type = self.type;
        copy.isScroll = self.isScroll;
        copy.isTop = self.isTop;
        copy.dataIdentifier = self.dataIdentifier;
        copy.subTitle = [self.subTitle copyWithZone:zone];
        copy.isExtendAttr = self.isExtendAttr;
        copy.seoKeyworks = [self.seoKeyworks copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.seoDesc = [self.seoDesc copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.isHot = self.isHot;
        copy.categoryId = self.categoryId;
        copy.isComment = self.isComment;
    }
    
    return copy;
}


@end
