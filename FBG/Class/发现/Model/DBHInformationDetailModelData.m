//
//  DBHInformationDetailModelData.m
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailModelData.h"
#import "DBHInformationDetailModelProjectWallets.h"
#import "DBHInformationDetailModelProjectMedias.h"
#import "DBHInformationDetailModelProjectDesc.h"
#import "DBHInformationDetailModelProjectExplorers.h"
#import "DBHInformationDetailModelProjectDetail.h"
#import "DBHInformationDetailModelProjectMarkets.h"
#import "DBHInformationDetailModelIcoDetail.h"
#import "DBHInformationDetailModelProjectTimePrices.h"


NSString *const kDBHInformationDetailModelDataLongName = @"long_name";
NSString *const kDBHInformationDetailModelDataProjectWallets = @"project_wallets";
NSString *const kDBHInformationDetailModelDataStyle = @"style";
NSString *const kDBHInformationDetailModelDataGridType = @"grid_type";
NSString *const kDBHInformationDetailModelDataEnName = @"en_name";
NSString *const kDBHInformationDetailModelDataUrl = @"url";
NSString *const kDBHInformationDetailModelDataProjectMedias = @"project_medias";
NSString *const kDBHInformationDetailModelDataColor = @"color";
NSString *const kDBHInformationDetailModelDataIsCc = @"is_cc";
NSString *const kDBHInformationDetailModelDataProjectDesc = @"project_desc";
NSString *const kDBHInformationDetailModelDataImg = @"img";
NSString *const kDBHInformationDetailModelDataIcon = @"icon";
NSString *const kDBHInformationDetailModelDataProjectExplorers = @"project_explorers";
NSString *const kDBHInformationDetailModelDataProjectDetail = @"project_detail";
NSString *const kDBHInformationDetailModelDataSort = @"sort";
NSString *const kDBHInformationDetailModelDataScore = @"score";
NSString *const kDBHInformationDetailModelDataIsSave = @"is_save";
NSString *const kDBHInformationDetailModelDataSeoTitle = @"seo_title";
NSString *const kDBHInformationDetailModelDataName = @"name";
NSString *const kDBHInformationDetailModelDataType = @"type";
NSString *const kDBHInformationDetailModelDataIsScroll = @"is_scroll";
NSString *const kDBHInformationDetailModelDataIsTop = @"is_top";
NSString *const kDBHInformationDetailModelDataId = @"id";
NSString *const kDBHInformationDetailModelDataWebsite = @"website";
NSString *const kDBHInformationDetailModelDataProjectMarkets = @"project_markets";
NSString *const kDBHInformationDetailModelDataSeoKeyworks = @"seo_keyworks";
NSString *const kDBHInformationDetailModelDataIcoDetail = @"ico_detail";
NSString *const kDBHInformationDetailModelDataDesc = @"desc";
NSString *const kDBHInformationDetailModelDataProjectTimePrices = @"project_time_prices";
NSString *const kDBHInformationDetailModelDataSeoDesc = @"seo_desc";
NSString *const kDBHInformationDetailModelDataIsHot = @"is_hot";
NSString *const kDBHInformationDetailModelDataIsComment = @"is_comment";


@interface DBHInformationDetailModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailModelData

