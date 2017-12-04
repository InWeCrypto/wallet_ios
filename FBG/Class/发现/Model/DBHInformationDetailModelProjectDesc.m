//
//  DBHInformationDetailModelProjectDesc.m
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailModelProjectDesc.h"


NSString *const kDBHInformationDetailModelProjectDescId = @"id";
NSString *const kDBHInformationDetailModelProjectDescTitle = @"title";


@interface DBHInformationDetailModelProjectDesc ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailModelProjectDesc

@synthesize projectDescIdentifier = _projectDescIdentifier;
@synthesize title = _title;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.projectDescIdentifier = [self objectOrNilForKey:kDBHInformationDetailModelProjectDescId fromDictionary:dict];
            self.title = [self objectOrNilForKey:kDBHInformationDetailModelProjectDescTitle fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.projectDescIdentifier forKey:kDBHInformationDetailModelProjectDescId];
    [mutableDict setValue:self.title forKey:kDBHInformationDetailModelProjectDescTitle];

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

    self.projectDescIdentifier = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDescId];
    self.title = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDescTitle];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_projectDescIdentifier forKey:kDBHInformationDetailModelProjectDescId];
    [aCoder encodeObject:_title forKey:kDBHInformationDetailModelProjectDescTitle];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailModelProjectDesc *copy = [[DBHInformationDetailModelProjectDesc alloc] init];
    
    
    
    if (copy) {

        copy.projectDescIdentifier = [self.projectDescIdentifier copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
    }
    
    return copy;
}


@end
