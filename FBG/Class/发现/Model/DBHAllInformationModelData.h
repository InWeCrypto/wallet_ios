//
//  DBHAllInformationModelData.h
//
//  Created by   on 2017/11/22
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHAllInformationModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double isHot;
@property (nonatomic, assign) double isComment;
@property (nonatomic, assign) double style;
@property (nonatomic, assign) double status;
@property (nonatomic, assign) double clickRate;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double userId;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, assign) double sort;
@property (nonatomic, assign) double commentsCount;
@property (nonatomic, strong) NSString *video;
@property (nonatomic, assign) double enable;
@property (nonatomic, strong) NSString *seoTitle;
@property (nonatomic, assign) double type;
@property (nonatomic, assign) double isScroll;
@property (nonatomic, assign) double isTop;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, assign) double isExtendAttr;
@property (nonatomic, strong) NSString *seoKeyworks;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *seoDesc;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) double categoryId;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *content;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
