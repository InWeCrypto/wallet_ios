//
//  UserModel.m
//  FBG
//
//  Created by mac on 2017/7/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (NSMutableArray *)functionalUnitArray {
    if (!_functionalUnitArray) {
        _functionalUnitArray = [NSMutableArray array];
        [_functionalUnitArray addObject:@"0"];
        [_functionalUnitArray addObject:@"0"];
        [_functionalUnitArray addObject:@"0"];
        [_functionalUnitArray addObject:@"0"];
        [_functionalUnitArray addObject:@"0"];
        [_functionalUnitArray addObject:@"0"];
    }
    return _functionalUnitArray;
}

@end
