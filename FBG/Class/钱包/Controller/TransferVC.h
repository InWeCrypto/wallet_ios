//
//  TransferVC.h
//  FBG
//
//  Created by mac on 2017/7/19.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletLeftListModel.h"
#import "WalletInfoGntModel.h"

@interface TransferVC : UIViewController

@property (nonatomic, strong) WalletLeftListModel * model;
@property (nonatomic, strong) WalletInfoGntModel * tokenModel;
@property (nonatomic, assign) int defaultGasNum;   //默认gas数量

@property (nonatomic, copy) NSString * banlacePrice;
@property (nonatomic, copy) NSString * walletBanlacePrice;
@property (nonatomic, assign) BOOL istokenWallet;
@end
