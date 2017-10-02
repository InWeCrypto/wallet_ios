//
//  AddOtherWalletVC.h
//  FBG
//
//  Created by mac on 2017/7/27.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletTypeModel.h"
#import "WalletLeftListModel.h"

@interface AddOtherWalletVC : UIViewController

@property (nonatomic, strong) WalletTypeModel * model;
@property (nonatomic, assign) BOOL islookWallet;
//转化钱包模型
@property (nonatomic, strong) WalletLeftListModel * walletModel;

@end
