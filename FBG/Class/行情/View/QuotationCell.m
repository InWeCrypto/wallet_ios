//
//  QuotationCell.m
//  FBG
//
//  Created by mac on 2017/7/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "QuotationCell.h"

#import "DBHQuotationVCDataModels.h"

@implementation QuotationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DBHQuotationVCModelData *)model
{
    _model = model;
    self.titleLB.text = [model.enName uppercaseString];
//    self.typeLB.text = model.source;
    self.usdLB.text = [NSString stringWithFormat:@"$%.2f",[model.timeData.priceUsd floatValue]];
    self.rmbLB.text = [NSString stringWithFormat:@"￥%.2f",[model.timeData.priceCny floatValue]];
    if ([model.timeData.change24h floatValue] < 0)
    {
        self.changeLB.text = [NSString stringWithFormat:@"%.2lf%%",model.timeData.change24h.floatValue];
        self.changeLB.backgroundColor = [UIColor redColor];
    }
    else
    {
        self.changeLB.backgroundColor = [UIColor colorWithHexString:@"008C55"];
        self.changeLB.text = [NSString stringWithFormat:@"+%.2lf%%",model.timeData.change24h.floatValue];
    }
    
    if ([UserSignData share].user.walletUnitType == 1)
    {
        self.hightLB.text = [NSString stringWithFormat:@"￥%.2f",[model.timeData.maxPriceCny24h floatValue]];
        self.lowLB.text = [NSString stringWithFormat:@"￥%.2f",[model.timeData.minPriceCny24h floatValue]];
        self.numberLB.text = [NSString stringWithFormat:@"￥%@", [NSString getDealNumwithstring:model.timeData.volumeCny24h]];
    }
    else
    {
        self.hightLB.text = [NSString stringWithFormat:@"$%.2f",[model.timeData.maxPriceUsd24h floatValue]];
        self.lowLB.text = [NSString stringWithFormat:@"$%.2f",[model.timeData.minPriceUsd24h floatValue]];
        self.numberLB.text = [NSString stringWithFormat:@"$%@", [NSString getDealNumwithstring:model.timeData.volumeUsd24h]];
    }
    
    
}

@end
