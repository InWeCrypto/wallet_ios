//
//  DBHAddPropertyViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@class DBHWalletManagerForNeoModelList;

@interface DBHAddPropertyViewController : DBHBaseViewController

/**
 Neo钱包
 */
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *neoWalletModel;

@end
