//
//  ConfirmationTransferVC.h
//  FBG
//
//  Created by mac on 2017/7/19.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletLeftListModel.h"
#import "WalletInfoGntModel.h"

@interface ConfirmationTransferVC : UIViewController

@property (nonatomic, strong) WalletLeftListModel * model;
@property (nonatomic, strong) WalletInfoGntModel * tokenModel;

@property (nonatomic, assign) BOOL isCodeWallet;
//转账订单生产
@property (nonatomic, assign) NSString * gasprice;  //单价
@property (nonatomic, copy) NSString * totleGasPrice;  //总手续费
@property (nonatomic, copy) NSString * nonce;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * remark;

@property (nonatomic, copy) NSString * ox_gas;
@property (nonatomic, copy) NSString * ox_Price;
@property (nonatomic, copy) NSString * gas_limit;

@end
