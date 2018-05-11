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
    
    self.feesLabel.text = FEES_TEXT(0);
    self.senderAddrTitleLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Sender's Wallet Address", nil)];
    self.createTimeTitleLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Creation Time", nil)];
    
    NSString *text = DBHGetStringWithKeyFromTable(@"Red Packets not open within 24H will be refunded", nil);
    
    NSRange range = [text localizedStandardRangeOfString:@"24H"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xE24C0A, 1) range:range];
    
    self.tipLabel.attributedText = attributedString;
    
    [self.lookBtn setCorner:2];
    
    [self.lookBtn setBackgroundColor:COLORFROM16(0xD5D5D5, 1) forState:UIControlStateDisabled];
    [self.lookBtn setBackgroundColor:COLORFROM16(0xEA6204, 1) forState:UIControlStateNormal];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToCopyAddressLabel:)];
    [self.senderAddrLabel addGestureRecognizer:longPressGR];
}

- (void)setModel:(YYRedPacketDetailModel *)model {
    if (!model) {
        return;
    }
    _model = model;
    
    NSString *number = [NSString notRounding:model.redbag afterPoint:4];
    self.priceLabel.text = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, model.redbag_symbol];
    
    self.status = model.status;
    switch (self.status) {
        case RedBagStatusDone: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Done", nil));
            self.lookBtn.enabled = YES;
            break;
        }
        case RedBagStatusCashPackaging: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Packet preparation successful", nil));
            self.lookBtn.enabled = YES;
            break;
        }
        case RedBagStatusCreating: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Red Packet creation successful", nil));
            self.lookBtn.enabled = YES;
            break;
        }
            
        case RedBagStatusOpening: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Sending", nil));
            self.lookBtn.enabled = YES;
            break;
        }
            
        case RedBagStatusCashPackageFailed: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Packing Failed", nil));
            self.lookBtn.enabled = NO;
            break;
        }
            
        case RedBagStatusCreateFailed: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Creation Failed", nil));
            self.lookBtn.enabled = NO;
            break;
        }
            
        case RedBagStatusCashAuthPending: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Packaging Assets", nil));
            self.lookBtn.enabled = YES;
            break;
        }
            
        case RedBagStatusCreatePending: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Creating Red Packet", nil));
            self.lookBtn.enabled = YES;
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
    
    if (self.status == RedBagStatusOpening || self.status == RedBagStatusDone) {
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
