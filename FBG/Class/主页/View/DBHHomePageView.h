//
//  DBHHomePageView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickButtonBlock)(NSInteger type);

@interface DBHHomePageView : UIView

/**
 总资产
 */
@property (nonatomic, copy) NSString *totalAsset;

/**
 头像地址
 */
@property (nonatomic, copy) NSString *headImageUrl;

/**
 点击按钮回调
 */
- (void)clickButtonBlock:(ClickButtonBlock)clickButtonBlock;

@end
