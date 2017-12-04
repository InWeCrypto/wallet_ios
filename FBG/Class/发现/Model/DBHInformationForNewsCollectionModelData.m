//
//  DBHInformationForNewsCollectionModelData.m
//
//  Created by   on 2017/11/22
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForNewsCollectionModelData.h"


NSString *const kDBHInformationForNewsCollectionModelDataIsHot = @"is_hot";
NSString *const kDBHInformationForNewsCollectionModelDataIsComment = @"is_comment";
NSString *const kDBHInformationForNewsCollectionModelDataStyle = @"style";
NSString *const kDBHInformationForNewsCollectionModelDataStatus = @"status";
NSString *const kDBHInformationForNewsCollectionModelDataClickRate = @"click_rate";
NSString *const kDBHInformationForNewsCollectionModelDataUrl = @"url";
NSString *const kDBHInformationForNewsCollectionModelDataTitle = @"title";
NSString *const kDBHInformationForNewsCollectionModelDataUserId = @"user_id";
NSString *const kDBHInformationForNewsCollectionModelDataImg = @"img";
NSString *const kDBHInformationForNewsCollectionModelDataUpdatedAt = @"updated_at";
NSString *const kDBHInformationForNewsCollectionModelDataSort = @"sort";
NSString *const kDBHInformationForNewsCollectionModelDataVideo = @"video";
NSString *const kDBHInformationForNewsCollectionModelDataEnable = @"enable";
NSString *const kDBHInformationForNewsCollectionModelDataSeoTitle = @"seo_title";
NSString *const kDBHInformationForNewsCollectionModelDataType = @"type";
NSString *const kDBHInformationForNewsCollectionModelDataIsScroll = @"is_scroll";
NSString *const kDBHInformationForNewsCollectionModelDataIsTop = @"is_top";
NSString *const kDBHInformationForNewsCollectionModelDataId = @"id";
NSString *const kDBHInformationForNewsCollectionModelDataSubTitle = @"sub_title";
NSString *const kDBHInformationForNewsCollectionModelDataIsExtendAttr = @"is_extend_attr";
NSString *const kDBHInformationForNewsCollectionModelDataSeoKeyworks = @"seo_keyworks";
NSString *const kDBHInformationForNewsCollectionModelDataCreatedAt = @"created_at";
NSString *const kDBHInformationForNewsCollectionModelDataSeoDesc = @"seo_desc";
NSString *const kDBHInformationForNewsCollectionModelDataDesc = @"desc";
NSString *const kDBHInformationForNewsCollectionModelDataCategoryId = @"category_id";
NSString *const kDBHInformationForNewsCollectionModelDataAuthor = @"author";
NSString *const kDBHInformationForNewsCollectionModelDataContent = @"content";


@interface DBHInformationForNewsCollectionModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForNewsCollectionModelData

