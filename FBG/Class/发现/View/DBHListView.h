//
//  DBHListView.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/17.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHListView : UIView

/**
 标题数组
 */
@property (nonatomic, copy) NSArray *titleArray;

/**
 选中下标
 */
@property (nonatomic, assign) NSInteger selectedIndex;

@end
