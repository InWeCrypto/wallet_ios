//
//  WalletNameVC.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/10.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletTypeModel.h"

@interface WalletNameVC : UIViewController

@property (nonatomic, strong) WalletTypeModel * model;
@property (nonatomic, strong) UnichainETHWallet * wallet;
@property (nonatomic, copy) NSString * address;

@end
