//
//  DBHInformationDetailModelProjectTimePrices.h
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationDetailModelProjectTimePrices : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *enName;
@property (nonatomic, strong) NSString *currentUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *longName;
@property (nonatomic, strong) NSString *kLineDataUrl;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
