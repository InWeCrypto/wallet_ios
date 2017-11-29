//
//  DBHInformationDetailModelProjectTimePrices.h
//
//  Created by   on 2017/11/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationDetailModelProjectTimePrices : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) id enName;
@property (nonatomic, strong) NSString *kLineDataUrl;
@property (nonatomic, assign) double projectTimePricesIdentifier;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) id longName;
@property (nonatomic, assign) double projectId;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *currentUrl;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
