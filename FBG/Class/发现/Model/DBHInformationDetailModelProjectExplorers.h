//
//  DBHInformationDetailModelProjectExplorers.h
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationDetailModelProjectExplorers : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
