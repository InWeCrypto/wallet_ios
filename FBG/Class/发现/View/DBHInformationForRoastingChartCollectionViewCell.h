//
//  DBHInformationForRoastingChartCollectionViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickRoastingChartBlock)(NSInteger clickRoastingChartBlockIndex);

@interface DBHInformationForRoastingChartCollectionViewCell : UICollectionViewCell

/**
 轮播图数据
 */
@property (nonatomic, copy) NSArray *dataSource;

/**
 点击轮播图回调
 */
- (void)clickRoastingChartBlock:(ClickRoastingChartBlock)clickRoastingChartBlock;

@end
