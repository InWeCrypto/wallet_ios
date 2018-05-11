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
        
        NSString *price = model.redbag;
        NSString *number = [NSString notRounding:price afterPoint:4];
        self.totalValueLabel.text = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, model.redbag_symbol];
    } else if (cellType == RedBagCellTypeBackNum) {
        self.iconImgView.image = [UIImage imageNamed:@"get_count_icon"];
        titleStr = [NSString stringWithFormat:@"%@ 1", DBHGetStringWithKeyFromTable(@"Withdrawing Number", nil)];
        showTotal = YES;
        
        NSString *price = model.redbag_back;
        
        NSString *number = [NSString notRounding:price afterPoint:4];
        self.totalValueLabel.text = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, model.redbag_symbol];
    }
    self.titleLabel.text = titleStr;
    self.totalView.hidden = !showTotal;
}

@end
