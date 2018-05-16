//
//  YYRedPacketDetailHeaderView.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketDetailHeaderView.h"

@interface YYRedPacketDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;

@end

@implementation YYRedPacketDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        self.frame = frame;
        self.totalTitleLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@" Total ", nil)];
    }
    return self;
}


- (void)setModel:(YYRedPacketDetailModel *)model redbagCellType:(RedBagCellType)cellType {
    if (!model) {
        return;
    }
    
    NSString *titleStr = @"";
    BOOL showTotal = NO;
    if (cellType == RedBagCellTypeCashPackage) {
        self.iconImgView.image = [UIImage imageNamed:@"cash_package_icon"];
        titleStr = DBHGetStringWithKeyFromTable(@"Packing Details", nil);
    } else if (cellType == RedBagCellTypeHanldeFee) {
        self.iconImgView.image = [UIImage imageNamed:@"package_detail_icon"];
        titleStr = DBHGetStringWithKeyFromTable(@"Payment Gas Details", nil);
    } else if (cellType == RedBagCellTypeDrawNum) {
        self.iconImgView.image = [UIImage imageNamed:@"get_count_icon"];
        showTotal = YES;
        titleStr = [NSString stringWithFormat:@"%@ %ld/%ld", DBHGetStringWithKeyFromTable(@"Opened Packet Number", nil), model.draw_redbag_number, model.redbag_number];
        
        NSString *price = [NSString stringWithFormat:@"???%@", model.redbag_symbol];
        if (model.done == RedBagLotteryStatusEnd) { // 已开奖
            NSString *total = model.redbag;
            
            NSString *backValue = model.redbag_back;
            if ([backValue isEqualToString:@"-"]) {
                backValue = @"0";
            } else {
                backValue = [NSString convertValue:backValue decimals:model.gnt_category.decimals];
            }
            
            NSString *drawed = [NSString DecimalFuncWithOperatorType:1 first:total secend:backValue value:0]; // 已领取的
            if (drawed.doubleValue >= 0) {
                NSString *number = [NSString notRounding:drawed afterPoint:4];
                price = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, model.redbag_symbol];
            }
        }
        
        self.totalValueLabel.text = price;
    } else if (cellType == RedBagCellTypeBackNum) {
        self.iconImgView.image = [UIImage imageNamed:@"get_count_icon"];
        
        NSInteger backNum = model.redbag_number -  model.draw_redbag_number;
        if (backNum < 0) {
            backNum = 0;
        }
        
        titleStr = [NSString stringWithFormat:@"%@ %ld", DBHGetStringWithKeyFromTable(@"Withdrawing Number", nil), backNum];
        showTotal = YES;
        
        NSString *backValue = model.redbag_back;
        if ([backValue isEqualToString:@"-"]) {
            backValue = @"0";
        } else {
            backValue = [NSString convertValue:backValue decimals:model.gnt_category.decimals];
        }
        
        NSString *number = [NSString notRounding:backValue afterPoint:4];
        self.totalValueLabel.text = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, model.redbag_symbol];
    }
    self.titleLabel.text = titleStr;
    self.totalView.hidden = !showTotal;
}

@end
