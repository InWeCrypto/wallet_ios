//
//  AddTokenCell.m
//  FBG
//
//  Created by mac on 2017/7/20.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddTokenCell.h"

@implementation AddTokenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setModel:(WalletInfoGntModel *)model
{
    _model = model;
    
    [self.headImage sdsetImageWithURL:model.icon placeholderImage:Default_General_Image];
    self.titleLB.text = model.name;
}

@end
