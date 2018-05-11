//
//  YYRedPacketSection0TableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSection0TableViewCell.h"
#import "YYRedPacketSentCountModel.h"

#define REDPACKET_COUNT(count) [NSString stringWithFormat:@"%ld%@", count, DBHGetStringWithKeyFromTable(@" Packet ", nil)]

@interface YYRedPacketSection0TableViewCell()

/** 我发送的红包 */
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel1;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel2;

/** 创建中 */
@property (weak, nonatomic) IBOutlet UILabel *createLabel;
@property (weak, nonatomic) IBOutlet UILabel *createValueLabel;

/** 发送中 */
@property (weak, nonatomic) IBOutlet UILabel *sendingValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendingLabel;

/** 成功 */
@property (weak, nonatomic) IBOutlet UILabel *successLabel;
@property (weak, nonatomic) IBOutlet UILabel *successValueLabel;

/** 失败 */
@property (weak, nonatomic) IBOutlet UILabel *failedLabel;
@property (weak, nonatomic) IBOutlet UILabel *failedValueLabel;

/** 近期发送记录 */
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@end

@implementation YYRedPacketSection0TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    self.totalLabel1.text = DBHGetStringWithKeyFromTable(@"Total Sent ", nil);
    self.totalLabel2.text = DBHGetStringWithKeyFromTable(@" Red Packet", nil);
    
    self.sendingLabel.text = DBHGetStringWithKeyFromTable(@"Sending", nil);
    self.successLabel.text = DBHGetStringWithKeyFromTable(@"Success", nil);
    self.createLabel.text = DBHGetStringWithKeyFromTable(@"Creating", nil);
    self.failedLabel.text = DBHGetStringWithKeyFromTable(@"Failed", nil);
    self.recordLabel.text = DBHGetStringWithKeyFromTable(@"Recent Sending Records", nil);
    
    NSString *countStr = REDPACKET_COUNT(0l);
    self.sendingValueLabel.text = countStr;
    self.createValueLabel.text = countStr;
    self.failedValueLabel.text = countStr;
    self.successValueLabel.text = countStr;
    self.totalValueLabel.text = @"0";
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(YYRedPacketSentCountModel *)model {
    self.totalValueLabel.text = [NSString stringWithFormat:@"%@", @(model.all)];
    self.createValueLabel.text = REDPACKET_COUNT(model.create);
    self.sendingValueLabel.text = REDPACKET_COUNT(model.send);
    self.successValueLabel.text = REDPACKET_COUNT(model.success);
    self.failedValueLabel.text = REDPACKET_COUNT(model.fail);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
