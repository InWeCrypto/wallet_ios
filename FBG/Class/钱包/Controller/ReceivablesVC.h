//
//  ReceivablesVC.h
//  FBG
//
//  Created by mac on 2017/7/19.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletLeftListModel.h"
#import "WalletInfoGntModel.h"

@interface ReceivablesVC : UIViewController

@property (nonatomic, strong) WalletLeftListModel * model;
@property (nonatomic, strong) WalletInfoGntModel * tokenModel;

@end
