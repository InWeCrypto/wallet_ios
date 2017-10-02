//
//  WalletInfoHeaderView.m
//  FBG
//
//  Created by mac on 2017/7/17.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "WalletInfoHeaderView.h"

@implementation WalletInfoHeaderView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)drawRect:(CGRect)rect
{
    self.headImage.layer.cornerRadius = 22;
    self.headImage.layer.masksToBounds = YES;
}

@end
