//
//  DBHSearchModelData.m
//
//  Created by   on 2017/11/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHSearchModelData.h"


NSString *const kDBHSearchModelDataIcoId = @"ico_id";
NSString *const kDBHSearchModelDataStyle = @"style";
NSString *const kDBHSearchModelDataStatus = @"status";
NSString *const kDBHSearchModelDataTitle = @"title";
NSString *const kDBHSearchModelDataUrl = @"url";
NSString *const kDBHSearchModelDataUserId = @"user_id";
NSString *const kDBHSearchModelDataPId = @"p_id";
NSString *const kDBHSearchModelDataImg = @"img";
NSString *const kDBHSearchModelDataRiskLevelColor = @"risk_level_color";
NSString *const kDBHSearchModelDataWhitePaperUrl = @"white_paper_url";
NSString *const kDBHSearchModelDataUpdatedAt = @"updated_at";
NSString *const kDBHSearchModelDataIcoScore = @"ico_score";
NSString *const kDBHSearchModelDataSort = @"sort";
NSString *const kDBHSearchModelDataEnable = @"enable";
NSString *const kDBHSearchModelDataSeoTitle = @"seo_title";
NSString *const kDBHSearchModelDataIsScroll = @"is_scroll";
NSString *const kDBHSearchModelDataIsTop = @"is_top";
NSString *const kDBHSearchModelDataId = @"id";
NSString *const kDBHSearchModelDataProjectId = @"project_id";
NSString *const kDBHSearchModelDataWebsite = @"website";
NSString *const kDBHSearchModelDataSubTitle = @"sub_title";
NSString *const kDBHSearchModelDataAssessStatus = @"assess_status";
NSString *const kDBHSearchModelDataSeoKeyworks = @"seo_keyworks";
NSString *const kDBHSearchModelDataRiskLevelName = @"risk_level_name";
NSString *const kDBHSearchModelDataCreatedAt = @"created_at";
NSString *const kDBHSearchModelDataDesc = @"desc";
NSString *const kDBHSearchModelDataSeoDesc = @"seo_desc";
NSString *const kDBHSearchModelDataIsHot = @"is_hot";
NSString *const kDBHSearchModelDataAuthor = @"author";
NSString *const kDBHSearchModelDataContent = @"content";


@interface DBHSearchModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHSearchModelData

