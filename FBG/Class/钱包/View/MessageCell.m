//
//  MessageCell.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/9.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MessageModel *)model
{
    _model = model;
    self.titleLB.text = model.title;
    self.infoLB.text = model.content;
    self.timeLB.text = model.created_at;
}

@end
