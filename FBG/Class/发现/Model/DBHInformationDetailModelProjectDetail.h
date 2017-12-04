//
//  DBHInformationDetailModelProjectDetail.h
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationDetailModelProjectDetail : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double projectDetailIdentifier;
@property (nonatomic, strong) NSString *endAt;
@property (nonatomic, assign) double riskLevel;
@property (nonatomic, strong) NSString *accept;
@property (nonatomic, strong) NSString *riskLevelColor;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *icoScale;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, assign) double isOnline;
@property (nonatomic, strong) NSString *startAt;
@property (nonatomic, strong) NSString *targetQuantity;
@property (nonatomic, strong) NSString *crowdfundPeriods;
@property (nonatomic, assign) double projectId;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *currentQuantity;
@property (nonatomic, assign) id name;
@property (nonatomic, strong) NSString *riskLevelName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
