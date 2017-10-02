//
//  FindCoCell.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/3.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "FindCoCell.h"

@implementation FindCoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(FindIcoModel *)model
{
    _model = model;
    [self.icoImage sdsetImageWithURL:model.img placeholderImage:Default_General_Image];
    self.titleLB.text = model.name;
}

@end
