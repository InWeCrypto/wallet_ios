//
//  AddQuotesCell.m
//  FBG
//
//  Created by mac on 2017/7/28.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddQuotesCell.h"

#import "AddQuotesVCDataModels.h"

@implementation AddQuotesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(AddQuotesVCModelData *)model
{
    _model = model;
//    [self.headImage sdsetImageWithURL:model.url placeholderImage:Default_General_Image];
    self.titleLB.text = [model.enName uppercaseString];
}

@end
