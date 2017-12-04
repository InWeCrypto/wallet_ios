//
//  AC_WaterCollectionViewLayout.h
//  AC_UICollectionView
//
//  Created by FM-13 on 16/6/23.
//  Copyright © 2016年 cong. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const AC_UICollectionElementKindSectionHeader;
UIKIT_EXTERN NSString *const AC_UICollectionElementKindSectionFooter;

@class AC_WaterCollectionViewLayout;
@protocol AC_WaterCollectionViewLayoutDelegate <NSObject>

//代理取cell 的高
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AC_WaterCollectionViewLayout *)layout heightOfItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AC_WaterCollectionViewLayout *)layout widthOfItemAtIndexPath:(NSIndexPath *)indexPath;

//处理移动相关的数据源
- (void)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath;

@end

@interface AC_WaterCollectionViewLayout : UICollectionViewLayout

@property (assign, nonatomic) NSInteger numberOfColumns;//瀑布流有列
@property (assign, nonatomic) CGFloat cellDistance;//cell之间的间距
@property (assign, nonatomic) CGFloat topAndBottomDustance;//cell 到顶部 底部的间距
@property (assign, nonatomic) CGFloat headerViewHeight;//头视图的高度
@property (assign, nonatomic) CGFloat footViewHeight;//尾视图的高度

@property(nonatomic, weak) id<AC_WaterCollectionViewLayoutDelegate> delegate;

@end
