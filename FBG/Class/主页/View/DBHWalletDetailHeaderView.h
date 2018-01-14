//
//  DBHWalletDetailHeaderView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBHWalletManagerForNeoModelList;

typedef void(^ClickButtonBlock)(NSInteger index);

@interface DBHWalletDetailHeaderView : UIView

/**
 Neo钱包
 */
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *neoWalletModel;

/**
 资产
 */
@property (nonatomic, copy) NSString *asset;

/**
 点击按钮回调
 */
- (void)clickButtonBlock:(ClickButtonBlock)clickButtonBlock;

@end
