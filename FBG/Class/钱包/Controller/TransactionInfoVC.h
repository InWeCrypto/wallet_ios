//
//  TransactionInfoVC.h
//  FBG
//
//  Created by mac on 2017/7/20.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletOrderModel.h"

@interface TransactionInfoVC : UIViewController

@property (nonatomic, assign) BOOL isTransfer;  // YES 转账  NO 收款
@property (nonatomic, strong) WalletOrderModel * model;

@property (nonatomic, assign) BOOL isNotPushWithList;  // yes  是从转账流程过来的


@end
