//
//  WalletLeiftView.h
//  FBG
//
//  Created by mac on 2017/7/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletLeiftView : UIView

@property (weak, nonatomic) IBOutlet UIButton *addWalletButton;
@property (weak, nonatomic) IBOutlet UIButton *importWalletButton;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIView *scanView;
@property (weak, nonatomic) IBOutlet UIView *scanLineView;
@property (weak, nonatomic) IBOutlet UIView *hotLineView;

@end
