//
//  AddQuotesVCModelDataBase.m
//
//  Created by   on 2017/12/2
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "AddQuotesVCModelDataBase.h"
#import "AddQuotesVCModelData.h"


NSString *const kAddQuotesVCModelDataBaseMsg = @"msg";
NSString *const kAddQuotesVCModelDataBaseData = @"data";
NSString *const kAddQuotesVCModelDataBaseCode = @"code";


@interface AddQuotesVCModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AddQuotesVCModelDataBase

@synthesize msg = _msg;
@synthesize data = _data;
@synthesize code = _code;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.msg = [self objectOrNilForKey:kAddQuotesVCModelDataBaseMsg fromDictionary:dict];
    NSObject *receivedAddQuotesVCModelData = [dict objectForKey:kAddQuotesVCModelDataBaseData];
    NSMutableArray *parsedAddQuotesVCModelData = [NSMutableArray array];
    
    if ([receivedAddQuotesVCModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedAddQuotesVCModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedAddQuotesVCModelData addObject:[AddQuotesVCModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedAddQuotesVCModelData isKindOfClass:[NSDictionary class]]) {
       [parsedAddQuotesVCModelData addObject:[AddQuotesVCModelData modelObjectWithDictionary:(NSDictionary *)receivedAddQuotesVCModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedAddQuotesVCModelData];
            self.code = [[self objectOrNilForKey:kAddQuotesVCModelDataBaseCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.msg forKey:kAddQuotesVCModelDataBaseMsg];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.data) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kAddQuotesVCModelDataBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kAddQuotesVCModelDataBaseCode];

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

    self.msg = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataBaseMsg];
    self.data = [aDecoder decodeObjectForKey:kAddQuotesVCModelDataBaseData];
    self.code = [aDecoder decodeDoubleForKey:kAddQuotesVCModelDataBaseCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_msg forKey:kAddQuotesVCModelDataBaseMsg];
    [aCoder encodeObject:_data forKey:kAddQuotesVCModelDataBaseData];
    [aCoder encodeDouble:_code forKey:kAddQuotesVCModelDataBaseCode];
}

- (id)copyWithZone:(NSZone *)zone {
    AddQuotesVCModelDataBase *copy = [[AddQuotesVCModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
        copy.code = self.code;
    }
    
    return copy;
}


@end
