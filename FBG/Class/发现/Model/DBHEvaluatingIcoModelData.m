//
//  DBHEvaluatingIcoModelData.m
//
//  Created by   on 2017/11/16
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHEvaluatingIcoModelData.h"


NSString *const kDBHEvaluatingIcoModelDataStyle = @"style";
NSString *const kDBHEvaluatingIcoModelDataStatus = @"status";
NSString *const kDBHEvaluatingIcoModelDataTitle = @"title";
NSString *const kDBHEvaluatingIcoModelDataUrl = @"url";
NSString *const kDBHEvaluatingIcoModelDataImg = @"img";
NSString *const kDBHEvaluatingIcoModelDataUpdatedAt = @"updated_at";
NSString *const kDBHEvaluatingIcoModelDataSort = @"sort";
NSString *const kDBHEvaluatingIcoModelDataEnable = @"enable";
NSString *const kDBHEvaluatingIcoModelDataSeoTitle = @"seo_title";
NSString *const kDBHEvaluatingIcoModelDataIsScroll = @"is_scroll";
NSString *const kDBHEvaluatingIcoModelDataIsTop = @"is_top";
NSString *const kDBHEvaluatingIcoModelDataId = @"id";
NSString *const kDBHEvaluatingIcoModelDataSubTitle = @"sub_title";
NSString *const kDBHEvaluatingIcoModelDataProjectId = @"project_id";
NSString *const kDBHEvaluatingIcoModelDataWebsite = @"website";
NSString *const kDBHEvaluatingIcoModelDataAssessStatus = @"assess_status";
NSString *const kDBHEvaluatingIcoModelDataSeoKeyworks = @"seo_keyworks";
NSString *const kDBHEvaluatingIcoModelDataCreatedAt = @"created_at";
NSString *const kDBHEvaluatingIcoModelDataDesc = @"desc";
NSString *const kDBHEvaluatingIcoModelDataSeoDesc = @"seo_desc";
NSString *const kDBHEvaluatingIcoModelDataIsHot = @"is_hot";
NSString *const kDBHEvaluatingIcoModelDataAuthor = @"author";
NSString *const kDBHEvaluatingIcoModelDataContent = @"content";


@interface DBHEvaluatingIcoModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHEvaluatingIcoModelData

