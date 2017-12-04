//
//  DBHInformationDetailModelIcoDetail.m
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailModelIcoDetail.h"


NSString *const kDBHInformationDetailModelIcoDetailValue = @"value";
NSString *const kDBHInformationDetailModelIcoDetailKey = @"key";
NSString *const kDBHInformationDetailModelIcoDetailName = @"name";
NSString *const kDBHInformationDetailModelIcoDetailDesc = @"desc";


@interface DBHInformationDetailModelIcoDetail ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailModelIcoDetail

@synthesize value = _value;
@synthesize key = _key;
@synthesize name = _name;
@synthesize desc = _desc;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.value = [self objectOrNilForKey:kDBHInformationDetailModelIcoDetailValue fromDictionary:dict];
            self.key = [self objectOrNilForKey:kDBHInformationDetailModelIcoDetailKey fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationDetailModelIcoDetailName fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHInformationDetailModelIcoDetailDesc fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.value forKey:kDBHInformationDetailModelIcoDetailValue];
    [mutableDict setValue:self.key forKey:kDBHInformationDetailModelIcoDetailKey];
    [mutableDict setValue:self.name forKey:kDBHInformationDetailModelIcoDetailName];
    [mutableDict setValue:self.desc forKey:kDBHInformationDetailModelIcoDetailDesc];

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

    self.value = [aDecoder decodeObjectForKey:kDBHInformationDetailModelIcoDetailValue];
    self.key = [aDecoder decodeObjectForKey:kDBHInformationDetailModelIcoDetailKey];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationDetailModelIcoDetailName];
    self.desc = [aDecoder decodeObjectForKey:kDBHInformationDetailModelIcoDetailDesc];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_value forKey:kDBHInformationDetailModelIcoDetailValue];
    [aCoder encodeObject:_key forKey:kDBHInformationDetailModelIcoDetailKey];
    [aCoder encodeObject:_name forKey:kDBHInformationDetailModelIcoDetailName];
    [aCoder encodeObject:_desc forKey:kDBHInformationDetailModelIcoDetailDesc];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailModelIcoDetail *copy = [[DBHInformationDetailModelIcoDetail alloc] init];
    
    
    
    if (copy) {

        copy.value = [self.value copyWithZone:zone];
        copy.key = [self.key copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
    }
    
    return copy;
}


@end
