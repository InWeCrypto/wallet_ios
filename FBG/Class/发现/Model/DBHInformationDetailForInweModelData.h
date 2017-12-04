//
//  DBHInformationDetailForInweModelData.h
//
//  Created by   on 2017/11/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationDetailForInweModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) id author;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) id style;
@property (nonatomic, assign) double status;
@property (nonatomic, assign) double clickRate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double userId;
@property (nonatomic, assign) id img;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, assign) double sort;
@property (nonatomic, assign) double enable;
@property (nonatomic, assign) id video;
@property (nonatomic, assign) id seoTitle;
@property (nonatomic, assign) double type;
@property (nonatomic, assign) double isScroll;
@property (nonatomic, assign) double isTop;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, assign) id subTitle;
@property (nonatomic, assign) double isExtendAttr;
@property (nonatomic, assign) id seoKeyworks;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) id seoDesc;
@property (nonatomic, assign) id desc;
@property (nonatomic, assign) double categoryId;
@property (nonatomic, assign) double isHot;
@property (nonatomic, assign) double isComment;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
