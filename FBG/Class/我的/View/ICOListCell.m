//
//  ICOListCell.m
//  FBG
//
//  Created by mac on 2017/7/24.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "ICOListCell.h"

@implementation ICOListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ICOOrderListModel *)model
{
    _model = model;
    self.titileLB.text = model.title;
    self.timeLB.text = model.created_at;
    self.priceLB.text = model.fee;
    self.typeLB.text = model.cny;
}

@end
