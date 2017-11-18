//
//  DBHInformationForProjectCollectionViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackSideBlock)();

@class DBHInformationForProjectCollectionModelData;
@class DBHInformationForMoneyConditionModelData;

@interface DBHInformationForProjectCollectionViewCell : UICollectionViewCell

/**
 数据
 */
@property (nonatomic, strong) DBHInformationForProjectCollectionModelData *model;

/**
 货币数据
 */
@property (nonatomic, strong) DBHInformationForMoneyConditionModelData *moneyModel;

/**
 是否反面
 */
@property (nonatomic, assign) BOOL isBackSide;

/**
 翻面回调
 */
- (void)backSideBlock:(BackSideBlock)backSideBlock;

@end
