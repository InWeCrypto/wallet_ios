//
//  DBHInformationForRoastingChartCollectionModelData.m
//
//  Created by   on 2017/11/22
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForRoastingChartCollectionModelData.h"
#import "DBHInformationForRoastingChartCollectionModelList.h"


NSString *const kDBHInformationForRoastingChartCollectionModelDataList = @"list";


@interface DBHInformationForRoastingChartCollectionModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForRoastingChartCollectionModelData

@synthesize list = _list;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedDBHInformationForRoastingChartCollectionModelList = [dict objectForKey:kDBHInformationForRoastingChartCollectionModelDataList];
    NSMutableArray *parsedDBHInformationForRoastingChartCollectionModelList = [NSMutableArray array];
    
    if ([receivedDBHInformationForRoastingChartCollectionModelList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationForRoastingChartCollectionModelList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationForRoastingChartCollectionModelList addObject:[DBHInformationForRoastingChartCollectionModelList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationForRoastingChartCollectionModelList isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationForRoastingChartCollectionModelList addObject:[DBHInformationForRoastingChartCollectionModelList modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationForRoastingChartCollectionModelList]];
    }

    self.list = [NSArray arrayWithArray:parsedDBHInformationForRoastingChartCollectionModelList];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kDBHInformationForRoastingChartCollectionModelDataList];

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

    self.list = [aDecoder decodeObjectForKey:kDBHInformationForRoastingChartCollectionModelDataList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_list forKey:kDBHInformationForRoastingChartCollectionModelDataList];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForRoastingChartCollectionModelData *copy = [[DBHInformationForRoastingChartCollectionModelData alloc] init];
    
    
    
    if (copy) {

        copy.list = [self.list copyWithZone:zone];
    }
    
    return copy;
}


@end
