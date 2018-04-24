//
//  YYChoosePayStyleTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYChoosePayStyleTableViewCell.h"

@interface YYChoosePayStyleTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxUseLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation YYChoosePayStyleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
