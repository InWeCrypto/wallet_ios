//
//  DBHCreateWalletWithNameViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@interface DBHCreateWalletWithNameViewController : DBHBaseViewController

/**
 钱包类型 1:ETH 2:NEO
 */
@property (nonatomic, assign) NSInteger walletType;

/**
 地址
 */
@property (nonatomic, copy) NSString *address;

@end
