//
//  DBHInformationDetailForInweReportSelectedView.h
//  FBG
//
//  Created by 邓毕华 on 2017/12/7.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedButtonBlock)(NSInteger currentSelectedIndex);

@interface DBHInformationDetailForInweReportSelectedView : UIView

@property (nonatomic, assign) NSInteger currentSelectedIndex; // 当前选中下标

/**
 选中按钮回调
 */
- (void)selectedButtonBlock:(SelectedButtonBlock)selectedButtonBlock;

@end
