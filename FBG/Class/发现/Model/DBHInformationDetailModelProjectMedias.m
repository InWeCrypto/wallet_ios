//
//  DBHInformationDetailModelProjectMedias.m
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailModelProjectMedias.h"


NSString *const kDBHInformationDetailModelProjectMediasImg = @"img";
NSString *const kDBHInformationDetailModelProjectMediasName = @"name";
NSString *const kDBHInformationDetailModelProjectMediasUrl = @"url";
NSString *const kDBHInformationDetailModelProjectMediasDesc = @"desc";


@interface DBHInformationDetailModelProjectMedias ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailModelProjectMedias

@synthesize img = _img;
@synthesize name = _name;
@synthesize url = _url;
@synthesize desc = _desc;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.img = [self objectOrNilForKey:kDBHInformationDetailModelProjectMediasImg fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationDetailModelProjectMediasName fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationDetailModelProjectMediasUrl fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHInformationDetailModelProjectMediasDesc fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.img forKey:kDBHInformationDetailModelProjectMediasImg];
    [mutableDict setValue:self.name forKey:kDBHInformationDetailModelProjectMediasName];
    [mutableDict setValue:self.url forKey:kDBHInformationDetailModelProjectMediasUrl];
    [mutableDict setValue:self.desc forKey:kDBHInformationDetailModelProjectMediasDesc];

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

    self.img = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectMediasImg];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectMediasName];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectMediasUrl];
    self.desc = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectMediasDesc];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_img forKey:kDBHInformationDetailModelProjectMediasImg];
    [aCoder encodeObject:_name forKey:kDBHInformationDetailModelProjectMediasName];
    [aCoder encodeObject:_url forKey:kDBHInformationDetailModelProjectMediasUrl];
    [aCoder encodeObject:_desc forKey:kDBHInformationDetailModelProjectMediasDesc];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailModelProjectMedias *copy = [[DBHInformationDetailModelProjectMedias alloc] init];
    
    
    
    if (copy) {

        copy.img = [self.img copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
    }
    
    return copy;
}


@end
