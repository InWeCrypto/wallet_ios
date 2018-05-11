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

@end

@implementation YYRedPacketSucessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _topHeight.constant = STATUS_HEIGHT;
    self.statusLabel.text = @"";
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"The Red Packet will be launched in 24H, Please keep watching the info of your wallet", nil);
}

- (void)setModel:(YYRedPacketOpenedModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    NSString *sender = model.redbag.share_user;
    self.statusLabel.text = OPENED_REDPACKET(sender);
    
    self.addressLabel.text = model.redbag_addr;
    
    RedBagLotteryStatus done = model.redbag.done;
    
    NSString *value = model.value;
    
    NSString *price = [NSString stringWithFormat:@"???%@", model.redbag.redbag_symbol];
    
    if (done == RedBagLotteryStatusEnd && ![value isEqualToString:@"-"]) { // 开奖结束 且 领取金额已知
        self.tipLabel.hidden = YES;
        NSString *drawValue = [self convertDrawValue:value decimals:model.redbag.gnt_category.decimals];
        
        NSString *number = [NSString notRounding:drawValue afterPoint:4];
        price = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, model.redbag.redbag_symbol];
    } else {
        self.tipLabel.hidden = NO;
    }
    
    self.priceLabel.text = price;
    
}

- (NSString *)convertDrawValue:(NSString *)value decimals:(NSInteger)decimals {
    NSString *drawValue = value;
    if (![NSObject isNulllWithObject:drawValue]) {
        if ([drawValue hasPrefix:@"0x"] && drawValue.length > 2) {
            drawValue = [drawValue substringFromIndex:2];
        }
        
        drawValue = [NSString numberHexString:drawValue];
        
        drawValue = [NSString DecimalFuncWithOperatorType:3 first:drawValue secend:@(pow(10, decimals)) value:0];
        
    }
    return drawValue;
}

@end
