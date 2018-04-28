//
//  YYRedPacketSection0TableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSection0TableViewCell.h"

#define REDPACKET_COUNT(count) [NSString stringWithFormat:@"%ld%@", count, DBHGetStringWithKeyFromTable(@"  ", nil)]

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
    
    self.titleLabel.text = DBHGetStringWithKeyFromTable(@"My Sent Redpacket", nil);
    self.totalLabel.text = DBHGetStringWithKeyFromTable(@" Total ", nil);
    self.sendingLabel.text = DBHGetStringWithKeyFromTable(@"Sending", nil);
    self.successLabel.text = DBHGetStringWithKeyFromTable(@"Success", nil);
    self.recordLabel.text = DBHGetStringWithKeyFromTable(@"Sent Record Recently", nil);
    NSString *countStr = REDPACKET_COUNT(0l);
    self.sendingValueLabel.text = countStr;
    self.successValueLabel.text = countStr;
    
    [self setTotalTitle:0];
}

- (void)setTotalTitle:(NSInteger)count {
    NSString *countStr = REDPACKET_COUNT(count);
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:countStr];
    NSRange range = NSMakeRange(countStr.length - 2, 1);
    [attributeStr addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xC63437, 1) range:range];
    
    self.totalValueLabel.attributedText = attributeStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
