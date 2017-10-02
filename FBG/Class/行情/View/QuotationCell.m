//
//  QuotationCell.m
//  FBG
//
//  Created by mac on 2017/7/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "QuotationCell.h"

@implementation QuotationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(QuotationModel *)model
{
    _model = model;
    self.titleLB.text = model.name;
    self.typeLB.text = model.source;
    self.usdLB.text = [NSString stringWithFormat:@"$%.2f",[model.relationCap.price_usd floatValue]];
    self.rmbLB.text = [NSString stringWithFormat:@"￥%.2f",[model.relationCap.price_cny floatValue]];
    if ([model.relationCap.percent_change_24h floatValue] < 0)
    {
        self.changeLB.text = [NSString stringWithFormat:@"%@%%",model.relationCap.percent_change_24h];
        self.changeLB.backgroundColor = [UIColor colorWithHexString:@"FB5A67"];
    }
    else
    {
        self.changeLB.backgroundColor = [UIColor colorWithHexString:@"66B7FB"];
        self.changeLB.text = [NSString stringWithFormat:@"+%@%%",model.relationCap.percent_change_24h];
    }
    
    if ([UserSignData share].user.walletUnitType == 1)
    {
        self.hightLB.text = [NSString stringWithFormat:@"￥%.2f",[model.relationCapMin.price_cny_high floatValue]];
        self.lowLB.text = [NSString stringWithFormat:@"￥%.2f",[model.relationCapMin.price_cny_low floatValue]];
        self.numberLB.text = [NSString getDealNumwithstring:model.relationCap.volume_cny_24h];
    }
    else
    {
        self.hightLB.text = [NSString stringWithFormat:@"$%.2f",[model.relationCapMin.price_usd_high floatValue]];
        self.lowLB.text = [NSString stringWithFormat:@"$%.2f",[model.relationCapMin.price_usd_low floatValue]];
        self.numberLB.text = [NSString getDealNumwithstring:model.relationCap.volume_usd_24h];
    }
    
    
}

@end
