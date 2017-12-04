//
//  DBHInformationDetailModelProjectDetail.m
//
//  Created by   on 2017/11/18
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationDetailModelProjectDetail.h"


NSString *const kDBHInformationDetailModelProjectDetailId = @"id";
NSString *const kDBHInformationDetailModelProjectDetailEndAt = @"end_at";
NSString *const kDBHInformationDetailModelProjectDetailRiskLevel = @"risk_level";
NSString *const kDBHInformationDetailModelProjectDetailAccept = @"accept";
NSString *const kDBHInformationDetailModelProjectDetailRiskLevelColor = @"risk_level_color";
NSString *const kDBHInformationDetailModelProjectDetailCreatedAt = @"created_at";
NSString *const kDBHInformationDetailModelProjectDetailIcoScale = @"ico_scale";
NSString *const kDBHInformationDetailModelProjectDetailTotal = @"total";
NSString *const kDBHInformationDetailModelProjectDetailIsOnline = @"is_online";
NSString *const kDBHInformationDetailModelProjectDetailStartAt = @"start_at";
NSString *const kDBHInformationDetailModelProjectDetailTargetQuantity = @"target_quantity";
NSString *const kDBHInformationDetailModelProjectDetailCrowdfundPeriods = @"crowdfund_periods";
NSString *const kDBHInformationDetailModelProjectDetailProjectId = @"project_id";
NSString *const kDBHInformationDetailModelProjectDetailUpdatedAt = @"updated_at";
NSString *const kDBHInformationDetailModelProjectDetailCurrentQuantity = @"current_quantity";
NSString *const kDBHInformationDetailModelProjectDetailName = @"name";
NSString *const kDBHInformationDetailModelProjectDetailRiskLevelName = @"risk_level_name";


@interface DBHInformationDetailModelProjectDetail ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationDetailModelProjectDetail

