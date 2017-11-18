//
//  DBHInformationDetailModelData.h
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBHInformationDetailModelProjectDetail;

@interface DBHInformationDetailModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *longName;
@property (nonatomic, strong) NSArray *projectWallets;
@property (nonatomic, assign) double style;
@property (nonatomic, assign) double gridType;
@property (nonatomic, strong) NSString *enName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray *projectMedias;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, assign) double isCc;
@property (nonatomic, strong) NSArray *projectDesc;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, assign) id icon;
@property (nonatomic, strong) NSArray *projectExplorers;
@property (nonatomic, strong) DBHInformationDetailModelProjectDetail *projectDetail;
@property (nonatomic, assign) double sort;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, assign) double isSave;
@property (nonatomic, strong) NSString *seoTitle;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double type;
@property (nonatomic, assign) double isScroll;
@property (nonatomic, assign) double isTop;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSArray *projectMarkets;
@property (nonatomic, strong) NSString *seoKeyworks;
@property (nonatomic, strong) NSArray *icoDetail;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSArray *projectTimePrices;
@property (nonatomic, strong) NSString *seoDesc;
@property (nonatomic, assign) double isHot;
@property (nonatomic, assign) double isComment;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
