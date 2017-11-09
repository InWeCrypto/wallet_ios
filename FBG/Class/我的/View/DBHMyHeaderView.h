//
//  DBHMyHeaderView.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/9.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickButtonBlock)();

@interface DBHMyHeaderView : UIView

/**
 头像
 */
@property (nonatomic, strong) UIImageView *headImageView;

/**
 姓名
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 点击按钮回调

 @param clickButtonBlock 1:编辑 2:头像
 */
- (void)clickButtonBlock:(ClickButtonBlock)clickButtonBlock;

@end
