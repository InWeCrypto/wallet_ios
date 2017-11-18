//
//  DBHInformationForProjectCollectionModelData.h
//
//  Created by   on 2017/11/16
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationForProjectCollectionModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) id longName;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, assign) id style;
@property (nonatomic, assign) double gridType;
@property (nonatomic, assign) id enName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) double isCc;
@property (nonatomic, assign) double isSave;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, assign) id icon;
@property (nonatomic, assign) id callbackFun;
@property (nonatomic, assign) double sort;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, assign) id seoTitle;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double saveUser;
@property (nonatomic, assign) double type;
@property (nonatomic, assign) double isScroll;
@property (nonatomic, assign) double isTop;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, assign) id seoKeyworks;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) id seoDesc;
@property (nonatomic, assign) double isHot;
@property (nonatomic, assign) double isComment;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
