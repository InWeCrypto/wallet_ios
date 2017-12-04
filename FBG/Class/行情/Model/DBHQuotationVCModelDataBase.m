//
//  DBHQuotationVCModelDataBase.m
//
//  Created by   on 2017/12/2
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHQuotationVCModelDataBase.h"
#import "DBHQuotationVCModelData.h"


NSString *const kDBHQuotationVCModelDataBaseMsg = @"msg";
NSString *const kDBHQuotationVCModelDataBaseData = @"data";
NSString *const kDBHQuotationVCModelDataBaseCode = @"code";


@interface DBHQuotationVCModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHQuotationVCModelDataBase

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
            self.msg = [self objectOrNilForKey:kDBHQuotationVCModelDataBaseMsg fromDictionary:dict];
    NSObject *receivedDBHQuotationVCModelData = [dict objectForKey:kDBHQuotationVCModelDataBaseData];
    NSMutableArray *parsedDBHQuotationVCModelData = [NSMutableArray array];
    
    if ([receivedDBHQuotationVCModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHQuotationVCModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHQuotationVCModelData addObject:[DBHQuotationVCModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHQuotationVCModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHQuotationVCModelData addObject:[DBHQuotationVCModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHQuotationVCModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHQuotationVCModelData];
            self.code = [[self objectOrNilForKey:kDBHQuotationVCModelDataBaseCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.msg forKey:kDBHQuotationVCModelDataBaseMsg];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHQuotationVCModelDataBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHQuotationVCModelDataBaseCode];

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

    self.msg = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataBaseMsg];
    self.data = [aDecoder decodeObjectForKey:kDBHQuotationVCModelDataBaseData];
    self.code = [aDecoder decodeDoubleForKey:kDBHQuotationVCModelDataBaseCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_msg forKey:kDBHQuotationVCModelDataBaseMsg];
    [aCoder encodeObject:_data forKey:kDBHQuotationVCModelDataBaseData];
    [aCoder encodeDouble:_code forKey:kDBHQuotationVCModelDataBaseCode];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHQuotationVCModelDataBase *copy = [[DBHQuotationVCModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
        copy.code = self.code;
    }
    
    return copy;
}


@end