@synthesize projectDetailIdentifier = _projectDetailIdentifier;
@synthesize endAt = _endAt;
@synthesize riskLevel = _riskLevel;
@synthesize accept = _accept;
@synthesize riskLevelColor = _riskLevelColor;
@synthesize createdAt = _createdAt;
@synthesize icoScale = _icoScale;
@synthesize total = _total;
@synthesize isOnline = _isOnline;
@synthesize startAt = _startAt;
@synthesize targetQuantity = _targetQuantity;
@synthesize crowdfundPeriods = _crowdfundPeriods;
@synthesize projectId = _projectId;
@synthesize updatedAt = _updatedAt;
@synthesize currentQuantity = _currentQuantity;
@synthesize name = _name;
@synthesize riskLevelName = _riskLevelName;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.projectDetailIdentifier = [[self objectOrNilForKey:kDBHInformationDetailModelProjectDetailId fromDictionary:dict] doubleValue];
            self.endAt = [self objectOrNilForKey:kDBHInformationDetailModelProjectDetailEndAt fromDictionary:dict];
            self.riskLevel = [[self objectOrNilForKey:kDBHInformationDetailModelProjectDetailRiskLevel fromDictionary:dict] doubleValue];
            self.accept = [self objectOrNilForKey:kDBHInformationDetailModelProjectDetailAccept fromDictionary:dict];
            self.riskLevelColor = [self objectOrNilForKey:kDBHInformationDetailModelProjectDetailRiskLevelColor fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kDBHInformationDetailModelProjectDetailCreatedAt fromDictionary:dict];
            self.icoScale = [self objectOrNilForKey:kDBHInformationDetailModelProjectDetailIcoScale fromDictionary:dict];
            self.total = [self objectOrNilForKey:kDBHInformationDetailModelProjectDetailTotal fromDictionary:dict];
            self.isOnline = [[self objectOrNilForKey:kDBHInformationDetailModelProjectDetailIsOnline fromDictionary:dict] doubleValue];
            self.startAt = [self objectOrNilForKey:kDBHInformationDetailModelProjectDetailStartAt fromDictionary:dict];
            self.targetQuantity = [self objectOrNilForKey:kDBHInformationDetailModelProjectDetailTargetQuantity fromDictionary:dict];
            self.crowdfundPeriods = [self objectOrNilForKey:kDBHInformationDetailModelProjectDetailCrowdfundPeriods fromDictionary:dict];
            self.projectId = [[self objectOrNilForKey:kDBHInformationDetailModelProjectDetailProjectId fromDictionary:dict] doubleValue];
            self.updatedAt = [self objectOrNilForKey:kDBHInformationDetailModelProjectDetailUpdatedAt fromDictionary:dict];
            self.currentQuantity = [self objectOrNilForKey:kDBHInformationDetailModelProjectDetailCurrentQuantity fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationDetailModelProjectDetailName fromDictionary:dict];
            self.riskLevelName = [self objectOrNilForKey:kDBHInformationDetailModelProjectDetailRiskLevelName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.projectDetailIdentifier] forKey:kDBHInformationDetailModelProjectDetailId];
    [mutableDict setValue:self.endAt forKey:kDBHInformationDetailModelProjectDetailEndAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.riskLevel] forKey:kDBHInformationDetailModelProjectDetailRiskLevel];
    [mutableDict setValue:self.accept forKey:kDBHInformationDetailModelProjectDetailAccept];
    [mutableDict setValue:self.riskLevelColor forKey:kDBHInformationDetailModelProjectDetailRiskLevelColor];
    [mutableDict setValue:self.createdAt forKey:kDBHInformationDetailModelProjectDetailCreatedAt];
    [mutableDict setValue:self.icoScale forKey:kDBHInformationDetailModelProjectDetailIcoScale];
    [mutableDict setValue:self.total forKey:kDBHInformationDetailModelProjectDetailTotal];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isOnline] forKey:kDBHInformationDetailModelProjectDetailIsOnline];
    [mutableDict setValue:self.startAt forKey:kDBHInformationDetailModelProjectDetailStartAt];
    [mutableDict setValue:self.targetQuantity forKey:kDBHInformationDetailModelProjectDetailTargetQuantity];
    [mutableDict setValue:self.crowdfundPeriods forKey:kDBHInformationDetailModelProjectDetailCrowdfundPeriods];
    [mutableDict setValue:[NSNumber numberWithDouble:self.projectId] forKey:kDBHInformationDetailModelProjectDetailProjectId];
    [mutableDict setValue:self.updatedAt forKey:kDBHInformationDetailModelProjectDetailUpdatedAt];
    [mutableDict setValue:self.currentQuantity forKey:kDBHInformationDetailModelProjectDetailCurrentQuantity];
    [mutableDict setValue:self.name forKey:kDBHInformationDetailModelProjectDetailName];
    [mutableDict setValue:self.riskLevelName forKey:kDBHInformationDetailModelProjectDetailRiskLevelName];

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

    self.projectDetailIdentifier = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelProjectDetailId];
    self.endAt = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDetailEndAt];
    self.riskLevel = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelProjectDetailRiskLevel];
    self.accept = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDetailAccept];
    self.riskLevelColor = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDetailRiskLevelColor];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDetailCreatedAt];
    self.icoScale = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDetailIcoScale];
    self.total = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDetailTotal];
    self.isOnline = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelProjectDetailIsOnline];
    self.startAt = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDetailStartAt];
    self.targetQuantity = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDetailTargetQuantity];
    self.crowdfundPeriods = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDetailCrowdfundPeriods];
    self.projectId = [aDecoder decodeDoubleForKey:kDBHInformationDetailModelProjectDetailProjectId];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDetailUpdatedAt];
    self.currentQuantity = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDetailCurrentQuantity];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDetailName];
    self.riskLevelName = [aDecoder decodeObjectForKey:kDBHInformationDetailModelProjectDetailRiskLevelName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_projectDetailIdentifier forKey:kDBHInformationDetailModelProjectDetailId];
    [aCoder encodeObject:_endAt forKey:kDBHInformationDetailModelProjectDetailEndAt];
    [aCoder encodeDouble:_riskLevel forKey:kDBHInformationDetailModelProjectDetailRiskLevel];
    [aCoder encodeObject:_accept forKey:kDBHInformationDetailModelProjectDetailAccept];
    [aCoder encodeObject:_riskLevelColor forKey:kDBHInformationDetailModelProjectDetailRiskLevelColor];
    [aCoder encodeObject:_createdAt forKey:kDBHInformationDetailModelProjectDetailCreatedAt];
    [aCoder encodeObject:_icoScale forKey:kDBHInformationDetailModelProjectDetailIcoScale];
    [aCoder encodeObject:_total forKey:kDBHInformationDetailModelProjectDetailTotal];
    [aCoder encodeDouble:_isOnline forKey:kDBHInformationDetailModelProjectDetailIsOnline];
    [aCoder encodeObject:_startAt forKey:kDBHInformationDetailModelProjectDetailStartAt];
    [aCoder encodeObject:_targetQuantity forKey:kDBHInformationDetailModelProjectDetailTargetQuantity];
    [aCoder encodeObject:_crowdfundPeriods forKey:kDBHInformationDetailModelProjectDetailCrowdfundPeriods];
    [aCoder encodeDouble:_projectId forKey:kDBHInformationDetailModelProjectDetailProjectId];
    [aCoder encodeObject:_updatedAt forKey:kDBHInformationDetailModelProjectDetailUpdatedAt];
    [aCoder encodeObject:_currentQuantity forKey:kDBHInformationDetailModelProjectDetailCurrentQuantity];
    [aCoder encodeObject:_name forKey:kDBHInformationDetailModelProjectDetailName];
    [aCoder encodeObject:_riskLevelName forKey:kDBHInformationDetailModelProjectDetailRiskLevelName];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationDetailModelProjectDetail *copy = [[DBHInformationDetailModelProjectDetail alloc] init];
    
    
    
    if (copy) {

        copy.projectDetailIdentifier = self.projectDetailIdentifier;
        copy.endAt = [self.endAt copyWithZone:zone];
        copy.riskLevel = self.riskLevel;
        copy.accept = [self.accept copyWithZone:zone];
        copy.riskLevelColor = [self.riskLevelColor copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.icoScale = [self.icoScale copyWithZone:zone];
        copy.total = [self.total copyWithZone:zone];
        copy.isOnline = self.isOnline;
        copy.startAt = [self.startAt copyWithZone:zone];
        copy.targetQuantity = [self.targetQuantity copyWithZone:zone];
        copy.crowdfundPeriods = [self.crowdfundPeriods copyWithZone:zone];
        copy.projectId = self.projectId;
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.currentQuantity = [self.currentQuantity copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.riskLevelName = [self.riskLevelName copyWithZone:zone];
    }
    
    return copy;
}


@end
