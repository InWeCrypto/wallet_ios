//
//  DBHInformationDetailModelProjectExplorers.m
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailModelProjectExplorers.h"


NSString *const kDBHInformationDetailModelProjectExplorersImg = @"img";
NSString *const kDBHInformationDetailModelProjectExplorersName = @"name";
NSString *const kDBHInformationDetailModelProjectExplorersUrl = @"url";


@interface DBHInformationDetailModelProjectExplorers ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailModelProjectExplorers

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
            self.img = [self objectOrNilForKey:kDBHInformationDetailModelProjectExplorersImg fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationDetailModelProjectExplorersName fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationDetailModelProjectExplorersUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.img forKey:kDBHInformationDetailModelProjectExplorersImg];
    [mutableDict setValue:self.name forKey:kDBHInformationDetailModelProjectExplorersName];
    [mutableDict setValue:self.url forKey:kDBHInformationDetailModelProjectExplorersUrl];

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

    self.img = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectExplorersImg];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectExplorersName];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectExplorersUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_img forKey:kDBHInformationDetailModelProjectExplorersImg];
    [aCoder encodeObject:_name forKey:kDBHInformationDetailModelProjectExplorersName];
    [aCoder encodeObject:_url forKey:kDBHInformationDetailModelProjectExplorersUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailModelProjectExplorers *copy = [[DBHInformationDetailModelProjectExplorers alloc] init];
    
    
    
    if (copy) {

        copy.img = [self.img copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
