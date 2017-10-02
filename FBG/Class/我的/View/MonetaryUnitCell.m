//
//  MonetaryUnitCell.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/5.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "MonetaryUnitCell.h"

@implementation MonetaryUnitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(MonetaryUnitModel *)model
{
    _model = model;
    self.nameLB.text = model.name;
    self.typeImage.image = [UIImage imageNamed:model.name];
}

@end
