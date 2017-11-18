//
//  DBHEvaluatingIcoModelData.h
//
//  Created by   on 2017/11/16
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHEvaluatingIcoModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) id style;
@property (nonatomic, assign) double status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) id img;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, assign) double sort;
@property (nonatomic, assign) double enable;
@property (nonatomic, assign) id seoTitle;
@property (nonatomic, assign) double isScroll;
@property (nonatomic, assign) double isTop;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, assign) id subTitle;
@property (nonatomic, assign) double projectId;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *assessStatus;
@property (nonatomic, assign) id seoKeyworks;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) id seoDesc;
@property (nonatomic, assign) double isHot;
@property (nonatomic, assign) id author;
@property (nonatomic, strong) NSString *content;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
