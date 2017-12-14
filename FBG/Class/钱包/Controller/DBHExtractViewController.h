//
//  DBHExtractViewController.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WalletInfoGntModel;

@interface DBHExtractViewController : UIViewController

@property (nonatomic, copy) NSString *wallectId;

@property (nonatomic, strong) WalletInfoGntModel *neoModel;

@property (nonatomic, strong) WalletInfoGntModel *model;

@end
