//
//  DBHTransferListModelList.m
//
//  Created by   on 2018/1/10
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHTransferListModelList.h"

@implementation DBHTransferListModelList

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"hashStr" : @"hash"
             };
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
