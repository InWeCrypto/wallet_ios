//
//  DBHSpinnerView.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/17.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickMoneyBlock)(NSInteger selectedMoneyType);

@interface DBHSpinnerView : UIView

/**
 标题数组
 */
@property (nonatomic, copy) NSArray *titleArray;

/**
 选择币种回调
 */
- (void)clickMoneyBlock:(ClickMoneyBlock)clickMoneyBlock;

@end