@synthesize longName = _longName;
@synthesize projectWallets = _projectWallets;
@synthesize style = _style;
@synthesize gridType = _gridType;
@synthesize enName = _enName;
@synthesize url = _url;
@synthesize projectMedias = _projectMedias;
@synthesize color = _color;
@synthesize isCc = _isCc;
@synthesize projectDesc = _projectDesc;
@synthesize img = _img;
@synthesize icon = _icon;
@synthesize projectExplorers = _projectExplorers;
@synthesize projectDetail = _projectDetail;
@synthesize sort = _sort;
@synthesize score = _score;
@synthesize isSave = _isSave;
@synthesize seoTitle = _seoTitle;
@synthesize name = _name;
@synthesize type = _type;
@synthesize isScroll = _isScroll;
@synthesize isTop = _isTop;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize website = _website;
@synthesize projectMarkets = _projectMarkets;
@synthesize seoKeyworks = _seoKeyworks;
@synthesize icoDetail = _icoDetail;
@synthesize desc = _desc;
@synthesize projectTimePrices = _projectTimePrices;
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
            self.longName = [self objectOrNilForKey:kDBHInformationDetailModelDataLongName fromDictionary:dict];
    NSObject *receivedDBHInformationDetailModelProjectWallets = [dict objectForKey:kDBHInformationDetailModelDataProjectWallets];
    NSMutableArray *parsedDBHInformationDetailModelProjectWallets = [NSMutableArray array];
    
    if ([receivedDBHInformationDetailModelProjectWallets isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationDetailModelProjectWallets) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationDetailModelProjectWallets addObject:[DBHInformationDetailModelProjectWallets modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationDetailModelProjectWallets isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationDetailModelProjectWallets addObject:[DBHInformationDetailModelProjectWallets modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationDetailModelProjectWallets]];
    }

    self.projectWallets = [NSArray arrayWithArray:parsedDBHInformationDetailModelProjectWallets];
            self.style = [[self objectOrNilForKey:kDBHInformationDetailModelDataStyle fromDictionary:dict] doubleValue];
            self.gridType = [[self objectOrNilForKey:kDBHInformationDetailModelDataGridType fromDictionary:dict] doubleValue];
            self.enName = [self objectOrNilForKey:kDBHInformationDetailModelDataEnName fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationDetailModelDataUrl fromDictionary:dict];
    NSObject *receivedDBHInformationDetailModelProjectMedias = [dict objectForKey:kDBHInformationDetailModelDataProjectMedias];
    NSMutableArray *parsedDBHInformationDetailModelProjectMedias = [NSMutableArray array];
    
    if ([receivedDBHInformationDetailModelProjectMedias isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationDetailModelProjectMedias) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationDetailModelProjectMedias addObject:[DBHInformationDetailModelProjectMedias modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationDetailModelProjectMedias isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationDetailModelProjectMedias addObject:[DBHInformationDetailModelProjectMedias modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationDetailModelProjectMedias]];
    }

    self.projectMedias = [NSArray arrayWithArray:parsedDBHInformationDetailModelProjectMedias];
            self.color = [self objectOrNilForKey:kDBHInformationDetailModelDataColor fromDictionary:dict];
            self.isCc = [[self objectOrNilForKey:kDBHInformationDetailModelDataIsCc fromDictionary:dict] doubleValue];
    NSObject *receivedDBHInformationDetailModelProjectDesc = [dict objectForKey:kDBHInformationDetailModelDataProjectDesc];
    NSMutableArray *parsedDBHInformationDetailModelProjectDesc = [NSMutableArray array];
    
    if ([receivedDBHInformationDetailModelProjectDesc isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationDetailModelProjectDesc) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationDetailModelProjectDesc addObject:[DBHInformationDetailModelProjectDesc modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationDetailModelProjectDesc isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationDetailModelProjectDesc addObject:[DBHInformationDetailModelProjectDesc modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationDetailModelProjectDesc]];
    }

    self.projectDesc = [NSArray arrayWithArray:parsedDBHInformationDetailModelProjectDesc];
            self.img = [self objectOrNilForKey:kDBHInformationDetailModelDataImg fromDictionary:dict];
            self.icon = [self objectOrNilForKey:kDBHInformationDetailModelDataIcon fromDictionary:dict];
    NSObject *receivedDBHInformationDetailModelProjectExplorers = [dict objectForKey:kDBHInformationDetailModelDataProjectExplorers];
    NSMutableArray *parsedDBHInformationDetailModelProjectExplorers = [NSMutableArray array];
    
    if ([receivedDBHInformationDetailModelProjectExplorers isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationDetailModelProjectExplorers) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationDetailModelProjectExplorers addObject:[DBHInformationDetailModelProjectExplorers modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationDetailModelProjectExplorers isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationDetailModelProjectExplorers addObject:[DBHInformationDetailModelProjectExplorers modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationDetailModelProjectExplorers]];
    }

    self.projectExplorers = [NSArray arrayWithArray:parsedDBHInformationDetailModelProjectExplorers];
            self.projectDetail = [DBHInformationDetailModelProjectDetail modelObjectWithDictionary:[dict objectForKey:kDBHInformationDetailModelDataProjectDetail]];
            self.sort = [[self objectOrNilForKey:kDBHInformationDetailModelDataSort fromDictionary:dict] doubleValue];
            self.score = [self objectOrNilForKey:kDBHInformationDetailModelDataScore fromDictionary:dict];
            self.isSave = [[self objectOrNilForKey:kDBHInformationDetailModelDataIsSave fromDictionary:dict] doubleValue];
            self.seoTitle = [self objectOrNilForKey:kDBHInformationDetailModelDataSeoTitle fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationDetailModelDataName fromDictionary:dict];
            self.type = [[self objectOrNilForKey:kDBHInformationDetailModelDataType fromDictionary:dict] doubleValue];
            self.isScroll = [[self objectOrNilForKey:kDBHInformationDetailModelDataIsScroll fromDictionary:dict] doubleValue];
            self.isTop = [[self objectOrNilForKey:kDBHInformationDetailModelDataIsTop fromDictionary:dict] doubleValue];
            self.dataIdentifier = [[self objectOrNilForKey:kDBHInformationDetailModelDataId fromDictionary:dict] doubleValue];
            self.website = [self objectOrNilForKey:kDBHInformationDetailModelDataWebsite fromDictionary:dict];
    NSObject *receivedDBHInformationDetailModelProjectMarkets = [dict objectForKey:kDBHInformationDetailModelDataProjectMarkets];
    NSMutableArray *parsedDBHInformationDetailModelProjectMarkets = [NSMutableArray array];
    
    if ([receivedDBHInformationDetailModelProjectMarkets isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationDetailModelProjectMarkets) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationDetailModelProjectMarkets addObject:[DBHInformationDetailModelProjectMarkets modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationDetailModelProjectMarkets isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationDetailModelProjectMarkets addObject:[DBHInformationDetailModelProjectMarkets modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationDetailModelProjectMarkets]];
    }

    self.projectMarkets = [NSArray arrayWithArray:parsedDBHInformationDetailModelProjectMarkets];
            self.seoKeyworks = [self objectOrNilForKey:kDBHInformationDetailModelDataSeoKeyworks fromDictionary:dict];
    NSObject *receivedDBHInformationDetailModelIcoDetail = [dict objectForKey:kDBHInformationDetailModelDataIcoDetail];
    NSMutableArray *parsedDBHInformationDetailModelIcoDetail = [NSMutableArray array];
    
    if ([receivedDBHInformationDetailModelIcoDetail isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationDetailModelIcoDetail) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationDetailModelIcoDetail addObject:[DBHInformationDetailModelIcoDetail modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationDetailModelIcoDetail isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationDetailModelIcoDetail addObject:[DBHInformationDetailModelIcoDetail modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationDetailModelIcoDetail]];
    }

    self.icoDetail = [NSArray arrayWithArray:parsedDBHInformationDetailModelIcoDetail];
            self.desc = [self objectOrNilForKey:kDBHInformationDetailModelDataDesc fromDictionary:dict];
    NSObject *receivedDBHInformationDetailModelProjectTimePrices = [dict objectForKey:kDBHInformationDetailModelDataProjectTimePrices];
    NSMutableArray *parsedDBHInformationDetailModelProjectTimePrices = [NSMutableArray array];
    
    if ([receivedDBHInformationDetailModelProjectTimePrices isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationDetailModelProjectTimePrices) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationDetailModelProjectTimePrices addObject:[DBHInformationDetailModelProjectTimePrices modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationDetailModelProjectTimePrices isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationDetailModelProjectTimePrices addObject:[DBHInformationDetailModelProjectTimePrices modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationDetailModelProjectTimePrices]];
    }

    self.projectTimePrices = [NSArray arrayWithArray:parsedDBHInformationDetailModelProjectTimePrices];
            self.seoDesc = [self objectOrNilForKey:kDBHInformationDetailModelDataSeoDesc fromDictionary:dict];
            self.isHot = [[self objectOrNilForKey:kDBHInformationDetailModelDataIsHot fromDictionary:dict] doubleValue];
            self.isComment = [[self objectOrNilForKey:kDBHInformationDetailModelDataIsComment fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.longName forKey:kDBHInformationDetailModelDataLongName];
    NSMutableArray *tempArrayForProjectWallets = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.projectWallets) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForProjectWallets addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForProjectWallets addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForProjectWallets] forKey:kDBHInformationDetailModelDataProjectWallets];
    [mutableDict setValue:[NSNumber numberWithDouble:self.style] forKey:kDBHInformationDetailModelDataStyle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.gridType] forKey:kDBHInformationDetailModelDataGridType];
    [mutableDict setValue:self.enName forKey:kDBHInformationDetailModelDataEnName];
    [mutableDict setValue:self.url forKey:kDBHInformationDetailModelDataUrl];
    NSMutableArray *tempArrayForProjectMedias = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.projectMedias) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForProjectMedias addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForProjectMedias addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForProjectMedias] forKey:kDBHInformationDetailModelDataProjectMedias];
    [mutableDict setValue:self.color forKey:kDBHInformationDetailModelDataColor];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isCc] forKey:kDBHInformationDetailModelDataIsCc];
    NSMutableArray *tempArrayForProjectDesc = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.projectDesc) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForProjectDesc addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForProjectDesc addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForProjectDesc] forKey:kDBHInformationDetailModelDataProjectDesc];
    [mutableDict setValue:self.img forKey:kDBHInformationDetailModelDataImg];
    [mutableDict setValue:self.icon forKey:kDBHInformationDetailModelDataIcon];
    NSMutableArray *tempArrayForProjectExplorers = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.projectExplorers) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForProjectExplorers addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForProjectExplorers addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForProjectExplorers] forKey:kDBHInformationDetailModelDataProjectExplorers];
    [mutableDict setValue:[self.projectDetail dictionaryRepresentation] forKey:kDBHInformationDetailModelDataProjectDetail];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kDBHInformationDetailModelDataSort];
    [mutableDict setValue:self.score forKey:kDBHInformationDetailModelDataScore];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isSave] forKey:kDBHInformationDetailModelDataIsSave];
    [mutableDict setValue:self.seoTitle forKey:kDBHInformationDetailModelDataSeoTitle];
    [mutableDict setValue:self.name forKey:kDBHInformationDetailModelDataName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kDBHInformationDetailModelDataType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isScroll] forKey:kDBHInformationDetailModelDataIsScroll];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isTop] forKey:kDBHInformationDetailModelDataIsTop];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHInformationDetailModelDataId];
    [mutableDict setValue:self.website forKey:kDBHInformationDetailModelDataWebsite];
    NSMutableArray *tempArrayForProjectMarkets = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.projectMarkets) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForProjectMarkets addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForProjectMarkets addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForProjectMarkets] forKey:kDBHInformationDetailModelDataProjectMarkets];
    [mutableDict setValue:self.seoKeyworks forKey:kDBHInformationDetailModelDataSeoKeyworks];
    NSMutableArray *tempArrayForIcoDetail = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.icoDetail) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForIcoDetail addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForIcoDetail addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForIcoDetail] forKey:kDBHInformationDetailModelDataIcoDetail];
    [mutableDict setValue:self.desc forKey:kDBHInformationDetailModelDataDesc];
    NSMutableArray *tempArrayForProjectTimePrices = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.projectTimePrices) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForProjectTimePrices addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForProjectTimePrices addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForProjectTimePrices] forKey:kDBHInformationDetailModelDataProjectTimePrices];
    [mutableDict setValue:self.seoDesc forKey:kDBHInformationDetailModelDataSeoDesc];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isHot] forKey:kDBHInformationDetailModelDataIsHot];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isComment] forKey:kDBHInformationDetailModelDataIsComment];

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

    self.longName = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataLongName];
    self.projectWallets = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataProjectWallets];
    self.style = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelDataStyle];
    self.gridType = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelDataGridType];
    self.enName = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataEnName];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataUrl];
    self.projectMedias = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataProjectMedias];
    self.color = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataColor];
    self.isCc = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelDataIsCc];
    self.projectDesc = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataProjectDesc];
    self.img = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataImg];
    self.icon = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataIcon];
    self.projectExplorers = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataProjectExplorers];
    self.projectDetail = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataProjectDetail];
    self.sort = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelDataSort];
    self.score = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataScore];
    self.isSave = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelDataIsSave];
    self.seoTitle = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataSeoTitle];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataName];
    self.type = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelDataType];
    self.isScroll = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelDataIsScroll];
    self.isTop = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelDataIsTop];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelDataId];
    self.website = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataWebsite];
    self.projectMarkets = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataProjectMarkets];
    self.seoKeyworks = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataSeoKeyworks];
    self.icoDetail = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataIcoDetail];
    self.desc = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataDesc];
    self.projectTimePrices = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataProjectTimePrices];
    self.seoDesc = [aDecoder decodeObjectForKey:kDBHInformationDetailModelDataSeoDesc];
    self.isHot = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelDataIsHot];
    self.isComment = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelDataIsComment];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_longName forKey:kDBHInformationDetailModelDataLongName];
    [aCoder encodeObject:_projectWallets forKey:kDBHInformationDetailModelDataProjectWallets];
    [aCoder encodeDouble:_style forKey:kDBHInformationDetailModelDataStyle];
    [aCoder encodeDouble:_gridType forKey:kDBHInformationDetailModelDataGridType];
    [aCoder encodeObject:_enName forKey:kDBHInformationDetailModelDataEnName];
    [aCoder encodeObject:_url forKey:kDBHInformationDetailModelDataUrl];
    [aCoder encodeObject:_projectMedias forKey:kDBHInformationDetailModelDataProjectMedias];
    [aCoder encodeObject:_color forKey:kDBHInformationDetailModelDataColor];
    [aCoder encodeDouble:_isCc forKey:kDBHInformationDetailModelDataIsCc];
    [aCoder encodeObject:_projectDesc forKey:kDBHInformationDetailModelDataProjectDesc];
    [aCoder encodeObject:_img forKey:kDBHInformationDetailModelDataImg];
    [aCoder encodeObject:_icon forKey:kDBHInformationDetailModelDataIcon];
    [aCoder encodeObject:_projectExplorers forKey:kDBHInformationDetailModelDataProjectExplorers];
    [aCoder encodeObject:_projectDetail forKey:kDBHInformationDetailModelDataProjectDetail];
    [aCoder encodeDouble:_sort forKey:kDBHInformationDetailModelDataSort];
    [aCoder encodeObject:_score forKey:kDBHInformationDetailModelDataScore];
    [aCoder encodeDouble:_isSave forKey:kDBHInformationDetailModelDataIsSave];
    [aCoder encodeObject:_seoTitle forKey:kDBHInformationDetailModelDataSeoTitle];
    [aCoder encodeObject:_name forKey:kDBHInformationDetailModelDataName];
    [aCoder encodeDouble:_type forKey:kDBHInformationDetailModelDataType];
    [aCoder encodeDouble:_isScroll forKey:kDBHInformationDetailModelDataIsScroll];
    [aCoder encodeDouble:_isTop forKey:kDBHInformationDetailModelDataIsTop];
    [aCoder encodeDouble:_dataIdentifier forKey:kDBHInformationDetailModelDataId];
    [aCoder encodeObject:_website forKey:kDBHInformationDetailModelDataWebsite];
    [aCoder encodeObject:_projectMarkets forKey:kDBHInformationDetailModelDataProjectMarkets];
    [aCoder encodeObject:_seoKeyworks forKey:kDBHInformationDetailModelDataSeoKeyworks];
    [aCoder encodeObject:_icoDetail forKey:kDBHInformationDetailModelDataIcoDetail];
    [aCoder encodeObject:_desc forKey:kDBHInformationDetailModelDataDesc];
    [aCoder encodeObject:_projectTimePrices forKey:kDBHInformationDetailModelDataProjectTimePrices];
    [aCoder encodeObject:_seoDesc forKey:kDBHInformationDetailModelDataSeoDesc];
    [aCoder encodeDouble:_isHot forKey:kDBHInformationDetailModelDataIsHot];
    [aCoder encodeDouble:_isComment forKey:kDBHInformationDetailModelDataIsComment];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailModelData *copy = [[DBHInformationDetailModelData alloc] init];
    
    
    
    if (copy) {

        copy.longName = [self.longName copyWithZone:zone];
        copy.projectWallets = [self.projectWallets copyWithZone:zone];
        copy.style = self.style;
        copy.gridType = self.gridType;
        copy.enName = [self.enName copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.projectMedias = [self.projectMedias copyWithZone:zone];
        copy.color = [self.color copyWithZone:zone];
        copy.isCc = self.isCc;
        copy.projectDesc = [self.projectDesc copyWithZone:zone];
        copy.img = [self.img copyWithZone:zone];
        copy.icon = [self.icon copyWithZone:zone];
        copy.projectExplorers = [self.projectExplorers copyWithZone:zone];
        copy.projectDetail = [self.projectDetail copyWithZone:zone];
        copy.sort = self.sort;
        copy.score = [self.score copyWithZone:zone];
        copy.isSave = self.isSave;
        copy.seoTitle = [self.seoTitle copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.type = self.type;
        copy.isScroll = self.isScroll;
        copy.isTop = self.isTop;
        copy.dataIdentifier = self.dataIdentifier;
        copy.website = [self.website copyWithZone:zone];
        copy.projectMarkets = [self.projectMarkets copyWithZone:zone];
        copy.seoKeyworks = [self.seoKeyworks copyWithZone:zone];
        copy.icoDetail = [self.icoDetail copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.projectTimePrices = [self.projectTimePrices copyWithZone:zone];
        copy.seoDesc = [self.seoDesc copyWithZone:zone];
        copy.isHot = self.isHot;
        copy.isComment = self.isComment;
    }
    
    return copy;
}


@end
