//
//  DBHInformationForRoastingChartCollectionData.m
//
//  Created by   on 2017/11/14
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForRoastingChartCollectionData.h"
#import "DBHInformationForRoastingChartCollectionList.h"


NSString *const kDBHInformationForRoastingChartCollectionDataList = @"list";


@interface DBHInformationForRoastingChartCollectionData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForRoastingChartCollectionData

@synthesize list = _list;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedDBHInformationForRoastingChartCollectionList = [dict objectForKey:kDBHInformationForRoastingChartCollectionDataList];
    NSMutableArray *parsedDBHInformationForRoastingChartCollectionList = [NSMutableArray array];
    
    if ([receivedDBHInformationForRoastingChartCollectionList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationForRoastingChartCollectionList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationForRoastingChartCollectionList addObject:[DBHInformationForRoastingChartCollectionList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationForRoastingChartCollectionList isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationForRoastingChartCollectionList addObject:[DBHInformationForRoastingChartCollectionList modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationForRoastingChartCollectionList]];
    }

    self.list = [NSArray arrayWithArray:parsedDBHInformationForRoastingChartCollectionList];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForList = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.list) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kDBHInformationForRoastingChartCollectionDataList];

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

    self.list = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionDataList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_list forKey:kDBHInformationForRoastingChartCollectionDataList];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForRoastingChartCollectionData *copy = [[DBHInformationForRoastingChartCollectionData alloc] init];
    
    
    
    if (copy) {

        copy.list = [self.list copyWithZone:zone];
    }
    
    return copy;
}


@end
