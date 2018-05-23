//
//  YYRedPacketDetailTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketDetailTableViewCell.h"

@interface YYRedPacketDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation YYRedPacketDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(YYRedPacketDetailModel *)model redbagCellType:(RedBagCellType)cellType index:(NSInteger)index {
    if (!model) {
        return;
    }
    
    self.addressLabel.textColor = COLORFROM16(0x333333, 1);
    self.timeLabel.textColor = COLORFROM16(0xACACAC, 1);
    self.priceLabel.textColor = COLORFROM16(0x333333, 1);
    
    RedBagStatus status = model.status;
    self.statusLabel.hidden = NO;
    
    switch (cellType) {
        case RedBagCellTypeCashPackage: { // 礼金打包
            self.addressLabel.text = model.redbag_addr;
            
            NSString *timeStr = model.auth_at;
            self.timeLabel.text = [NSString formatTimeDelayEight:timeStr];
            
            NSString *number = [NSString notRounding:model.redbag afterPoint:4];
            self.priceLabel.text = [NSString stringWithFormat:@"-%.4lf%@", number.doubleValue, model.redbag_symbol];
            
            NSString *statusStr = @"Success";
            if (status == RedBagStatusCashAuthPending) {
                statusStr = @"Packing…";
            } else if (status == RedBagStatusCashPackageFailed) {
                statusStr = @"Failed";
            }
            self.statusLabel.text = DBHGetStringWithKeyFromTable(statusStr, nil);
            break;
        }
        case RedBagCellTypeHanldeFee: { // 手续费
            self.addressLabel.text = model.fee_addr;
            
            NSString *timeStr = model.redbag_at;
            self.timeLabel.text = [NSString formatTimeDelayEight:timeStr];
            
            NSString *number = [NSString notRounding:model.fee afterPoint:8];
            self.priceLabel.text = [NSString stringWithFormat:@"-%.8lfETH", number.doubleValue];
            
            NSString *statusStr = @"Success";
            
           if (status == RedBagStatusCreateFailed) {
                statusStr = @"Failed";
            } else if (status == RedBagStatusCreatePending) {
                statusStr = @"Paying…";
            }
            self.statusLabel.text = DBHGetStringWithKeyFromTable(statusStr, nil);
            break;
        }
        case RedBagCellTypeDrawNum: { // 领取数量
            self.statusLabel.hidden = YES;
            
            NSArray *draws = model.draws;
            BOOL isSelfDraw = NO;
            if (draws.count > 0 && index < draws.count) {
                YYRedPacketDrawModel *draw = draws[index];
                
                if (![NSObject isNulllWithObject:self.drawAddress] && ![NSObject isNulllWithObject:draw.draw_addr]) {
                    if ([[self.drawAddress lowercaseString] isEqualToString:[draw.draw_addr lowercaseString]]) {
                        isSelfDraw = YES;
                    }
                }
                
                NSString *value = draw.value;
                
                NSString *price = [NSString stringWithFormat:@"***%@", model.redbag_symbol];
                
                if (model.done == RedBagLotteryStatusEnd && ![value isEqualToString:@"-"]) { // 开奖结束 且 领取金额已知
                    NSString *drawValue = [NSString convertValue:value decimals:model.gnt_category.decimals];
                    
                    NSString *number = [NSString notRounding:drawValue afterPoint:4];
                    price = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, model.redbag_symbol];
                }
                
                self.priceLabel.text = price;
                
                NSString *timeStr = draw.created_at;
                self.timeLabel.text = [NSString formatTimeDelayEight:timeStr];
                
                self.addressLabel.text = draw.draw_addr;
                
                if (isSelfDraw) {
                    self.addressLabel.textColor = COLORFROM16(0x4A90E2, 1);
                    self.timeLabel.textColor = COLORFROM16(0x4A90E2, 1);
                    self.priceLabel.textColor = COLORFROM16(0x4A90E2, 1);
                }
            }
            break;
        }
        case RedBagCellTypeBackNum: { // 撤回数量
            self.addressLabel.text = model.redbag_addr;
            
            NSString *timeStr = model.redbag_back_at;
            self.timeLabel.text = [NSString formatTimeDelayEight:timeStr];
            
            NSString *backValue = model.redbag_back;
            if ([backValue isEqualToString:@"-"]) {
                backValue = @"0";
            } else {
                backValue = [NSString convertValue:backValue decimals:model.gnt_category.decimals];
            }
            
            NSString *number = [NSString notRounding:backValue afterPoint:4];
            self.priceLabel.text = [NSString stringWithFormat:@"+%.4lf%@", number.doubleValue, model.redbag_symbol];
            
            NSString *statusStr = @"Success";
            RedBagTXStatus backStatus = model.redbag_back_tx_status;
            if (backStatus == RedBagTXStatusPending) {
                statusStr = @"Processing…";
            } else if (backStatus == RedBagTXStatusOpenFailed) {
                statusStr = @"Failed";
            }
            self.statusLabel.text = DBHGetStringWithKeyFromTable(statusStr, nil);
        }
        break;
    }
}


- (void)setIsLastCellInSection:(BOOL)isLastCellInSection {
    if (_isLastCellInSection == isLastCellInSection) {
        return;
    }
    
    _isLastCellInSection = isLastCellInSection;
    self.bottomLineView.hidden = isLastCellInSection;
}

@end
