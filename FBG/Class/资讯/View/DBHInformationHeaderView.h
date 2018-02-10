//
//  DBHInformationHeaderView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectTypeBlock)();
typedef void(^ClickFunctionalUnitBlock)(NSInteger functionalUnitType);

@interface DBHInformationHeaderView : UIView

/**
 当前选中下标
 */
@property (nonatomic, assign) NSInteger currentSelectedIndex;

/**
 选择类型回调
 */
- (void)selectTypeBlock:(SelectTypeBlock)selectTypeBlock;

/**
 点击功能组件回调
 */
- (void)clickFunctionalUnitBlock:(ClickFunctionalUnitBlock)clickFunctionalUnitBlock;

/**
 停止动画
 */
- (void)stopAnimation;

@end
