//
//  YYRedPacketSendFirstSection0Cell.m
//  FBG
//
//  Created by yy on 2018/4/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSendFirstSection0Cell.h"

@interface YYRedPacketSendFirstSection0Cell()

@property (weak, nonatomic) IBOutlet UILabel *title1Label;
@property (weak, nonatomic) IBOutlet UILabel *title2Label;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation YYRedPacketSendFirstSection0Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.title1Label.text = DBHGetStringWithKeyFromTable(@"First:", nil);
    self.title2Label.text = DBHGetStringWithKeyFromTable(@"Authorization For Use RedPacket", nil);
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"Choose Below Authorization", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
