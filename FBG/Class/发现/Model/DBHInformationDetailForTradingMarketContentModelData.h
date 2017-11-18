//
//  DBHInformationDetailForTradingMarketContentModelData.h
//
//  Created by   on 2017/11/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationDetailForTradingMarketContentModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *pairce;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *update;
@property (nonatomic, strong) NSString *volumPercent;
@property (nonatomic, strong) NSString *volum24;
@property (nonatomic, strong) NSString *pair;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
