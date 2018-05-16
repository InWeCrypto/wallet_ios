//
//  YYRedPacketSucessTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSucessTableViewCell.h"

#define OPENED_REDPACKET(name) [NSString stringWithFormat:@"%@%@%@", DBHGetStringWithKeyFromTable(@"You have already opened the Packet", nil), name, DBHGetStringWithKeyFromTable(@"'s Red Packet", nil)]

@interface YYRedPacketSucessTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UIView *iconBgView;

@end

@implementation YYRedPacketSucessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _topHeight.constant = STATUS_HEIGHT;
    self.statusLabel.text = @"";
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"The Red Packet will be launched in 24H, Please keep watching the info of your wallet", nil);
    [UIView setRoundForView:self.iconBgView borderColor:COLORFROM16(0xF2E6BC, 1)];
}

- (void)setModel:(YYRedPacketOpenedModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    [self.iconImgView sdsetImageWithURL:model.redbag.gnt_category.icon placeholderImage:[UIImage imageNamed:@"ETH_add"]];
    
    NSString *sender = model.redbag.share_user;
    self.statusLabel.text = OPENED_REDPACKET(sender);
    
    self.addressLabel.text = model.redbag_addr;
    
    RedBagLotteryStatus done = model.redbag.done;
    
    NSString *value = model.value;
    
    NSString *price = [NSString stringWithFormat:@"???%@", model.redbag.redbag_symbol];
    
    if (done == RedBagLotteryStatusEnd && ![value isEqualToString:@"-"]) { // 开奖结束 且 领取金额已知
        self.tipLabel.hidden = YES;
        NSString *drawValue = [NSString convertValue:value decimals:model.redbag.gnt_category.decimals];
        
        NSString *number = [NSString notRounding:drawValue afterPoint:4];
        price = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, model.redbag.redbag_symbol];
    } else {
        self.tipLabel.hidden = NO;
    }
    
    self.priceLabel.text = price;
    
}

@end
