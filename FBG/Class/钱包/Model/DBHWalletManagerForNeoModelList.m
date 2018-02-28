//
//  DBHWalletManagerForNeoModelList.m
//
//  Created by   on 2018/1/9
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHWalletManagerForNeoModelList.h"
#import "DBHWalletManagerForNeoModelCategory.h"


NSString *const kDBHWalletManagerForNeoModelListCategory = @"category";
NSString *const kDBHWalletManagerForNeoModelListAddress = @"address";
NSString *const kDBHWalletManagerForNeoModelListId = @"id";
NSString *const kDBHWalletManagerForNeoModelListCreatedAt = @"created_at";
NSString *const kDBHWalletManagerForNeoModelListDeletedAt = @"deleted_at";
NSString *const kDBHWalletManagerForNeoModelListAddressHash160 = @"address_hash160";
NSString *const kDBHWalletManagerForNeoModelListCategoryId = @"category_id";
NSString *const kDBHWalletManagerForNeoModelListUserId = @"user_id";
NSString *const kDBHWalletManagerForNeoModelListUpdatedAt = @"updated_at";
NSString *const kDBHWalletManagerForNeoModelListName = @"name";


@interface DBHWalletManagerForNeoModelList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHWalletManagerForNeoModelList

@synthesize category = _category;
@synthesize address = _address;
@synthesize listIdentifier = _listIdentifier;
@synthesize createdAt = _createdAt;
@synthesize deletedAt = _deletedAt;
@synthesize addressHash160 = _addressHash160;
@synthesize categoryId = _categoryId;
@synthesize userId = _userId;
@synthesize updatedAt = _updatedAt;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.category = [DBHWalletManagerForNeoModelCategory modelObjectWithDictionary:[dict objectForKey:kDBHWalletManagerForNeoModelListCategory]];
            self.address = [self objectOrNilForKey:kDBHWalletManagerForNeoModelListAddress fromDictionary:dict];
            self.listIdentifier = [[self objectOrNilForKey:kDBHWalletManagerForNeoModelListId fromDictionary:dict] doubleValue];
            self.createdAt = [self objectOrNilForKey:kDBHWalletManagerForNeoModelListCreatedAt fromDictionary:dict];
            self.deletedAt = [self objectOrNilForKey:kDBHWalletManagerForNeoModelListDeletedAt fromDictionary:dict];
            self.addressHash160 = [self objectOrNilForKey:kDBHWalletManagerForNeoModelListAddressHash160 fromDictionary:dict];
            self.categoryId = [[self objectOrNilForKey:kDBHWalletManagerForNeoModelListCategoryId fromDictionary:dict] doubleValue];
            self.userId = [[self objectOrNilForKey:kDBHWalletManagerForNeoModelListUserId fromDictionary:dict] doubleValue];
            self.updatedAt = [self objectOrNilForKey:kDBHWalletManagerForNeoModelListUpdatedAt fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHWalletManagerForNeoModelListName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.category dictionaryRepresentation] forKey:kDBHWalletManagerForNeoModelListCategory];
    [mutableDict setValue:self.address forKey:kDBHWalletManagerForNeoModelListAddress];
    [mutableDict setValue:[NSNumber numberWithDouble:self.listIdentifier] forKey:kDBHWalletManagerForNeoModelListId];
    [mutableDict setValue:self.createdAt forKey:kDBHWalletManagerForNeoModelListCreatedAt];
    [mutableDict setValue:self.deletedAt forKey:kDBHWalletManagerForNeoModelListDeletedAt];
    [mutableDict setValue:self.addressHash160 forKey:kDBHWalletManagerForNeoModelListAddressHash160];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHWalletManagerForNeoModelListCategoryId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kDBHWalletManagerForNeoModelListUserId];
    [mutableDict setValue:self.updatedAt forKey:kDBHWalletManagerForNeoModelListUpdatedAt];
    [mutableDict setValue:self.name forKey:kDBHWalletManagerForNeoModelListName];

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

    self.category = [aDecoder decodeObjectForKey:kDBHWalletManagerForNeoModelListCategory];
    self.address = [aDecoder decodeObjectForKey:kDBHWalletManagerForNeoModelListAddress];
    self.listIdentifier = [aDecoder decodeDoubleForKey:kDBHWalletManagerForNeoModelListId];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHWalletManagerForNeoModelListCreatedAt];
    self.deletedAt = [aDecoder decodeObjectForKey:kDBHWalletManagerForNeoModelListDeletedAt];
    self.addressHash160 = [aDecoder decodeObjectForKey:kDBHWalletManagerForNeoModelListAddressHash160];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHWalletManagerForNeoModelListCategoryId];
    self.userId = [aDecoder decodeDoubleForKey:kDBHWalletManagerForNeoModelListUserId];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHWalletManagerForNeoModelListUpdatedAt];
    self.name = [aDecoder decodeObjectForKey:kDBHWalletManagerForNeoModelListName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_category forKey:kDBHWalletManagerForNeoModelListCategory];
    [aCoder encodeObject:_address forKey:kDBHWalletManagerForNeoModelListAddress];
    [aCoder encodeDouble:_listIdentifier forKey:kDBHWalletManagerForNeoModelListId];
    [aCoder encodeObject:_createdAt forKey:kDBHWalletManagerForNeoModelListCreatedAt];
    [aCoder encodeObject:_deletedAt forKey:kDBHWalletManagerForNeoModelListDeletedAt];
    [aCoder encodeObject:_addressHash160 forKey:kDBHWalletManagerForNeoModelListAddressHash160];
    [aCoder encodeDouble:_categoryId forKey:kDBHWalletManagerForNeoModelListCategoryId];
    [aCoder encodeDouble:_userId forKey:kDBHWalletManagerForNeoModelListUserId];
    [aCoder encodeObject:_updatedAt forKey:kDBHWalletManagerForNeoModelListUpdatedAt];
    [aCoder encodeObject:_name forKey:kDBHWalletManagerForNeoModelListName];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHWalletManagerForNeoModelList *copy = [[DBHWalletManagerForNeoModelList alloc] init];
    
    
    
    if (copy) {

        copy.category = [self.category copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.listIdentifier = self.listIdentifier;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.deletedAt = [self.deletedAt copyWithZone:zone];
        copy.addressHash160 = [self.addressHash160 copyWithZone:zone];
        copy.categoryId = self.categoryId;
        copy.userId = self.userId;
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


#pragma mark ------ Getters And Setters ------
- (NSMutableDictionary *)tokenStatistics {
    if (!_tokenStatistics) {
        _tokenStatistics = [NSMutableDictionary dictionary];
    }
    return _tokenStatistics;
}

@end
