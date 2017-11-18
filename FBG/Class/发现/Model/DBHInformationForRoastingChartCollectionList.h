//
//  DBHInformationForRoastingChartCollectionList.h
//
//  Created by   on 2017/11/14
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationForRoastingChartCollectionList : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double listIdentifier;
@property (nonatomic, strong) NSString *endAt;
@property (nonatomic, assign) id style;
@property (nonatomic, assign) double enable;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *urlDesc;
@property (nonatomic, assign) id url;
@property (nonatomic, assign) id enName;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *startAt;
@property (nonatomic, assign) id icon;
@property (nonatomic, assign) id updatedAt;
@property (nonatomic, assign) id urlIcon;
@property (nonatomic, assign) id urlImg;
@property (nonatomic, strong) NSString *longName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double sort;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
