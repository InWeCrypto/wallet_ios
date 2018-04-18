//
//  DBHTransferListModelList.m
//
//  Created by   on 2018/1/10
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHTransferListModelList.h"


NSString *const kDBHTransferListModelListFrom = @"from";
NSString *const kDBHTransferListModelListRemark = REMARK;
NSString *const kDBHTransferListModelListAsset = @"asset";
NSString *const kDBHTransferListModelListTx = @"tx";
NSString *const kDBHTransferListModelListConfirmTime = @"confirmTime";
NSString *const kDBHTransferListModelListContext = @"context";
NSString *const kDBHTransferListModelListValue = VALUE;
NSString *const kDBHTransferListModelListIsToken = @"is_token";
NSString *const kDBHTransferListModelListHandleFee = HANDLE_FEE;
NSString *const kDBHTransferListModelListCreateTime = @"createTime";
NSString *const kDBHTransferListModelListTo = @"to";


@interface DBHTransferListModelList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHTransferListModelList

@synthesize from = _from;
@synthesize remark = _remark;
@synthesize asset = _asset;
@synthesize tx = _tx;
@synthesize confirmTime = _confirmTime;
@synthesize context = _context;
@synthesize value = _value;
@synthesize isToken = _isToken;
@synthesize handleFee = _handleFee;
@synthesize createTime = _createTime;
@synthesize to = _to;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.from = [self objectOrNilForKey:kDBHTransferListModelListFrom fromDictionary:dict];
            self.remark = [self objectOrNilForKey:kDBHTransferListModelListRemark fromDictionary:dict];
            self.asset = [self objectOrNilForKey:kDBHTransferListModelListAsset fromDictionary:dict];
            self.tx = [self objectOrNilForKey:kDBHTransferListModelListTx fromDictionary:dict];
            self.confirmTime = [self objectOrNilForKey:kDBHTransferListModelListConfirmTime fromDictionary:dict];
            self.context = [self objectOrNilForKey:kDBHTransferListModelListContext fromDictionary:dict];
            self.value = [self objectOrNilForKey:kDBHTransferListModelListValue fromDictionary:dict];
            self.isToken = [self objectOrNilForKey:kDBHTransferListModelListIsToken fromDictionary:dict];
        
            
        
            self.handleFee = [self objectOrNilForKey:kDBHTransferListModelListHandleFee fromDictionary:dict];
            self.createTime = [self objectOrNilForKey:kDBHTransferListModelListCreateTime fromDictionary:dict];
            self.to = [self objectOrNilForKey:kDBHTransferListModelListTo fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.from forKey:kDBHTransferListModelListFrom];
    [mutableDict setValue:self.remark forKey:kDBHTransferListModelListRemark];
    [mutableDict setValue:self.asset forKey:kDBHTransferListModelListAsset];
    [mutableDict setValue:self.tx forKey:kDBHTransferListModelListTx];
    [mutableDict setValue:self.confirmTime forKey:kDBHTransferListModelListConfirmTime];
    [mutableDict setValue:self.context forKey:kDBHTransferListModelListContext];
    [mutableDict setValue:self.value forKey:kDBHTransferListModelListValue];
    [mutableDict setValue:self.isToken forKey:kDBHTransferListModelListIsToken];
    [mutableDict setValue:self.handleFee forKey:kDBHTransferListModelListHandleFee];
    [mutableDict setValue:self.createTime forKey:kDBHTransferListModelListCreateTime];
    [mutableDict setValue:self.to forKey:kDBHTransferListModelListTo];

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

    self.from = [aDecoder decodeObjectForKey:kDBHTransferListModelListFrom];
    self.remark = [aDecoder decodeObjectForKey:kDBHTransferListModelListRemark];
    self.asset = [aDecoder decodeObjectForKey:kDBHTransferListModelListAsset];
    self.tx = [aDecoder decodeObjectForKey:kDBHTransferListModelListTx];
    self.confirmTime = [aDecoder decodeObjectForKey:kDBHTransferListModelListConfirmTime];
    self.context = [aDecoder decodeObjectForKey:kDBHTransferListModelListContext];
    self.value = [aDecoder decodeObjectForKey:kDBHTransferListModelListValue];
    self.isToken = [aDecoder decodeObjectForKey:kDBHTransferListModelListIsToken];
    self.handleFee = [aDecoder decodeObjectForKey:kDBHTransferListModelListHandleFee];
    self.createTime = [aDecoder decodeObjectForKey:kDBHTransferListModelListCreateTime];
    self.to = [aDecoder decodeObjectForKey:kDBHTransferListModelListTo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_from forKey:kDBHTransferListModelListFrom];
    [aCoder encodeObject:_remark forKey:kDBHTransferListModelListRemark];
    [aCoder encodeObject:_asset forKey:kDBHTransferListModelListAsset];
    [aCoder encodeObject:_tx forKey:kDBHTransferListModelListTx];
    [aCoder encodeObject:_confirmTime forKey:kDBHTransferListModelListConfirmTime];
    [aCoder encodeObject:_context forKey:kDBHTransferListModelListContext];
    [aCoder encodeObject:_value forKey:kDBHTransferListModelListValue];
    [aCoder encodeObject:_isToken forKey:kDBHTransferListModelListIsToken];
    [aCoder encodeObject:_handleFee forKey:kDBHTransferListModelListHandleFee];
    [aCoder encodeObject:_createTime forKey:kDBHTransferListModelListCreateTime];
    [aCoder encodeObject:_to forKey:kDBHTransferListModelListTo];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHTransferListModelList *copy = [[DBHTransferListModelList alloc] init];
    
    
    
    if (copy) {

        copy.from = [self.from copyWithZone:zone];
        copy.remark = [self.remark copyWithZone:zone];
        copy.asset = [self.asset copyWithZone:zone];
        copy.tx = [self.tx copyWithZone:zone];
        copy.confirmTime = [self.confirmTime copyWithZone:zone];
        copy.context = [self.context copyWithZone:zone];
        copy.value = [self.value copyWithZone:zone];
        copy.isToken = [self.isToken copyWithZone:zone];
        copy.handleFee = [self.handleFee copyWithZone:zone];
        copy.createTime = [self.createTime copyWithZone:zone];
        copy.to = [self.to copyWithZone:zone];
    }
    
    return copy;
}

- (NSString *)maxBlockNumber {
    if (!_maxBlockNumber) {
        _maxBlockNumber = @"0";
    }
    return _maxBlockNumber;
}

- (NSString *)minBlockNumber {
    if (!_minBlockNumber) {
        _minBlockNumber = @"12";
    }
    return _minBlockNumber;
}

@end
