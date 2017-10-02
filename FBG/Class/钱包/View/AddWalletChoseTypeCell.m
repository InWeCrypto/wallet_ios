//
//  AddWalletChoseTypeCell.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/9.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddWalletChoseTypeCell.h"

@implementation AddWalletChoseTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WalletTypeModel *)model
{
    _model = model;
    [self.icoHeadeImage sdsetImageWithURL:model.icon placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_add",model.name]]];
    self.titleLB.text = model.name;
}

@end
