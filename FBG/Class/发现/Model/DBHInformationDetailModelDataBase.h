//
//  DBHInformationDetailModelDataBase.h
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBHInformationDetailModelData;

@interface DBHInformationDetailModelDataBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double code;
@property (nonatomic, strong) DBHInformationDetailModelData *data;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *url;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
