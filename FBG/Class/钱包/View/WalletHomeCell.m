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
    
//    if (model.balance.floatValue == 0)
//    {
//        model.balance = @"0.0000";
//    }
    
    self.headerImage.contentMode = UIViewContentModeCenter;
    if ([model.icon containsString:@"NEO_"] || [model.icon containsString:@"ETH"]) {
        self.headerImage.image = [UIImage imageNamed:model.icon];
    } else {
        [self.headerImage sdsetImageWithURL:model.icon placeholderImage:Default_General_Image];
    }
    self.titleLB.text = model.name;
//    NSString * ether = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[model.balance substringFromIndex:2]] secend:@"1000000000000000000"];
    if ([_model.name isEqualToString:@"NEO"]) {
        self.priceLB.text = [NSString stringWithFormat:@"%.0f",[model.balance floatValue]];
    } else if ([_model.name isEqualToString:@"Gas"] || [_model.name isEqualToString:@"可提现Gas"]) {
        self.priceLB.text = [NSString stringWithFormat:@"%.8f",[model.balance floatValue]];
    } else {
        self.priceLB.text = [NSString stringWithFormat:@"%.4f",[model.balance floatValue]];
    }
    if ([UserSignData share].user.walletUnitType == 1)
    {
        self.otherPriceLB.text = [NSString stringWithFormat:@"≈￥%.2lf", model.price_cny.floatValue];
    }
    else
    {
        self.otherPriceLB.text = [NSString stringWithFormat:@"≈$%.2lf", model.price_usd.floatValue];
    }
    
}

@end
