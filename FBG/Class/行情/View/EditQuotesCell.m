//
//  EditQuotesCell.m
//  FBG
//
//  Created by mac on 2017/7/28.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "EditQuotesCell.h"

@implementation EditQuotesCell

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
    self.infoLB.text = model.source;
}

@end
