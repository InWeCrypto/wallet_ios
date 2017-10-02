//
//  TransactionCell.m
//  FBG
//
//  Created by mac on 2017/7/20.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "TransactionCell.h"

@implementation TransactionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WalletOrderModel *)model
{
    _model = model;
    
    self.titleLB.text = model.trade_no;
    self.timeLB.text = model.finished_at;
    if (model.isReceivables)
    {
        self.priceLB.text = [NSString stringWithFormat:@"+%@",model.fee];
    }
    else
    {
        self.priceLB.text = [NSString stringWithFormat:@"-%@",model.fee];
    }
}

@end
