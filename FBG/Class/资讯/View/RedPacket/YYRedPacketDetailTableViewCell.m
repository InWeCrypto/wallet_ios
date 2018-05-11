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
            } else if (status == RedBagStatusCashPackageFailed || status == RedBagStatusCreateFailed) {
                statusStr = @"Failed";
            }
            self.statusLabel.text = DBHGetStringWithKeyFromTable(statusStr, nil);
            break;
        }
        case RedBagCellTypeHanldeFee: { // 手续费
            self.addressLabel.text = model.redbag_addr;
            
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
            if (draws.count > 0 && index < draws.count) {
                YYRedPacketDrawModel *draw = draws[index];
                
                NSString *timeStr = draw.created_at;
                self.timeLabel.text = [NSString formatTimeDelayEight:timeStr];
                
                NSString *drawValue = [self convertDrawValue:draw.value decimals:model.gnt_category.decimals];
                
                NSString *number = [NSString notRounding:drawValue afterPoint:4];
                self.priceLabel.text = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, model.redbag_symbol];
                
                self.addressLabel.text = draw.draw_addr;
            }
            break;
        }
        case RedBagCellTypeBackNum: { // 撤回数量
            self.addressLabel.text = model.redbag_addr;
            
            NSString *timeStr = model.redbag_back_at;
            self.timeLabel.text = [NSString formatTimeDelayEight:timeStr];
            
            NSString *number = [NSString notRounding:model.redbag_back afterPoint:4];
            self.priceLabel.text = [NSString stringWithFormat:@"+%.4lf%@", number.doubleValue, model.redbag_symbol];
            
            NSString *statusStr = @"Success";
            RedBagTXStatus backStatus = model.redbag_back_tx_status;
            if (backStatus == RedBagTXStatusPending) {
                statusStr = @"Processing…";
            } else if (backStatus == RedBagTXStatusOpenFailed) {
                statusStr = @"Failed";
            }
            self.statusLabel.text = DBHGetStringWithKeyFromTable(statusStr, nil);
            break;
        }
    }
}


- (void)setIsLastCellInSection:(BOOL)isLastCellInSection {
    if (_isLastCellInSection == isLastCellInSection) {
        return;
    }
    
    _isLastCellInSection = isLastCellInSection;
    self.bottomLineView.hidden = isLastCellInSection;
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
