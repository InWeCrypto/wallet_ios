//
//  DBHMarketDetailView.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/24.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHMarketDetailView.h"

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

#pragma mark ------ Getters And Setters ------
- (void)setData {
    NSString *currentPrice = @"0.34284↑￥3.62";
    NSMutableAttributedString *currentPriceAttributedString = [[NSMutableAttributedString alloc] initWithString:currentPrice];
    [currentPriceAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(16)], NSForegroundColorAttributeName:COLORFROM16(0x008C55, 1)} range:NSMakeRange(0, 8)];
    
    NSString *change = @"24小时涨跌      -17.17%";
    NSMutableAttributedString *changeAttributedString = [[NSMutableAttributedString alloc] initWithString:change];
    [changeAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(12, 7)];
    
    NSString *maxPrice = @"24小时最高价  -17.17";
    NSMutableAttributedString *maxPriceAttributedString = [[NSMutableAttributedString alloc] initWithString:maxPrice];
    [maxPriceAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(9, 6)];
    
    NSString *volumeTransaction = @"24小时成交额  -17.17";
    NSMutableAttributedString *volumeTransactionAttributedString = [[NSMutableAttributedString alloc] initWithString:volumeTransaction];
    [volumeTransactionAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(9, 6)];
    
    NSString *minPrice = @"24小时最低价  -17.17";
    NSMutableAttributedString *minPriceAttributedString = [[NSMutableAttributedString alloc] initWithString:minPrice];
    [minPriceAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(9, 6)];
    
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
