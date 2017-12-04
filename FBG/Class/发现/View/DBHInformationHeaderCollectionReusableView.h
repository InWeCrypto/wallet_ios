//
//  DBHInformationHeaderCollectionReusableView.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/30.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickRoastingChartBlock)(NSInteger clickRoastingChartBlockIndex);
typedef void(^ClickNewsBlock)(NSString *url);

@interface DBHInformationHeaderCollectionReusableView : UICollectionReusableView

/**
 轮播图数据
 */
@property (nonatomic, copy) NSArray *dataSource;

/**
 新闻数据
 */
@property (nonatomic, copy) NSArray *newsDataSource;

/**
 点击轮播图回调
 */
- (void)clickRoastingChartBlock:(ClickRoastingChartBlock)clickRoastingChartBlock;

/**
 点击新闻回调
 */
- (void)clickNewsBlock:(ClickNewsBlock)clickNewsBlock;

@end