@synthesize style = _style;
@synthesize status = _status;
@synthesize title = _title;
@synthesize url = _url;
@synthesize img = _img;
@synthesize updatedAt = _updatedAt;
@synthesize sort = _sort;
@synthesize enable = _enable;
@synthesize seoTitle = _seoTitle;
@synthesize isScroll = _isScroll;
@synthesize isTop = _isTop;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize subTitle = _subTitle;
@synthesize projectId = _projectId;
@synthesize website = _website;
@synthesize assessStatus = _assessStatus;
@synthesize seoKeyworks = _seoKeyworks;
@synthesize createdAt = _createdAt;
@synthesize desc = _desc;
@synthesize seoDesc = _seoDesc;
@synthesize isHot = _isHot;
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
            self.style = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataStyle fromDictionary:dict];
            self.status = [[self objectOrNilForKey:kDBHEvaluatingIcoModelDataStatus fromDictionary:dict] doubleValue];
            self.title = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataTitle fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataUrl fromDictionary:dict];
            self.img = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataImg fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataUpdatedAt fromDictionary:dict];
            self.sort = [[self objectOrNilForKey:kDBHEvaluatingIcoModelDataSort fromDictionary:dict] doubleValue];
            self.enable = [[self objectOrNilForKey:kDBHEvaluatingIcoModelDataEnable fromDictionary:dict] doubleValue];
            self.seoTitle = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataSeoTitle fromDictionary:dict];
            self.isScroll = [[self objectOrNilForKey:kDBHEvaluatingIcoModelDataIsScroll fromDictionary:dict] doubleValue];
            self.isTop = [[self objectOrNilForKey:kDBHEvaluatingIcoModelDataIsTop fromDictionary:dict] doubleValue];
            self.dataIdentifier = [[self objectOrNilForKey:kDBHEvaluatingIcoModelDataId fromDictionary:dict] doubleValue];
            self.subTitle = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataSubTitle fromDictionary:dict];
            self.projectId = [[self objectOrNilForKey:kDBHEvaluatingIcoModelDataProjectId fromDictionary:dict] doubleValue];
            self.website = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataWebsite fromDictionary:dict];
            self.assessStatus = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataAssessStatus fromDictionary:dict];
            self.seoKeyworks = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataSeoKeyworks fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataCreatedAt fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataDesc fromDictionary:dict];
            self.seoDesc = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataSeoDesc fromDictionary:dict];
            self.isHot = [[self objectOrNilForKey:kDBHEvaluatingIcoModelDataIsHot fromDictionary:dict] doubleValue];
            self.author = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataAuthor fromDictionary:dict];
            self.content = [self objectOrNilForKey:kDBHEvaluatingIcoModelDataContent fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.style forKey:kDBHEvaluatingIcoModelDataStyle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kDBHEvaluatingIcoModelDataStatus];
    [mutableDict setValue:self.title forKey:kDBHEvaluatingIcoModelDataTitle];
    [mutableDict setValue:self.url forKey:kDBHEvaluatingIcoModelDataUrl];
    [mutableDict setValue:self.img forKey:kDBHEvaluatingIcoModelDataImg];
    [mutableDict setValue:self.updatedAt forKey:kDBHEvaluatingIcoModelDataUpdatedAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kDBHEvaluatingIcoModelDataSort];
    [mutableDict setValue:[NSNumber numberWithDouble:self.enable] forKey:kDBHEvaluatingIcoModelDataEnable];
    [mutableDict setValue:self.seoTitle forKey:kDBHEvaluatingIcoModelDataSeoTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isScroll] forKey:kDBHEvaluatingIcoModelDataIsScroll];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isTop] forKey:kDBHEvaluatingIcoModelDataIsTop];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHEvaluatingIcoModelDataId];
    [mutableDict setValue:self.subTitle forKey:kDBHEvaluatingIcoModelDataSubTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.projectId] forKey:kDBHEvaluatingIcoModelDataProjectId];
    [mutableDict setValue:self.website forKey:kDBHEvaluatingIcoModelDataWebsite];
    [mutableDict setValue:self.assessStatus forKey:kDBHEvaluatingIcoModelDataAssessStatus];
    [mutableDict setValue:self.seoKeyworks forKey:kDBHEvaluatingIcoModelDataSeoKeyworks];
    [mutableDict setValue:self.createdAt forKey:kDBHEvaluatingIcoModelDataCreatedAt];
    [mutableDict setValue:self.desc forKey:kDBHEvaluatingIcoModelDataDesc];
    [mutableDict setValue:self.seoDesc forKey:kDBHEvaluatingIcoModelDataSeoDesc];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isHot] forKey:kDBHEvaluatingIcoModelDataIsHot];
    [mutableDict setValue:self.author forKey:kDBHEvaluatingIcoModelDataAuthor];
    [mutableDict setValue:self.content forKey:kDBHEvaluatingIcoModelDataContent];

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

    self.style = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataStyle];
    self.status = [aDecoder decodeDoubleForKey:kDBHEvaluatingIcoModelDataStatus];
    self.title = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataTitle];
    self.url = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataUrl];
    self.img = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataImg];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataUpdatedAt];
    self.sort = [aDecoder decodeDoubleForKey:kDBHEvaluatingIcoModelDataSort];
    self.enable = [aDecoder decodeDoubleForKey:kDBHEvaluatingIcoModelDataEnable];
    self.seoTitle = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataSeoTitle];
    self.isScroll = [aDecoder decodeDoubleForKey:kDBHEvaluatingIcoModelDataIsScroll];
    self.isTop = [aDecoder decodeDoubleForKey:kDBHEvaluatingIcoModelDataIsTop];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHEvaluatingIcoModelDataId];
    self.subTitle = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataSubTitle];
    self.projectId = [aDecoder decodeDoubleForKey:kDBHEvaluatingIcoModelDataProjectId];
    self.website = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataWebsite];
    self.assessStatus = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataAssessStatus];
    self.seoKeyworks = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataSeoKeyworks];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataCreatedAt];
    self.desc = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataDesc];
    self.seoDesc = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataSeoDesc];
    self.isHot = [aDecoder decodeDoubleForKey:kDBHEvaluatingIcoModelDataIsHot];
    self.author = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataAuthor];
    self.content = [aDecoder decodeObjectForKey:kDBHEvaluatingIcoModelDataContent];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_style forKey:kDBHEvaluatingIcoModelDataStyle];
    [aCoder encodeDouble:_status forKey:kDBHEvaluatingIcoModelDataStatus];
    [aCoder encodeObject:_title forKey:kDBHEvaluatingIcoModelDataTitle];
    [aCoder encodeObject:_url forKey:kDBHEvaluatingIcoModelDataUrl];
    [aCoder encodeObject:_img forKey:kDBHEvaluatingIcoModelDataImg];
    [aCoder encodeObject:_updatedAt forKey:kDBHEvaluatingIcoModelDataUpdatedAt];
    [aCoder encodeDouble:_sort forKey:kDBHEvaluatingIcoModelDataSort];
    [aCoder encodeDouble:_enable forKey:kDBHEvaluatingIcoModelDataEnable];
    [aCoder encodeObject:_seoTitle forKey:kDBHEvaluatingIcoModelDataSeoTitle];
    [aCoder encodeDouble:_isScroll forKey:kDBHEvaluatingIcoModelDataIsScroll];
    [aCoder encodeDouble:_isTop forKey:kDBHEvaluatingIcoModelDataIsTop];
    [aCoder encodeDouble:_dataIdentifier forKey:kDBHEvaluatingIcoModelDataId];
    [aCoder encodeObject:_subTitle forKey:kDBHEvaluatingIcoModelDataSubTitle];
    [aCoder encodeDouble:_projectId forKey:kDBHEvaluatingIcoModelDataProjectId];
    [aCoder encodeObject:_website forKey:kDBHEvaluatingIcoModelDataWebsite];
    [aCoder encodeObject:_assessStatus forKey:kDBHEvaluatingIcoModelDataAssessStatus];
    [aCoder encodeObject:_seoKeyworks forKey:kDBHEvaluatingIcoModelDataSeoKeyworks];
    [aCoder encodeObject:_createdAt forKey:kDBHEvaluatingIcoModelDataCreatedAt];
    [aCoder encodeObject:_desc forKey:kDBHEvaluatingIcoModelDataDesc];
    [aCoder encodeObject:_seoDesc forKey:kDBHEvaluatingIcoModelDataSeoDesc];
    [aCoder encodeDouble:_isHot forKey:kDBHEvaluatingIcoModelDataIsHot];
    [aCoder encodeObject:_author forKey:kDBHEvaluatingIcoModelDataAuthor];
    [aCoder encodeObject:_content forKey:kDBHEvaluatingIcoModelDataContent];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHEvaluatingIcoModelData *copy = [[DBHEvaluatingIcoModelData alloc] init];
    
    
    
    if (copy) {

        copy.style = [self.style copyWithZone:zone];
        copy.status = self.status;
        copy.title = [self.title copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.img = [self.img copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.sort = self.sort;
        copy.enable = self.enable;
        copy.seoTitle = [self.seoTitle copyWithZone:zone];
        copy.isScroll = self.isScroll;
        copy.isTop = self.isTop;
        copy.dataIdentifier = self.dataIdentifier;
        copy.subTitle = [self.subTitle copyWithZone:zone];
        copy.projectId = self.projectId;
        copy.website = [self.website copyWithZone:zone];
        copy.assessStatus = [self.assessStatus copyWithZone:zone];
        copy.seoKeyworks = [self.seoKeyworks copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.seoDesc = [self.seoDesc copyWithZone:zone];
        copy.isHot = self.isHot;
        copy.author = [self.author copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
    }
    
    return copy;
}


@end
