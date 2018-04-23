//
//  YYRedPacketSection0TableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSection0TableViewCell.h"

@interface YYRedPacketSection0TableViewCell()

/** 我发送的红包 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 合计 */
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;

/** 发送中 */
@property (weak, nonatomic) IBOutlet UILabel *sendingValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendingLabel;

/** 成功 */
@property (weak, nonatomic) IBOutlet UILabel *successValueLabel;

/** 近期发送记录 */
@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@end

@implementation YYRedPacketSection0TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
