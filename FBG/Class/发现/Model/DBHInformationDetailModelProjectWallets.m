//
//  DBHInformationDetailModelProjectWallets.m
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailModelProjectWallets.h"


NSString *const kDBHInformationDetailModelProjectWalletsImg = @"img";
NSString *const kDBHInformationDetailModelProjectWalletsName = @"name";
NSString *const kDBHInformationDetailModelProjectWalletsUrl = @"url";


@interface DBHInformationDetailModelProjectWallets ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailModelProjectWallets

@synthesize img = _img;
@synthesize name = _name;
@synthesize url = _url;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.img = [self objectOrNilForKey:kDBHInformationDetailModelProjectWalletsImg fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationDetailModelProjectWalletsName fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationDetailModelProjectWalletsUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.img forKey:kDBHInformationDetailModelProjectWalletsImg];
    [mutableDict setValue:self.name forKey:kDBHInformationDetailModelProjectWalletsName];
    [mutableDict setValue:self.url forKey:kDBHInformationDetailModelProjectWalletsUrl];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    self.img = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectWalletsImg];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectWalletsName];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectWalletsUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_img forKey:kDBHInformationDetailModelProjectWalletsImg];
    [aCoder encodeObject:_name forKey:kDBHInformationDetailModelProjectWalletsName];
    [aCoder encodeObject:_url forKey:kDBHInformationDetailModelProjectWalletsUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailModelProjectWallets *copy = [[DBHInformationDetailModelProjectWallets alloc] init];
    
    
    
    if (copy) {

        copy.img = [self.img copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
