//
//  AddQuotesVCModelUserTicker.h
//
//  Created by   on 2017/12/2
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AddQuotesVCModelUserTicker : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *icoId;
@property (nonatomic, strong) NSString *sort;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
