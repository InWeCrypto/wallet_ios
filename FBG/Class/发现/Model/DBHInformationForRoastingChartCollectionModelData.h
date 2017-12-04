//
//  DBHInformationForRoastingChartCollectionModelData.h
//
//  Created by   on 2017/11/22
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationForRoastingChartCollectionModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *list;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