@synthesize isHot = _isHot;
@synthesize isComment = _isComment;
@synthesize style = _style;
@synthesize status = _status;
@synthesize clickRate = _clickRate;
@synthesize url = _url;
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
@synthesize categoryId = _categoryId;
@synthesize author = _author;
@synthesize content = _content;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.isHot = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataIsHot fromDictionary:dict] doubleValue];
            self.isComment = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataIsComment fromDictionary:dict] doubleValue];
            self.style = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataStyle fromDictionary:dict] doubleValue];
            self.status = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataStatus fromDictionary:dict] doubleValue];
            self.clickRate = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataClickRate fromDictionary:dict] doubleValue];
            self.url = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataUrl fromDictionary:dict];
            self.title = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataTitle fromDictionary:dict];
            self.userId = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataUserId fromDictionary:dict] doubleValue];
            self.img = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataImg fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataUpdatedAt fromDictionary:dict];
            self.sort = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataSort fromDictionary:dict] doubleValue];
            self.video = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataVideo fromDictionary:dict];
            self.enable = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataEnable fromDictionary:dict] doubleValue];
            self.seoTitle = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataSeoTitle fromDictionary:dict];
            self.type = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataType fromDictionary:dict] doubleValue];
            self.isScroll = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataIsScroll fromDictionary:dict] doubleValue];
            self.isTop = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataIsTop fromDictionary:dict] doubleValue];
            self.dataIdentifier = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataId fromDictionary:dict] doubleValue];
            self.subTitle = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataSubTitle fromDictionary:dict];
            self.isExtendAttr = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataIsExtendAttr fromDictionary:dict] doubleValue];
            self.seoKeyworks = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataSeoKeyworks fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataCreatedAt fromDictionary:dict];
            self.seoDesc = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataSeoDesc fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataDesc fromDictionary:dict];
            self.categoryId = [[self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataCategoryId fromDictionary:dict] doubleValue];
            self.author = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataAuthor fromDictionary:dict];
            self.content = [self objectOrNilForKey:kDBHInformationForNewsCollectionModelDataContent fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isHot] forKey:kDBHInformationForNewsCollectionModelDataIsHot];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isComment] forKey:kDBHInformationForNewsCollectionModelDataIsComment];
    [mutableDict setValue:[NSNumber numberWithDouble:self.style] forKey:kDBHInformationForNewsCollectionModelDataStyle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kDBHInformationForNewsCollectionModelDataStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.clickRate] forKey:kDBHInformationForNewsCollectionModelDataClickRate];
    [mutableDict setValue:self.url forKey:kDBHInformationForNewsCollectionModelDataUrl];
    [mutableDict setValue:self.title forKey:kDBHInformationForNewsCollectionModelDataTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kDBHInformationForNewsCollectionModelDataUserId];
    [mutableDict setValue:self.img forKey:kDBHInformationForNewsCollectionModelDataImg];
    [mutableDict setValue:self.updatedAt forKey:kDBHInformationForNewsCollectionModelDataUpdatedAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kDBHInformationForNewsCollectionModelDataSort];
    [mutableDict setValue:self.video forKey:kDBHInformationForNewsCollectionModelDataVideo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.enable] forKey:kDBHInformationForNewsCollectionModelDataEnable];
    [mutableDict setValue:self.seoTitle forKey:kDBHInformationForNewsCollectionModelDataSeoTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kDBHInformationForNewsCollectionModelDataType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isScroll] forKey:kDBHInformationForNewsCollectionModelDataIsScroll];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isTop] forKey:kDBHInformationForNewsCollectionModelDataIsTop];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHInformationForNewsCollectionModelDataId];
    [mutableDict setValue:self.subTitle forKey:kDBHInformationForNewsCollectionModelDataSubTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isExtendAttr] forKey:kDBHInformationForNewsCollectionModelDataIsExtendAttr];
    [mutableDict setValue:self.seoKeyworks forKey:kDBHInformationForNewsCollectionModelDataSeoKeyworks];
    [mutableDict setValue:self.createdAt forKey:kDBHInformationForNewsCollectionModelDataCreatedAt];
    [mutableDict setValue:self.seoDesc forKey:kDBHInformationForNewsCollectionModelDataSeoDesc];
    [mutableDict setValue:self.desc forKey:kDBHInformationForNewsCollectionModelDataDesc];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHInformationForNewsCollectionModelDataCategoryId];
    [mutableDict setValue:self.author forKey:kDBHInformationForNewsCollectionModelDataAuthor];
    [mutableDict setValue:self.content forKey:kDBHInformationForNewsCollectionModelDataContent];

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

    self.isHot = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataIsHot];
    self.isComment = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataIsComment];
    self.style = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataStyle];
    self.status = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataStatus];
    self.clickRate = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataClickRate];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataUrl];
    self.title = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataTitle];
    self.userId = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataUserId];
    self.img = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataImg];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataUpdatedAt];
    self.sort = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataSort];
    self.video = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataVideo];
    self.enable = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataEnable];
    self.seoTitle = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataSeoTitle];
    self.type = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataType];
    self.isScroll = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataIsScroll];
    self.isTop = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataIsTop];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataId];
    self.subTitle = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataSubTitle];
    self.isExtendAttr = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataIsExtendAttr];
    self.seoKeyworks = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataSeoKeyworks];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataCreatedAt];
    self.seoDesc = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataSeoDesc];
    self.desc = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataDesc];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHInformationForNewsCollectionModelDataCategoryId];
    self.author = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataAuthor];
    self.content = [aDecoder decodeObjectForKey:kDBHInformationForNewsCollectionModelDataContent];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_isHot forKey:kDBHInformationForNewsCollectionModelDataIsHot];
    [aCoder encodeDouble:_isComment forKey:kDBHInformationForNewsCollectionModelDataIsComment];
    [aCoder encodeDouble:_style forKey:kDBHInformationForNewsCollectionModelDataStyle];
    [aCoder encodeDouble:_status forKey:kDBHInformationForNewsCollectionModelDataStatus];
    [aCoder encodeDouble:_clickRate forKey:kDBHInformationForNewsCollectionModelDataClickRate];
    [aCoder encodeObject:_url forKey:kDBHInformationForNewsCollectionModelDataUrl];
    [aCoder encodeObject:_title forKey:kDBHInformationForNewsCollectionModelDataTitle];
    [aCoder encodeDouble:_userId forKey:kDBHInformationForNewsCollectionModelDataUserId];
    [aCoder encodeObject:_img forKey:kDBHInformationForNewsCollectionModelDataImg];
    [aCoder encodeObject:_updatedAt forKey:kDBHInformationForNewsCollectionModelDataUpdatedAt];
    [aCoder encodeDouble:_sort forKey:kDBHInformationForNewsCollectionModelDataSort];
    [aCoder encodeObject:_video forKey:kDBHInformationForNewsCollectionModelDataVideo];
    [aCoder encodeDouble:_enable forKey:kDBHInformationForNewsCollectionModelDataEnable];
    [aCoder encodeObject:_seoTitle forKey:kDBHInformationForNewsCollectionModelDataSeoTitle];
    [aCoder encodeDouble:_type forKey:kDBHInformationForNewsCollectionModelDataType];
    [aCoder encodeDouble:_isScroll forKey:kDBHInformationForNewsCollectionModelDataIsScroll];
    [aCoder encodeDouble:_isTop forKey:kDBHInformationForNewsCollectionModelDataIsTop];
    [aCoder encodeDouble:_dataIdentifier forKey:kDBHInformationForNewsCollectionModelDataId];
    [aCoder encodeObject:_subTitle forKey:kDBHInformationForNewsCollectionModelDataSubTitle];
    [aCoder encodeDouble:_isExtendAttr forKey:kDBHInformationForNewsCollectionModelDataIsExtendAttr];
    [aCoder encodeObject:_seoKeyworks forKey:kDBHInformationForNewsCollectionModelDataSeoKeyworks];
    [aCoder encodeObject:_createdAt forKey:kDBHInformationForNewsCollectionModelDataCreatedAt];
    [aCoder encodeObject:_seoDesc forKey:kDBHInformationForNewsCollectionModelDataSeoDesc];
    [aCoder encodeObject:_desc forKey:kDBHInformationForNewsCollectionModelDataDesc];
    [aCoder encodeDouble:_categoryId forKey:kDBHInformationForNewsCollectionModelDataCategoryId];
    [aCoder encodeObject:_author forKey:kDBHInformationForNewsCollectionModelDataAuthor];
    [aCoder encodeObject:_content forKey:kDBHInformationForNewsCollectionModelDataContent];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForNewsCollectionModelData *copy = [[DBHInformationForNewsCollectionModelData alloc] init];
    
    
    
    if (copy) {

        copy.isHot = self.isHot;
        copy.isComment = self.isComment;
        copy.style = self.style;
        copy.status = self.status;
        copy.clickRate = self.clickRate;
        copy.url = [self.url copyWithZone:zone];
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
        copy.categoryId = self.categoryId;
        copy.author = [self.author copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
    }
    
    return copy;
}


@end
