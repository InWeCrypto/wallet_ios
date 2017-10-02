//
//  WalletHomeCell.m
//  FBG
//
//  Created by mac on 2017/7/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "WalletHomeCell.h"

@implementation WalletHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WalletInfoGntModel *)model
{
    _model = model;
    
    if ([model.balance isEqualToString:@"0"])
    {
        model.balance = @"0.0000";
    }
    
    [self.headerImage sdsetImageWithURL:model.icon placeholderImage:Default_General_Image];
    self.titleLB.text = model.name;
//    NSString * ether = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[model.balance substringFromIndex:2]] secend:@"1000000000000000000"];
    self.priceLB.text = [NSString stringWithFormat:@"%.4f",[model.balance floatValue]];
    if ([UserSignData share].user.walletUnitType == 1)
    {
        self.otherPriceLB.text = [NSString stringWithFormat:@"≈￥%.2f",[[NSString DecimalFuncWithOperatorType:2 first:model.balance secend:model.price_cny value:2] floatValue]];
    }
    else
    {
        self.otherPriceLB.text = [NSString stringWithFormat:@"≈$%.2f",[[NSString DecimalFuncWithOperatorType:2 first:model.balance secend:model.price_usd value:2] floatValue]];
    }
    
}

@end
