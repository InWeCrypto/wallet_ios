//
//  WalletLeiftCell.m
//  FBG
//
//  Created by mac on 2017/7/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "WalletLeiftCell.h"

@implementation WalletLeiftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WalletLeftListModel *)model
{
    _model = model;
    self.headImage.image = [UIImage imageNamed:model.img];

    self.nameLB.text = model.name;
    if (model.isLookWallet)
    {
        self.statusLB.text = @"观察";
        self.statusLB.backgroundColor = [UIColor colorWithHexString:@"66B7FB"];
        self.statusLB.hidden = NO;
    }
    else if (model.isNotBackupsWallet)
    {
        self.statusLB.text = @"未备份";
        self.statusLB.backgroundColor = [UIColor colorWithHexString:@"FB5A67"];
        self.statusLB.hidden = NO;
    }
    else
    {
        self.statusLB.hidden = YES;
    }
    
    
}

@end
