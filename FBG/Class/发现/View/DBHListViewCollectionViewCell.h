//
//  DBHListViewCollectionViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/17.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHListViewCollectionViewCell : UICollectionViewCell

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 是否选中
 */
@property (nonatomic, assign) BOOL isSelected;

@end
