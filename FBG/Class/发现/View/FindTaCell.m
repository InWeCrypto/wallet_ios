//
//  FindTaCell.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/3.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "FindTaCell.h"

@implementation FindTaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FindArticleModel *)model
{
    _model = model;
    self.titleLB.text = model.title;
    self.timeLB.text = model.created_at;
    self.infoLB.text = model.desc;
}

@end
