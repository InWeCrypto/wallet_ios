//
//  DBHCandyBowlHeaderView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedDateBlock)(NSDate *date);

@interface DBHCandyBowlHeaderView : UIView

/**
 是否没有数据
 */
@property (nonatomic, assign) BOOL isNoData;

/**
 选择日期回调
 */
- (void)selectedDateBlock:(SelectedDateBlock)selectedDateBlock;

@end
