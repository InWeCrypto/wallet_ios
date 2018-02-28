//
//  DBHWalletManagerForNeoModelCategory.h
//
//  Created by   on 2018/1/9
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHWalletManagerForNeoModelCategory : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double categoryIdentifier;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
