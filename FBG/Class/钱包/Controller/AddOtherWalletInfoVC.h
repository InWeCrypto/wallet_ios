//
//  KeyStoreVC.h
//  FBG
//
//  Created by mac on 2017/7/27.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletTypeModel.h"
#import "WalletLeftListModel.h"

@interface AddOtherWalletInfoVC : UIViewController

/*
 1  Keystore
 2  助记词
 3  私匙
 4  观察
 5  种子
 */
@property (nonatomic, assign) int type;
@property (nonatomic, strong) WalletTypeModel * model;
@property (nonatomic, assign) BOOL islookWallet;
//转化钱包模型
@property (nonatomic, strong) WalletLeftListModel * walletModel;


@end
