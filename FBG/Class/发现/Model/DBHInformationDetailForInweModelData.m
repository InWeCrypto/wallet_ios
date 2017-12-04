//
//  DBHInformationDetailForInweModelData.m
//
//  Created by   on 2017/11/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailForInweModelData.h"


NSString *const kDBHInformationDetailForInweModelDataAuthor = @"author";
NSString *const kDBHInformationDetailForInweModelDataContent = @"content";
NSString *const kDBHInformationDetailForInweModelDataStyle = @"style";
NSString *const kDBHInformationDetailForInweModelDataStatus = @"status";
NSString *const kDBHInformationDetailForInweModelDataClickRate = @"click_rate";
NSString *const kDBHInformationDetailForInweModelDataTitle = @"title";
NSString *const kDBHInformationDetailForInweModelDataUserId = @"user_id";
NSString *const kDBHInformationDetailForInweModelDataImg = @"img";
NSString *const kDBHInformationDetailForInweModelDataUpdatedAt = @"updated_at";
NSString *const kDBHInformationDetailForInweModelDataSort = @"sort";
NSString *const kDBHInformationDetailForInweModelDataEnable = @"enable";
NSString *const kDBHInformationDetailForInweModelDataVideo = @"video";
NSString *const kDBHInformationDetailForInweModelDataSeoTitle = @"seo_title";
NSString *const kDBHInformationDetailForInweModelDataType = @"type";
NSString *const kDBHInformationDetailForInweModelDataIsScroll = @"is_scroll";
NSString *const kDBHInformationDetailForInweModelDataIsTop = @"is_top";
NSString *const kDBHInformationDetailForInweModelDataId = @"id";
NSString *const kDBHInformationDetailForInweModelDataSubTitle = @"sub_title";
NSString *const kDBHInformationDetailForInweModelDataIsExtendAttr = @"is_extend_attr";
NSString *const kDBHInformationDetailForInweModelDataSeoKeyworks = @"seo_keyworks";
NSString *const kDBHInformationDetailForInweModelDataCreatedAt = @"created_at";
NSString *const kDBHInformationDetailForInweModelDataSeoDesc = @"seo_desc";
NSString *const kDBHInformationDetailForInweModelDataDesc = @"desc";
NSString *const kDBHInformationDetailForInweModelDataCategoryId = @"category_id";
NSString *const kDBHInformationDetailForInweModelDataIsHot = @"is_hot";
NSString *const kDBHInformationDetailForInweModelDataIsComment = @"is_comment";


@interface DBHInformationDetailForInweModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailForInweModelData

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
@synthesize enable = _enable;
@synthesize video = _video;
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
@synthesize isHot = _isHot;
@synthesize isComment = _isComment;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.author = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataAuthor fromDictionary:dict];
            self.content = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataContent fromDictionary:dict];
            self.style = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataStyle fromDictionary:dict];
            self.status = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataStatus fromDictionary:dict] doubleValue];
            self.clickRate = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataClickRate fromDictionary:dict] doubleValue];
            self.title = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataTitle fromDictionary:dict];
            self.userId = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataUserId fromDictionary:dict] doubleValue];
            self.img = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataImg fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataUpdatedAt fromDictionary:dict];
            self.sort = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataSort fromDictionary:dict] doubleValue];
            self.enable = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataEnable fromDictionary:dict] doubleValue];
            self.video = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataVideo fromDictionary:dict];
            self.seoTitle = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataSeoTitle fromDictionary:dict];
            self.type = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataType fromDictionary:dict] doubleValue];
            self.isScroll = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataIsScroll fromDictionary:dict] doubleValue];
            self.isTop = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataIsTop fromDictionary:dict] doubleValue];
            self.dataIdentifier = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataId fromDictionary:dict] doubleValue];
            self.subTitle = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataSubTitle fromDictionary:dict];
            self.isExtendAttr = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataIsExtendAttr fromDictionary:dict] doubleValue];
            self.seoKeyworks = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataSeoKeyworks fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataCreatedAt fromDictionary:dict];
            self.seoDesc = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataSeoDesc fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHInformationDetailForInweModelDataDesc fromDictionary:dict];
            self.categoryId = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataCategoryId fromDictionary:dict] doubleValue];
            self.isHot = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataIsHot fromDictionary:dict] doubleValue];
            self.isComment = [[self objectOrNilForKey:kDBHInformationDetailForInweModelDataIsComment fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.author forKey:kDBHInformationDetailForInweModelDataAuthor];
    [mutableDict setValue:self.content forKey:kDBHInformationDetailForInweModelDataContent];
    [mutableDict setValue:self.style forKey:kDBHInformationDetailForInweModelDataStyle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kDBHInformationDetailForInweModelDataStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.clickRate] forKey:kDBHInformationDetailForInweModelDataClickRate];
    [mutableDict setValue:self.title forKey:kDBHInformationDetailForInweModelDataTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kDBHInformationDetailForInweModelDataUserId];
    [mutableDict setValue:self.img forKey:kDBHInformationDetailForInweModelDataImg];
    [mutableDict setValue:self.updatedAt forKey:kDBHInformationDetailForInweModelDataUpdatedAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kDBHInformationDetailForInweModelDataSort];
    [mutableDict setValue:[NSNumber numberWithDouble:self.enable] forKey:kDBHInformationDetailForInweModelDataEnable];
    [mutableDict setValue:self.video forKey:kDBHInformationDetailForInweModelDataVideo];
    [mutableDict setValue:self.seoTitle forKey:kDBHInformationDetailForInweModelDataSeoTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kDBHInformationDetailForInweModelDataType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isScroll] forKey:kDBHInformationDetailForInweModelDataIsScroll];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isTop] forKey:kDBHInformationDetailForInweModelDataIsTop];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHInformationDetailForInweModelDataId];
    [mutableDict setValue:self.subTitle forKey:kDBHInformationDetailForInweModelDataSubTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isExtendAttr] forKey:kDBHInformationDetailForInweModelDataIsExtendAttr];
    [mutableDict setValue:self.seoKeyworks forKey:kDBHInformationDetailForInweModelDataSeoKeyworks];
    [mutableDict setValue:self.createdAt forKey:kDBHInformationDetailForInweModelDataCreatedAt];
    [mutableDict setValue:self.seoDesc forKey:kDBHInformationDetailForInweModelDataSeoDesc];
    [mutableDict setValue:self.desc forKey:kDBHInformationDetailForInweModelDataDesc];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHInformationDetailForInweModelDataCategoryId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isHot] forKey:kDBHInformationDetailForInweModelDataIsHot];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isComment] forKey:kDBHInformationDetailForInweModelDataIsComment];

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

    self.author = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataAuthor];
    self.content = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataContent];
    self.style = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataStyle];
    self.status = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataStatus];
    self.clickRate = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataClickRate];
    self.title = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataTitle];
    self.userId = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataUserId];
    self.img = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataImg];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataUpdatedAt];
    self.sort = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataSort];
    self.enable = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataEnable];
    self.video = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataVideo];
    self.seoTitle = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataSeoTitle];
    self.type = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataType];
    self.isScroll = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataIsScroll];
    self.isTop = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataIsTop];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataId];
    self.subTitle = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataSubTitle];
    self.isExtendAttr = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataIsExtendAttr];
    self.seoKeyworks = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataSeoKeyworks];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataCreatedAt];
    self.seoDesc = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataSeoDesc];
    self.desc = [aDecoder decodeObjectForKey:kDBHInformationDetailForInweModelDataDesc];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataCategoryId];
    self.isHot = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataIsHot];
    self.isComment = [aDecoder decodeDoubleForKey:kDBHInformationDetailForInweModelDataIsComment];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_author forKey:kDBHInformationDetailForInweModelDataAuthor];
    [aCoder encodeObject:_content forKey:kDBHInformationDetailForInweModelDataContent];
    [aCoder encodeObject:_style forKey:kDBHInformationDetailForInweModelDataStyle];
    [aCoder encodeDouble:_status forKey:kDBHInformationDetailForInweModelDataStatus];
    [aCoder encodeDouble:_clickRate forKey:kDBHInformationDetailForInweModelDataClickRate];
    [aCoder encodeObject:_title forKey:kDBHInformationDetailForInweModelDataTitle];
    [aCoder encodeDouble:_userId forKey:kDBHInformationDetailForInweModelDataUserId];
    [aCoder encodeObject:_img forKey:kDBHInformationDetailForInweModelDataImg];
    [aCoder encodeObject:_updatedAt forKey:kDBHInformationDetailForInweModelDataUpdatedAt];
    [aCoder encodeDouble:_sort forKey:kDBHInformationDetailForInweModelDataSort];
    [aCoder encodeDouble:_enable forKey:kDBHInformationDetailForInweModelDataEnable];
    [aCoder encodeObject:_video forKey:kDBHInformationDetailForInweModelDataVideo];
    [aCoder encodeObject:_seoTitle forKey:kDBHInformationDetailForInweModelDataSeoTitle];
    [aCoder encodeDouble:_type forKey:kDBHInformationDetailForInweModelDataType];
    [aCoder encodeDouble:_isScroll forKey:kDBHInformationDetailForInweModelDataIsScroll];
    [aCoder encodeDouble:_isTop forKey:kDBHInformationDetailForInweModelDataIsTop];
    [aCoder encodeDouble:_dataIdentifier forKey:kDBHInformationDetailForInweModelDataId];
    [aCoder encodeObject:_subTitle forKey:kDBHInformationDetailForInweModelDataSubTitle];
    [aCoder encodeDouble:_isExtendAttr forKey:kDBHInformationDetailForInweModelDataIsExtendAttr];
    [aCoder encodeObject:_seoKeyworks forKey:kDBHInformationDetailForInweModelDataSeoKeyworks];
    [aCoder encodeObject:_createdAt forKey:kDBHInformationDetailForInweModelDataCreatedAt];
    [aCoder encodeObject:_seoDesc forKey:kDBHInformationDetailForInweModelDataSeoDesc];
    [aCoder encodeObject:_desc forKey:kDBHInformationDetailForInweModelDataDesc];
    [aCoder encodeDouble:_categoryId forKey:kDBHInformationDetailForInweModelDataCategoryId];
    [aCoder encodeDouble:_isHot forKey:kDBHInformationDetailForInweModelDataIsHot];
    [aCoder encodeDouble:_isComment forKey:kDBHInformationDetailForInweModelDataIsComment];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailForInweModelData *copy = [[DBHInformationDetailForInweModelData alloc] init];
    
    
    
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
        copy.enable = self.enable;
        copy.video = [self.video copyWithZone:zone];
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
        copy.isHot = self.isHot;
        copy.isComment = self.isComment;
    }
    
    return copy;
}


@end
