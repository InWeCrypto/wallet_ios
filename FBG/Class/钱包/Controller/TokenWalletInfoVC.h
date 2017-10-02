//
//  LookWalletInfoVC.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletLeftListModel.h"
#import "WalletInfoGntModel.h"

@interface TokenWalletInfoVC : UIViewController

@property (nonatomic, strong) WalletLeftListModel * model;
@property (nonatomic, strong) WalletInfoGntModel * tokenModel;
@property (nonatomic, copy) NSString * WalletbanlacePrice;

@end
