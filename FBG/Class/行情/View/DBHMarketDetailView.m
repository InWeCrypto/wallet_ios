//
//  DBHMarketDetailView.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/24.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHMarketDetailView.h"

#import "DBHMarketDetailMoneyRealTimePriceModelData.h"

@interface DBHMarketDetailView ()

@property (nonatomic, strong) UILabel *currentPriceLabel;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *maxPriceLabel;
@property (nonatomic, strong) UILabel *volumeTransactionLabel;
@property (nonatomic, strong) UILabel *minPriceLabel;

@end

@implementation DBHMarketDetailView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = COLORFROM16(0x1D1C1C, 1);
        
        [self setUI];
        [self setData];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.currentPriceLabel];
    [self addSubview:self.changeLabel];
    [self addSubview:self.maxPriceLabel];
    [self addSubview:self.volumeTransactionLabel];
    [self addSubview:self.minPriceLabel];
    
    WEAKSELF
    [self.currentPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(10));
        make.top.offset(AUTOLAYOUTSIZE(20));
    }];
    [self.changeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).multipliedBy(0.5).offset(- AUTOLAYOUTSIZE(10));
        make.left.equalTo(weakSelf.currentPriceLabel);
        make.bottom.equalTo(weakSelf.volumeTransactionLabel.mas_top).offset(- AUTOLAYOUTSIZE(10));
    }];
    [self.maxPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.changeLabel);
        make.right.offset(- AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.changeLabel);
    }];
    [self.volumeTransactionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.changeLabel);
        make.left.equalTo(weakSelf.changeLabel);
        make.bottom.offset(- AUTOLAYOUTSIZE(18));
    }];
    [self.minPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.changeLabel);
        make.right.equalTo(weakSelf.maxPriceLabel);
        make.centerY.equalTo(weakSelf.volumeTransactionLabel);
    }];
}

 #pragma mark ------ Private Methods ------
- (void)setData {
    // 设置占位数据
    DBHMarketDetailMoneyRealTimePriceModelData *model = [[DBHMarketDetailMoneyRealTimePriceModelData alloc] init];
    model.price = @"0";
    model.priceCny = @"0";
    model.change24h = @"0";
    model.changeCny24h = @"0";
    model.maxPrice24h = @"0";
    model.maxPriceCny24h = @"0";
    model.volume = @"0";
    model.volumeCny = @"0";
    model.minPrice24h = @"0";
    model.minPriceCny24h = @"0";
    
    self.model = model;
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHMarketDetailMoneyRealTimePriceModelData *)model {
    _model = model;
    
    NSString *usdPrice = [NSString stringWithFormat:@"%.2lf", _model.price.floatValue];
    NSString *cnyPrice = [NSString stringWithFormat:@"%.2lf", _model.priceCny.floatValue];
    NSMutableAttributedString *currentPriceAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@↑￥%@", usdPrice, cnyPrice]];
    [currentPriceAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(16)], NSForegroundColorAttributeName:COLORFROM16(0x008C55, 1)} range:NSMakeRange(0, usdPrice.length + 1)];
    
    NSString *change = [NSString stringWithFormat:@"%.2lf", [UserSignData share].user.walletUnitType == 1 ? _model.changeCny24h.floatValue : _model.change24h.floatValue];
    NSMutableAttributedString *changeAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"24小时涨跌      %@%%", change]];
    [changeAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(12, change.length + 1)];
    
    NSString *money = [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$";
    NSString *maxPrice = [NSString stringWithFormat:@"%.2lf", [UserSignData share].user.walletUnitType == 1 ? _model.maxPriceCny24h.floatValue : _model.maxPrice24h.floatValue];
    NSMutableAttributedString *maxPriceAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"24小时最高价  %@%@", money, maxPrice]];
    [maxPriceAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(8, maxPrice.length + 2)];
    
    NSString *volumeTransaction = [NSString getDealNumwithstring:[NSString stringWithFormat:@"%.2lf", [UserSignData share].user.walletUnitType == 1 ? _model.volumeCny.floatValue : _model.volumeCny.floatValue]];
    NSMutableAttributedString *volumeTransactionAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"24小时成交额  %@%@", money, volumeTransaction]];
    [volumeTransactionAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(8, volumeTransaction.length + 2)];
    
    NSString *minPrice = [NSString stringWithFormat:@"%.2lf", [UserSignData share].user.walletUnitType == 1 ? _model.minPriceCny24h.floatValue : _model.minPrice24h.floatValue];
    NSMutableAttributedString *minPriceAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"24小时最低价  %@%@", money, minPrice]];
    [minPriceAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(8, minPrice.length + 2)];
    
    self.currentPriceLabel.attributedText = currentPriceAttributedString;
    self.changeLabel.attributedText = changeAttributedString;
    self.maxPriceLabel.attributedText = maxPriceAttributedString;
    self.volumeTransactionLabel.attributedText = volumeTransactionAttributedString;
    self.minPriceLabel.attributedText = minPriceAttributedString;
}

- (UILabel *)currentPriceLabel {
    if (!_currentPriceLabel) {
        _currentPriceLabel = [[UILabel alloc] init];
        _currentPriceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(15)];
        _currentPriceLabel.textColor = [UIColor whiteColor];
    }
    return _currentPriceLabel;
}
- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _changeLabel.textColor = [UIColor grayColor];
    }
    return _changeLabel;
}
- (UILabel *)maxPriceLabel {
    if (!_maxPriceLabel) {
        _maxPriceLabel = [[UILabel alloc] init];
        _maxPriceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _maxPriceLabel.textColor = [UIColor grayColor];
    }
    return _maxPriceLabel;
}
- (UILabel *)volumeTransactionLabel {
    if (!_volumeTransactionLabel) {
        _volumeTransactionLabel = [[UILabel alloc] init];
        _volumeTransactionLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _volumeTransactionLabel.textColor = [UIColor grayColor];
    }
    return _volumeTransactionLabel;
}
- (UILabel *)minPriceLabel {
    if (!_minPriceLabel) {
        _minPriceLabel = [[UILabel alloc] init];
        _minPriceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _minPriceLabel.textColor = [UIColor grayColor];
    }
    return _minPriceLabel;
}

@end
