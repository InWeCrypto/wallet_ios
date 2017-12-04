//
//  DBHQuotationVCModelTimeData.h
//
//  Created by   on 2017/12/2
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHQuotationVCModelTimeData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *priceCny;
@property (nonatomic, strong) NSString *volumeCny24h;
@property (nonatomic, strong) NSString *priceUsd;
@property (nonatomic, strong) NSString *minPriceCny24h;
@property (nonatomic, strong) NSString *volumeUsd24h;
@property (nonatomic, strong) NSString *minPriceUsd24h;
@property (nonatomic, strong) NSString *change24h;
@property (nonatomic, strong) NSString *maxPriceUsd24h;
@property (nonatomic, strong) NSString *maxPriceCny24h;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
