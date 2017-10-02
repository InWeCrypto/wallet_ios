//
//  TransactionListVC.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "CoustromViewController.h"
#import "WalletLeftListModel.h"
#import "WalletInfoGntModel.h"

@interface TransactionListVC : CoustromViewController

@property (nonatomic, strong) WalletLeftListModel * model;
@property (nonatomic, strong) WalletInfoGntModel * tokenModel;
@property (nonatomic, copy) NSString * banlacePrice;
@property (nonatomic, copy) NSString * cnybanlacePrice;
@property (nonatomic, copy) NSString * WalletbanlacePrice;

@end
