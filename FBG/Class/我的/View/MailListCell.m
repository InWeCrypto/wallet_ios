//
//  MailListCell.m
//  FBG
//
//  Created by mac on 2017/7/22.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "MailListCell.h"

@implementation MailListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MailMdel *)model
{
    _model = model;
    self.headerImage.image = [UIImage imageNamed:model.img];
    self.nameLB.text = model.name;
    self.addressLB.text = model.address;
}

@end
