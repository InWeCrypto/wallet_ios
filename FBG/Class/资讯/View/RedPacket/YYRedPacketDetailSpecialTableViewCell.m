//
//  YYRedPacketDetailSpecialTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketDetailSpecialTableViewCell.h"

#define FEES_TEXT(fees) [NSString stringWithFormat:@"%@：%@ETH", DBHGetStringWithKeyFromTable(@"Fees", nil), fees]

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

@property (nonatomic, assign) BOOL canShare;
@property (nonatomic, assign) RedBagStatus status;

@end

@implementation YYRedPacketDetailSpecialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _topHeight.constant = STATUS_HEIGHT;
    
    self.feesLabel.text = FEES_TEXT(@0);
    self.senderAddrTitleLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Sender's Wallet Address", nil)];
    self.createTimeTitleLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Create Time", nil)];
    
    NSString *text = DBHGetStringWithKeyFromTable(@"Money in expired red packet will be saved to your Balance After 24H", nil);
    
    NSRange range = [text localizedStandardRangeOfString:@"24H"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xE24C0A, 1) range:range];
    
    self.tipLabel.attributedText = attributedString;
    
    [self.lookBtn setCorner:2];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToCopyAddressLabel:)];
    [self.senderAddrLabel addGestureRecognizer:longPressGR];
}

- (void)setModel:(YYRedPacketDetailModel *)model {
    _model = model;
    
    NSString *number = [NSString notRounding:model.redbag afterPoint:8];
    self.priceLabel.text = [NSString stringWithFormat:@"%.8lf%@", number.doubleValue, model.redbag_symbol];
//    self.statusLabel.text = DBHGetStringWithKeyFromTable(model.done ? @"Done" : @"Sending", nil);
//    self.canShare = !model.done;
    
    
    
    self.feesLabel.text = FEES_TEXT(model.fee);
    
    self.senderAddrLabel.text = model.redbag_addr;
    self.txidLabel.text = model.redbag_tx_id;
    self.createTimeLabel.text = model.created_at;
}

- (void)setCanShare:(BOOL)canShare {
    _canShare = canShare;
    
    NSString *title = DBHGetStringWithKeyFromTable(@"Look Up Red Packet", nil);
    if (canShare) {
        title = DBHGetStringWithKeyFromTable(@"Look Up And Share Red Packet", nil);
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
