//
//  ICOCell.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/3.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "ICOCell.h"

@implementation ICOCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ICOListModel *)model
{
    _model = model;
    [self.headImage sdsetImageWithURL:model.img placeholderImage:Default_General_Image];
    self.statusLB.text = @"参数判断未明";
    self.titleLB.text = model.title;
    self.typeLB.text =  model.intro;
    self.timeLB.text = [NSString stringWithFormat:@"剩余 %@",@"判断未明"];
}

@end
