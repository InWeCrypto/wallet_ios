//
//  WalletLeiftView.m
//  FBG
//
//  Created by mac on 2017/7/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "WalletLeiftView.h"



@implementation WalletLeiftView

- (void)drawRect:(CGRect)rect
{
    self.addButtonTop.constant = [UIApplication sharedApplication].statusBarFrame.size.height;
//    [self.addWalletButton setTitle:NSLocalizedString(@"Add Wallet", nil) forState:UIControlStateNormal];
//    [self.scanButton setTitle:NSLocalizedString(@"     Scan     ", nil) forState:UIControlStateNormal];
}
@end
