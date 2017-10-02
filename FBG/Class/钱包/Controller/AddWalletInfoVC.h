//
//  AddWalletInfoVC.h
//  FBG
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletTypeModel.h"
#import "WalletLeftListModel.h"

@interface AddWalletInfoVC : UIViewController

@property (nonatomic, strong) WalletTypeModel * model;
@property (nonatomic, strong) UnichainETHWallet * ETHWallet;
//转化钱包模型
@property (nonatomic, strong) WalletLeftListModel * walletModel;

@end
