//
//  DBHInformationForRoastingChartCollectionModelList.h
//
//  Created by   on 2017/11/22
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationForRoastingChartCollectionModelList : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double listIdentifier;
@property (nonatomic, strong) NSString *endAt;
@property (nonatomic, assign) double style;
@property (nonatomic, assign) double enable;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *urlDesc;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *enName;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *startAt;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *urlIcon;
@property (nonatomic, strong) NSString *urlImg;
@property (nonatomic, assign) double sort;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *longName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
