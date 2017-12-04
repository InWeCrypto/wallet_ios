//
//  DBHSearchModelData.h
//
//  Created by   on 2017/11/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHSearchModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *icoId;
@property (nonatomic, assign) double style;
@property (nonatomic, assign) double status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) double userId;
@property (nonatomic, assign) double pId;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *riskLevelColor;
@property (nonatomic, strong) NSString *whitePaperUrl;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *icoScore;
@property (nonatomic, assign) double sort;
@property (nonatomic, assign) double enable;
@property (nonatomic, strong) NSString *seoTitle;
@property (nonatomic, assign) double isScroll;
@property (nonatomic, assign) double isTop;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, assign) double projectId;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, assign) id subTitle;
@property (nonatomic, strong) NSString *assessStatus;
@property (nonatomic, strong) NSString *seoKeyworks;
@property (nonatomic, strong) NSString *riskLevelName;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *seoDesc;
@property (nonatomic, assign) double isHot;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *content;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
