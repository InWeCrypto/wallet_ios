//
//  DBHInformationForProjectCollectionModelData.m
//
//  Created by   on 2017/11/16
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForProjectCollectionModelData.h"


NSString *const kDBHInformationForProjectCollectionModelDataLongName = @"long_name";
NSString *const kDBHInformationForProjectCollectionModelDataColor = @"color";
NSString *const kDBHInformationForProjectCollectionModelDataStyle = @"style";
NSString *const kDBHInformationForProjectCollectionModelDataGridType = @"grid_type";
NSString *const kDBHInformationForProjectCollectionModelDataEnName = @"en_name";
NSString *const kDBHInformationForProjectCollectionModelDataUrl = @"url";
NSString *const kDBHInformationForProjectCollectionModelDataIsCc = @"is_cc";
NSString *const kDBHInformationForProjectCollectionModelDataIsSave = @"is_save";
NSString *const kDBHInformationForProjectCollectionModelDataImg = @"img";
NSString *const kDBHInformationForProjectCollectionModelDataIcon = @"icon";
NSString *const kDBHInformationForProjectCollectionModelDataCallbackFun = @"callback_fun";
NSString *const kDBHInformationForProjectCollectionModelDataSort = @"sort";
NSString *const kDBHInformationForProjectCollectionModelDataScore = @"score";
NSString *const kDBHInformationForProjectCollectionModelDataSeoTitle = @"seo_title";
NSString *const kDBHInformationForProjectCollectionModelDataName = @"name";
NSString *const kDBHInformationForProjectCollectionModelDataSaveUser = @"save_user";
NSString *const kDBHInformationForProjectCollectionModelDataType = @"type";
NSString *const kDBHInformationForProjectCollectionModelDataIsScroll = @"is_scroll";
NSString *const kDBHInformationForProjectCollectionModelDataIsTop = @"is_top";
NSString *const kDBHInformationForProjectCollectionModelDataId = @"id";
NSString *const kDBHInformationForProjectCollectionModelDataSeoKeyworks = @"seo_keyworks";
NSString *const kDBHInformationForProjectCollectionModelDataDesc = @"desc";
NSString *const kDBHInformationForProjectCollectionModelDataSeoDesc = @"seo_desc";
NSString *const kDBHInformationForProjectCollectionModelDataIsHot = @"is_hot";
NSString *const kDBHInformationForProjectCollectionModelDataIsComment = @"is_comment";


@interface DBHInformationForProjectCollectionModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForProjectCollectionModelData

