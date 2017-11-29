//
//  DBHLookPrivateKeyViewController.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/23.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WalletLeftListModel;
@class WalletInfoGntModel;

@interface DBHLookPrivateKeyViewController : UIViewController

@property (nonatomic, strong) WalletLeftListModel * model;

@property (nonatomic, strong) WalletInfoGntModel * tokenModel;

@end
