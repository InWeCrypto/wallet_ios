//
//  YYRedPacketDetailSpecialTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketDetailSpecialTableViewCell.h"

#define FEES_TEXT(fees) [NSString stringWithFormat:@"%@：%.8lfETH", DBHGetStringWithKeyFromTable(@"Fees", nil), fees]

#define TIPLABEL_HEIGHT 29

@interface YYRedPacketDetailSpecialTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *iconBgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *feesLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderAddrTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *txidLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLabelHeight;

@property (nonatomic, assign) BOOL canShare;
@property (nonatomic, assign) RedBagStatus status;

@end

@implementation YYRedPacketDetailSpecialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _topHeight.constant = STATUS_HEIGHT;
    
    self.feesLabel.text = FEES_TEXT(0.0);
    self.senderAddrTitleLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Sender's Wallet Address", nil)];
    self.createTimeTitleLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Creation Time", nil)];
    
    NSString *text = DBHGetStringWithKeyFromTable(@"Red Packets not open within 24H will be refunded", nil);
    
    NSRange range = [text localizedStandardRangeOfString:@"24H"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xE24C0A, 1) range:range];
    
    self.tipLabel.attributedText = attributedString;
    
    [self.lookBtn setCorner:2];
    self.lookBtn.enabled = NO;
    
    [self.lookBtn setBackgroundColor:COLORFROM16(0xD5D5D5, 1) forState:UIControlStateDisabled];
    [self.lookBtn setBackgroundColor:COLORFROM16(0xEA6204, 1) forState:UIControlStateNormal];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToCopyAddressLabel:)];
    [self.senderAddrLabel addGestureRecognizer:longPressGR];
    [UIView setRoundForView:self.iconBgView borderColor:COLORFROM16(0xF2E6BC, 1)];
}

- (void)setModel:(YYRedPacketDetailModel *)model {
    if (!model) {
        return;
    }
    _model = model;
    
    [self.iconImgView sdsetImageWithURL:model.gnt_category.icon placeholderImage:[UIImage imageNamed:@"ETH_add"]];
    
    NSString *number = [NSString notRounding:model.redbag afterPoint:4];
    self.priceLabel.text = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, model.redbag_symbol];
    
    self.status = model.status;
    
    NSString *failedTipStr = DBHGetStringWithKeyFromTable(@",need to recreate redpacket.Please contact us if you have any questions.", nil);
    switch (self.status) {
        case RedBagStatusDone: {
            self.lookBtn.enabled = YES;
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Completed", nil));
            break;
        }
        case RedBagStatusCashPackaging: {
            self.lookBtn.enabled = YES;
            // 礼金打包中
            NSString *statusStr = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Packaging Assets", nil));
            if (model.auth_block != 0) {
                NSInteger block = model.current_block - model.auth_block + 1;
                if (block >= 12) { // 礼金打包成功
                    statusStr = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Packet preparation sucessful", nil));
                }
            }
            
            self.statusLabel.text = statusStr;
            break;
        }
        case RedBagStatusCreating: {
            self.lookBtn.enabled = YES;
            // 红包创建中
            NSString *statusStr = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Creating Red Packet", nil));
            if (model.redbag_block != 0) {
                NSInteger block = model.current_block - model.redbag_block + 1;
                if (block >= 12) { // 红包创建成功
                    statusStr = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Red Packet creation successful", nil));
                }
            }
            
            self.statusLabel.text = statusStr;
            break;
        }
            
        case RedBagStatusOpening: {
            self.lookBtn.enabled = YES;
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Openning", nil));
            break;
        }
            
        case RedBagStatusCashPackageFailed: { // 打包失败
            NSString *text = [DBHGetStringWithKeyFromTable(@"Packing Failed", nil) stringByAppendingString:failedTipStr];
            
            NSRange range = [text localizedStandardRangeOfString:DBHGetStringWithKeyFromTable(@"Failed", nil)];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
            
            self.tipLabel.attributedText = attributedString;
            
            self.lookBtn.enabled = NO;
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Packing Failed", nil));
            
            break;
        }
            
        case RedBagStatusCreateFailed: { // 创建失败
            NSString *text = [DBHGetStringWithKeyFromTable(@"Creation Failed", nil) stringByAppendingString:failedTipStr];
            
            NSRange range = [text localizedStandardRangeOfString:DBHGetStringWithKeyFromTable(@"Failed", nil)];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
            
            self.tipLabel.attributedText = attributedString;
            
            self.lookBtn.enabled = NO;
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Creation Failed", nil));
            
            break;
        }
            
        case RedBagStatusCashAuthPending: { // 准备打包
            self.lookBtn.enabled = YES;
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@" Packing… ", nil));
            
            break;
        }
            
        case RedBagStatusCreatePending: { // 准备创建红包
            self.lookBtn.enabled = YES;
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Creating the Red Packet", nil));
            break;
        }
    }
    
    self.canShare = (self.status == RedBagStatusOpening);
    
    NSString *fee = model.fee;
    if ([NSObject isNulllWithObject:fee]) {
        fee = @"0.0";
    }
    number = [NSString notRounding:fee afterPoint:8];
    self.feesLabel.text = FEES_TEXT(number.doubleValue);
    
    self.senderAddrLabel.text = model.redbag_addr;
    self.txidLabel.text = model.redbag_tx_id;
    self.createTimeLabel.text = [NSString formatTimeDelayEight:model.created_at];
    
    if (self.status == RedBagStatusOpening ||
        self.status == RedBagStatusDone ||
        self.status == RedBagStatusCreateFailed ||
        self.status == RedBagStatusCashPackageFailed) {
        _tipLabelHeight.constant = REDPACKET_ADD_HEIGHT;
    } else {
        _tipLabelHeight.constant = 0;
    }
}

- (void)setCanShare:(BOOL)canShare {
    _canShare = canShare;
    
    NSString *title = DBHGetStringWithKeyFromTable(@"Open the Red Packet", nil);
    if (canShare) {
        title = DBHGetStringWithKeyFromTable(@"Open and Share Red Packet", nil);
    }
    [self.lookBtn setTitle:title forState:UIControlStateNormal];
    
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToLookBtn:(UIButton *)sender {
    if (self.block) {
        self.block(self.status);
    }
}

/**
 长按地址复制
 */
- (void)respondsToCopyAddressLabel:(UILongPressGestureRecognizer *)recognizer {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    UILabel *label = (UILabel *)recognizer.view;
    
    pasteboard.string = label.text;
    [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Copy success, you can send it to friends", nil)];
}
@end