@synthesize icoId = _icoId;
@synthesize style = _style;
@synthesize status = _status;
@synthesize title = _title;
@synthesize url = _url;
@synthesize userId = _userId;
@synthesize pId = _pId;
@synthesize img = _img;
@synthesize riskLevelColor = _riskLevelColor;
@synthesize whitePaperUrl = _whitePaperUrl;
@synthesize updatedAt = _updatedAt;
@synthesize icoScore = _icoScore;
@synthesize sort = _sort;
@synthesize enable = _enable;
@synthesize seoTitle = _seoTitle;
@synthesize isScroll = _isScroll;
@synthesize isTop = _isTop;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize projectId = _projectId;
@synthesize website = _website;
@synthesize subTitle = _subTitle;
@synthesize assessStatus = _assessStatus;
@synthesize seoKeyworks = _seoKeyworks;
@synthesize riskLevelName = _riskLevelName;
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
            self.icoId = [self objectOrNilForKey:kDBHSearchModelDataIcoId fromDictionary:dict];
            self.style = [[self objectOrNilForKey:kDBHSearchModelDataStyle fromDictionary:dict] doubleValue];
            self.status = [[self objectOrNilForKey:kDBHSearchModelDataStatus fromDictionary:dict] doubleValue];
            self.title = [self objectOrNilForKey:kDBHSearchModelDataTitle fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHSearchModelDataUrl fromDictionary:dict];
            self.userId = [[self objectOrNilForKey:kDBHSearchModelDataUserId fromDictionary:dict] doubleValue];
            self.pId = [[self objectOrNilForKey:kDBHSearchModelDataPId fromDictionary:dict] doubleValue];
            self.img = [self objectOrNilForKey:kDBHSearchModelDataImg fromDictionary:dict];
            self.riskLevelColor = [self objectOrNilForKey:kDBHSearchModelDataRiskLevelColor fromDictionary:dict];
            self.whitePaperUrl = [self objectOrNilForKey:kDBHSearchModelDataWhitePaperUrl fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kDBHSearchModelDataUpdatedAt fromDictionary:dict];
            self.icoScore = [self objectOrNilForKey:kDBHSearchModelDataIcoScore fromDictionary:dict];
            self.sort = [[self objectOrNilForKey:kDBHSearchModelDataSort fromDictionary:dict] doubleValue];
            self.enable = [[self objectOrNilForKey:kDBHSearchModelDataEnable fromDictionary:dict] doubleValue];
            self.seoTitle = [self objectOrNilForKey:kDBHSearchModelDataSeoTitle fromDictionary:dict];
            self.isScroll = [[self objectOrNilForKey:kDBHSearchModelDataIsScroll fromDictionary:dict] doubleValue];
            self.isTop = [[self objectOrNilForKey:kDBHSearchModelDataIsTop fromDictionary:dict] doubleValue];
            self.dataIdentifier = [[self objectOrNilForKey:kDBHSearchModelDataId fromDictionary:dict] doubleValue];
            self.projectId = [[self objectOrNilForKey:kDBHSearchModelDataProjectId fromDictionary:dict] doubleValue];
            self.website = [self objectOrNilForKey:kDBHSearchModelDataWebsite fromDictionary:dict];
            self.subTitle = [self objectOrNilForKey:kDBHSearchModelDataSubTitle fromDictionary:dict];
            self.assessStatus = [self objectOrNilForKey:kDBHSearchModelDataAssessStatus fromDictionary:dict];
            self.seoKeyworks = [self objectOrNilForKey:kDBHSearchModelDataSeoKeyworks fromDictionary:dict];
            self.riskLevelName = [self objectOrNilForKey:kDBHSearchModelDataRiskLevelName fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kDBHSearchModelDataCreatedAt fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHSearchModelDataDesc fromDictionary:dict];
            self.seoDesc = [self objectOrNilForKey:kDBHSearchModelDataSeoDesc fromDictionary:dict];
            self.isHot = [[self objectOrNilForKey:kDBHSearchModelDataIsHot fromDictionary:dict] doubleValue];
            self.author = [self objectOrNilForKey:kDBHSearchModelDataAuthor fromDictionary:dict];
            self.content = [self objectOrNilForKey:kDBHSearchModelDataContent fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.icoId forKey:kDBHSearchModelDataIcoId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.style] forKey:kDBHSearchModelDataStyle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kDBHSearchModelDataStatus];
    [mutableDict setValue:self.title forKey:kDBHSearchModelDataTitle];
    [mutableDict setValue:self.url forKey:kDBHSearchModelDataUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kDBHSearchModelDataUserId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pId] forKey:kDBHSearchModelDataPId];
    [mutableDict setValue:self.img forKey:kDBHSearchModelDataImg];
    [mutableDict setValue:self.riskLevelColor forKey:kDBHSearchModelDataRiskLevelColor];
    [mutableDict setValue:self.whitePaperUrl forKey:kDBHSearchModelDataWhitePaperUrl];
    [mutableDict setValue:self.updatedAt forKey:kDBHSearchModelDataUpdatedAt];
    [mutableDict setValue:self.icoScore forKey:kDBHSearchModelDataIcoScore];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kDBHSearchModelDataSort];
    [mutableDict setValue:[NSNumber numberWithDouble:self.enable] forKey:kDBHSearchModelDataEnable];
    [mutableDict setValue:self.seoTitle forKey:kDBHSearchModelDataSeoTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isScroll] forKey:kDBHSearchModelDataIsScroll];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isTop] forKey:kDBHSearchModelDataIsTop];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHSearchModelDataId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.projectId] forKey:kDBHSearchModelDataProjectId];
    [mutableDict setValue:self.website forKey:kDBHSearchModelDataWebsite];
    [mutableDict setValue:self.subTitle forKey:kDBHSearchModelDataSubTitle];
    [mutableDict setValue:self.assessStatus forKey:kDBHSearchModelDataAssessStatus];
    [mutableDict setValue:self.seoKeyworks forKey:kDBHSearchModelDataSeoKeyworks];
    [mutableDict setValue:self.riskLevelName forKey:kDBHSearchModelDataRiskLevelName];
    [mutableDict setValue:self.createdAt forKey:kDBHSearchModelDataCreatedAt];
    [mutableDict setValue:self.desc forKey:kDBHSearchModelDataDesc];
    [mutableDict setValue:self.seoDesc forKey:kDBHSearchModelDataSeoDesc];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isHot] forKey:kDBHSearchModelDataIsHot];
    [mutableDict setValue:self.author forKey:kDBHSearchModelDataAuthor];
    [mutableDict setValue:self.content forKey:kDBHSearchModelDataContent];

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

    self.icoId = [aDecoder decodeObjectForKey:kDBHSearchModelDataIcoId];
    self.style = [aDecoder decodeDoubleForKey:kDBHSearchModelDataStyle];
    self.status = [aDecoder decodeDoubleForKey:kDBHSearchModelDataStatus];
    self.title = [aDecoder decodeObjectForKey:kDBHSearchModelDataTitle];
    self.url = [aDecoder decodeObjectForKey:kDBHSearchModelDataUrl];
    self.userId = [aDecoder decodeDoubleForKey:kDBHSearchModelDataUserId];
    self.pId = [aDecoder decodeDoubleForKey:kDBHSearchModelDataPId];
    self.img = [aDecoder decodeObjectForKey:kDBHSearchModelDataImg];
    self.riskLevelColor = [aDecoder decodeObjectForKey:kDBHSearchModelDataRiskLevelColor];
    self.whitePaperUrl = [aDecoder decodeObjectForKey:kDBHSearchModelDataWhitePaperUrl];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHSearchModelDataUpdatedAt];
    self.icoScore = [aDecoder decodeObjectForKey:kDBHSearchModelDataIcoScore];
    self.sort = [aDecoder decodeDoubleForKey:kDBHSearchModelDataSort];
    self.enable = [aDecoder decodeDoubleForKey:kDBHSearchModelDataEnable];
    self.seoTitle = [aDecoder decodeObjectForKey:kDBHSearchModelDataSeoTitle];
    self.isScroll = [aDecoder decodeDoubleForKey:kDBHSearchModelDataIsScroll];
    self.isTop = [aDecoder decodeDoubleForKey:kDBHSearchModelDataIsTop];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHSearchModelDataId];
    self.projectId = [aDecoder decodeDoubleForKey:kDBHSearchModelDataProjectId];
    self.website = [aDecoder decodeObjectForKey:kDBHSearchModelDataWebsite];
    self.subTitle = [aDecoder decodeObjectForKey:kDBHSearchModelDataSubTitle];
    self.assessStatus = [aDecoder decodeObjectForKey:kDBHSearchModelDataAssessStatus];
    self.seoKeyworks = [aDecoder decodeObjectForKey:kDBHSearchModelDataSeoKeyworks];
    self.riskLevelName = [aDecoder decodeObjectForKey:kDBHSearchModelDataRiskLevelName];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHSearchModelDataCreatedAt];
    self.desc = [aDecoder decodeObjectForKey:kDBHSearchModelDataDesc];
    self.seoDesc = [aDecoder decodeObjectForKey:kDBHSearchModelDataSeoDesc];
    self.isHot = [aDecoder decodeDoubleForKey:kDBHSearchModelDataIsHot];
    self.author = [aDecoder decodeObjectForKey:kDBHSearchModelDataAuthor];
    self.content = [aDecoder decodeObjectForKey:kDBHSearchModelDataContent];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_icoId forKey:kDBHSearchModelDataIcoId];
    [aCoder encodeDouble:_style forKey:kDBHSearchModelDataStyle];
    [aCoder encodeDouble:_status forKey:kDBHSearchModelDataStatus];
    [aCoder encodeObject:_title forKey:kDBHSearchModelDataTitle];
    [aCoder encodeObject:_url forKey:kDBHSearchModelDataUrl];
    [aCoder encodeDouble:_userId forKey:kDBHSearchModelDataUserId];
    [aCoder encodeDouble:_pId forKey:kDBHSearchModelDataPId];
    [aCoder encodeObject:_img forKey:kDBHSearchModelDataImg];
    [aCoder encodeObject:_riskLevelColor forKey:kDBHSearchModelDataRiskLevelColor];
    [aCoder encodeObject:_whitePaperUrl forKey:kDBHSearchModelDataWhitePaperUrl];
    [aCoder encodeObject:_updatedAt forKey:kDBHSearchModelDataUpdatedAt];
    [aCoder encodeObject:_icoScore forKey:kDBHSearchModelDataIcoScore];
    [aCoder encodeDouble:_sort forKey:kDBHSearchModelDataSort];
    [aCoder encodeDouble:_enable forKey:kDBHSearchModelDataEnable];
    [aCoder encodeObject:_seoTitle forKey:kDBHSearchModelDataSeoTitle];
    [aCoder encodeDouble:_isScroll forKey:kDBHSearchModelDataIsScroll];
    [aCoder encodeDouble:_isTop forKey:kDBHSearchModelDataIsTop];
    [aCoder encodeDouble:_dataIdentifier forKey:kDBHSearchModelDataId];
    [aCoder encodeDouble:_projectId forKey:kDBHSearchModelDataProjectId];
    [aCoder encodeObject:_website forKey:kDBHSearchModelDataWebsite];
    [aCoder encodeObject:_subTitle forKey:kDBHSearchModelDataSubTitle];
    [aCoder encodeObject:_assessStatus forKey:kDBHSearchModelDataAssessStatus];
    [aCoder encodeObject:_seoKeyworks forKey:kDBHSearchModelDataSeoKeyworks];
    [aCoder encodeObject:_riskLevelName forKey:kDBHSearchModelDataRiskLevelName];
    [aCoder encodeObject:_createdAt forKey:kDBHSearchModelDataCreatedAt];
    [aCoder encodeObject:_desc forKey:kDBHSearchModelDataDesc];
    [aCoder encodeObject:_seoDesc forKey:kDBHSearchModelDataSeoDesc];
    [aCoder encodeDouble:_isHot forKey:kDBHSearchModelDataIsHot];
    [aCoder encodeObject:_author forKey:kDBHSearchModelDataAuthor];
    [aCoder encodeObject:_content forKey:kDBHSearchModelDataContent];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHSearchModelData *copy = [[DBHSearchModelData alloc] init];
    
    
    
    if (copy) {

        copy.icoId = [self.icoId copyWithZone:zone];
        copy.style = self.style;
        copy.status = self.status;
        copy.title = [self.title copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.userId = self.userId;
        copy.pId = self.pId;
        copy.img = [self.img copyWithZone:zone];
        copy.riskLevelColor = [self.riskLevelColor copyWithZone:zone];
        copy.whitePaperUrl = [self.whitePaperUrl copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.icoScore = [self.icoScore copyWithZone:zone];
        copy.sort = self.sort;
        copy.enable = self.enable;
        copy.seoTitle = [self.seoTitle copyWithZone:zone];
        copy.isScroll = self.isScroll;
        copy.isTop = self.isTop;
        copy.dataIdentifier = self.dataIdentifier;
        copy.projectId = self.projectId;
        copy.website = [self.website copyWithZone:zone];
        copy.subTitle = [self.subTitle copyWithZone:zone];
        copy.assessStatus = [self.assessStatus copyWithZone:zone];
        copy.seoKeyworks = [self.seoKeyworks copyWithZone:zone];
        copy.riskLevelName = [self.riskLevelName copyWithZone:zone];
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
