//
//  WalletHeaderView.m
//  FBG
//
//  Created by mac on 2017/7/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "WalletHeaderView.h"

@implementation WalletHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    self.totleLB.text = NSLocalizedString(@"Total Assets", nil);
}

@end
