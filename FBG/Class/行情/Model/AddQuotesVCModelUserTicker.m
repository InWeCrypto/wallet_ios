//
//  AddQuotesVCModelUserTicker.m
//
//  Created by   on 2017/12/2
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "AddQuotesVCModelUserTicker.h"


NSString *const kAddQuotesVCModelUserTickerIcoId = @"ico_id";
NSString *const kAddQuotesVCModelUserTickerSort = @"sort";


@interface AddQuotesVCModelUserTicker ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AddQuotesVCModelUserTicker

@synthesize icoId = _icoId;
@synthesize sort = _sort;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.icoId = [self objectOrNilForKey:kAddQuotesVCModelUserTickerIcoId fromDictionary:dict];
            self.sort = [self objectOrNilForKey:kAddQuotesVCModelUserTickerSort fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.icoId forKey:kAddQuotesVCModelUserTickerIcoId];
    [mutableDict setValue:self.sort forKey:kAddQuotesVCModelUserTickerSort];

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

    self.icoId = [aDecoder decodeObjectForKey:kAddQuotesVCModelUserTickerIcoId];
    self.sort = [aDecoder decodeObjectForKey:kAddQuotesVCModelUserTickerSort];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_icoId forKey:kAddQuotesVCModelUserTickerIcoId];
    [aCoder encodeObject:_sort forKey:kAddQuotesVCModelUserTickerSort];
}

- (id)copyWithZone:(NSZone *)zone {
    AddQuotesVCModelUserTicker *copy = [[AddQuotesVCModelUserTicker alloc] init];
    
    
    
    if (copy) {

        copy.icoId = [self.icoId copyWithZone:zone];
        copy.sort = [self.sort copyWithZone:zone];
    }
    
    return copy;
}


@end