@synthesize longName = _longName;
@synthesize color = _color;
@synthesize style = _style;
@synthesize gridType = _gridType;
@synthesize enName = _enName;
@synthesize url = _url;
@synthesize isCc = _isCc;
@synthesize isSave = _isSave;
@synthesize img = _img;
@synthesize icon = _icon;
@synthesize callbackFun = _callbackFun;
@synthesize sort = _sort;
@synthesize score = _score;
@synthesize seoTitle = _seoTitle;
@synthesize name = _name;
@synthesize saveUser = _saveUser;
@synthesize type = _type;
@synthesize isScroll = _isScroll;
@synthesize isTop = _isTop;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize seoKeyworks = _seoKeyworks;
@synthesize desc = _desc;
@synthesize seoDesc = _seoDesc;
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
            self.longName = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataLongName fromDictionary:dict];
            self.color = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataColor fromDictionary:dict];
            self.style = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataStyle fromDictionary:dict];
            self.gridType = [[self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataGridType fromDictionary:dict] doubleValue];
            self.enName = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataEnName fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataUrl fromDictionary:dict];
            self.isCc = [[self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataIsCc fromDictionary:dict] doubleValue];
            self.isSave = [[self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataIsSave fromDictionary:dict] doubleValue];
            self.img = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataImg fromDictionary:dict];
            self.icon = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataIcon fromDictionary:dict];
            self.callbackFun = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataCallbackFun fromDictionary:dict];
            self.sort = [[self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataSort fromDictionary:dict] doubleValue];
            self.score = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataScore fromDictionary:dict];
            self.seoTitle = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataSeoTitle fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataName fromDictionary:dict];
            self.saveUser = [[self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataSaveUser fromDictionary:dict] doubleValue];
            self.type = [[self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataType fromDictionary:dict] doubleValue];
            self.isScroll = [[self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataIsScroll fromDictionary:dict] doubleValue];
            self.isTop = [[self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataIsTop fromDictionary:dict] doubleValue];
            self.dataIdentifier = [[self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataId fromDictionary:dict] doubleValue];
            self.seoKeyworks = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataSeoKeyworks fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataDesc fromDictionary:dict];
            self.seoDesc = [self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataSeoDesc fromDictionary:dict];
            self.isHot = [[self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataIsHot fromDictionary:dict] doubleValue];
            self.isComment = [[self objectOrNilForKey:kDBHInformationForProjectCollectionModelDataIsComment fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.longName forKey:kDBHInformationForProjectCollectionModelDataLongName];
    [mutableDict setValue:self.color forKey:kDBHInformationForProjectCollectionModelDataColor];
    [mutableDict setValue:self.style forKey:kDBHInformationForProjectCollectionModelDataStyle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.gridType] forKey:kDBHInformationForProjectCollectionModelDataGridType];
    [mutableDict setValue:self.enName forKey:kDBHInformationForProjectCollectionModelDataEnName];
    [mutableDict setValue:self.url forKey:kDBHInformationForProjectCollectionModelDataUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isCc] forKey:kDBHInformationForProjectCollectionModelDataIsCc];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isSave] forKey:kDBHInformationForProjectCollectionModelDataIsSave];
    [mutableDict setValue:self.img forKey:kDBHInformationForProjectCollectionModelDataImg];
    [mutableDict setValue:self.icon forKey:kDBHInformationForProjectCollectionModelDataIcon];
    [mutableDict setValue:self.callbackFun forKey:kDBHInformationForProjectCollectionModelDataCallbackFun];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kDBHInformationForProjectCollectionModelDataSort];
    [mutableDict setValue:self.score forKey:kDBHInformationForProjectCollectionModelDataScore];
    [mutableDict setValue:self.seoTitle forKey:kDBHInformationForProjectCollectionModelDataSeoTitle];
    [mutableDict setValue:self.name forKey:kDBHInformationForProjectCollectionModelDataName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.saveUser] forKey:kDBHInformationForProjectCollectionModelDataSaveUser];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kDBHInformationForProjectCollectionModelDataType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isScroll] forKey:kDBHInformationForProjectCollectionModelDataIsScroll];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isTop] forKey:kDBHInformationForProjectCollectionModelDataIsTop];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHInformationForProjectCollectionModelDataId];
    [mutableDict setValue:self.seoKeyworks forKey:kDBHInformationForProjectCollectionModelDataSeoKeyworks];
    [mutableDict setValue:self.desc forKey:kDBHInformationForProjectCollectionModelDataDesc];
    [mutableDict setValue:self.seoDesc forKey:kDBHInformationForProjectCollectionModelDataSeoDesc];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isHot] forKey:kDBHInformationForProjectCollectionModelDataIsHot];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isComment] forKey:kDBHInformationForProjectCollectionModelDataIsComment];

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

    self.longName = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataLongName];
    self.color = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataColor];
    self.style = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataStyle];
    self.gridType = [aDecoder decodeDoubleForKey:kDBHInformationForProjectCollectionModelDataGridType];
    self.enName = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataEnName];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataUrl];
    self.isCc = [aDecoder decodeDoubleForKey:kDBHInformationForProjectCollectionModelDataIsCc];
    self.isSave = [aDecoder decodeDoubleForKey:kDBHInformationForProjectCollectionModelDataIsSave];
    self.img = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataImg];
    self.icon = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataIcon];
    self.callbackFun = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataCallbackFun];
    self.sort = [aDecoder decodeDoubleForKey:kDBHInformationForProjectCollectionModelDataSort];
    self.score = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataScore];
    self.seoTitle = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataSeoTitle];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataName];
    self.saveUser = [aDecoder decodeDoubleForKey:kDBHInformationForProjectCollectionModelDataSaveUser];
    self.type = [aDecoder decodeDoubleForKey:kDBHInformationForProjectCollectionModelDataType];
    self.isScroll = [aDecoder decodeDoubleForKey:kDBHInformationForProjectCollectionModelDataIsScroll];
    self.isTop = [aDecoder decodeDoubleForKey:kDBHInformationForProjectCollectionModelDataIsTop];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHInformationForProjectCollectionModelDataId];
    self.seoKeyworks = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataSeoKeyworks];
    self.desc = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataDesc];
    self.seoDesc = [aDecoder decodeObjectForKey:kDBHInformationForProjectCollectionModelDataSeoDesc];
    self.isHot = [aDecoder decodeDoubleForKey:kDBHInformationForProjectCollectionModelDataIsHot];
    self.isComment = [aDecoder decodeDoubleForKey:kDBHInformationForProjectCollectionModelDataIsComment];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_longName forKey:kDBHInformationForProjectCollectionModelDataLongName];
    [aCoder encodeObject:_color forKey:kDBHInformationForProjectCollectionModelDataColor];
    [aCoder encodeObject:_style forKey:kDBHInformationForProjectCollectionModelDataStyle];
    [aCoder encodeDouble:_gridType forKey:kDBHInformationForProjectCollectionModelDataGridType];
    [aCoder encodeObject:_enName forKey:kDBHInformationForProjectCollectionModelDataEnName];
    [aCoder encodeObject:_url forKey:kDBHInformationForProjectCollectionModelDataUrl];
    [aCoder encodeDouble:_isCc forKey:kDBHInformationForProjectCollectionModelDataIsCc];
    [aCoder encodeDouble:_isSave forKey:kDBHInformationForProjectCollectionModelDataIsSave];
    [aCoder encodeObject:_img forKey:kDBHInformationForProjectCollectionModelDataImg];
    [aCoder encodeObject:_icon forKey:kDBHInformationForProjectCollectionModelDataIcon];
    [aCoder encodeObject:_callbackFun forKey:kDBHInformationForProjectCollectionModelDataCallbackFun];
    [aCoder encodeDouble:_sort forKey:kDBHInformationForProjectCollectionModelDataSort];
    [aCoder encodeObject:_score forKey:kDBHInformationForProjectCollectionModelDataScore];
    [aCoder encodeObject:_seoTitle forKey:kDBHInformationForProjectCollectionModelDataSeoTitle];
    [aCoder encodeObject:_name forKey:kDBHInformationForProjectCollectionModelDataName];
    [aCoder encodeDouble:_saveUser forKey:kDBHInformationForProjectCollectionModelDataSaveUser];
    [aCoder encodeDouble:_type forKey:kDBHInformationForProjectCollectionModelDataType];
    [aCoder encodeDouble:_isScroll forKey:kDBHInformationForProjectCollectionModelDataIsScroll];
    [aCoder encodeDouble:_isTop forKey:kDBHInformationForProjectCollectionModelDataIsTop];
    [aCoder encodeDouble:_dataIdentifier forKey:kDBHInformationForProjectCollectionModelDataId];
    [aCoder encodeObject:_seoKeyworks forKey:kDBHInformationForProjectCollectionModelDataSeoKeyworks];
    [aCoder encodeObject:_desc forKey:kDBHInformationForProjectCollectionModelDataDesc];
    [aCoder encodeObject:_seoDesc forKey:kDBHInformationForProjectCollectionModelDataSeoDesc];
    [aCoder encodeDouble:_isHot forKey:kDBHInformationForProjectCollectionModelDataIsHot];
    [aCoder encodeDouble:_isComment forKey:kDBHInformationForProjectCollectionModelDataIsComment];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForProjectCollectionModelData *copy = [[DBHInformationForProjectCollectionModelData alloc] init];
    
    
    
    if (copy) {

        copy.longName = [self.longName copyWithZone:zone];
        copy.color = [self.color copyWithZone:zone];
        copy.style = [self.style copyWithZone:zone];
        copy.gridType = self.gridType;
        copy.enName = [self.enName copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.isCc = self.isCc;
        copy.isSave = self.isSave;
        copy.img = [self.img copyWithZone:zone];
        copy.icon = [self.icon copyWithZone:zone];
        copy.callbackFun = [self.callbackFun copyWithZone:zone];
        copy.sort = self.sort;
        copy.score = [self.score copyWithZone:zone];
        copy.seoTitle = [self.seoTitle copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.saveUser = self.saveUser;
        copy.type = self.type;
        copy.isScroll = self.isScroll;
        copy.isTop = self.isTop;
        copy.dataIdentifier = self.dataIdentifier;
        copy.seoKeyworks = [self.seoKeyworks copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.seoDesc = [self.seoDesc copyWithZone:zone];
        copy.isHot = self.isHot;
        copy.isComment = self.isComment;
    }
    
    return copy;
}


@end
