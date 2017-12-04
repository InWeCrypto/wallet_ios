//
//  AddQuotesVCModelData.h
//
//  Created by   on 2017/12/2
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AddQuotesVCModelUserTicker;

@interface AddQuotesVCModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, assign) double enable;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) AddQuotesVCModelUserTicker *userTicker;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *webSite;
@property (nonatomic, strong) NSString *enName;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *enLongName;
@property (nonatomic, strong) NSString *longName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double sort;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
