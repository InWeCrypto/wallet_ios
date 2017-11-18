//
//  DBHInformationDetailForTradingMarketContentTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForTradingMarketContentTableViewCell.h"

#import "DBHInformationDetailForTradingMarketContentModelData.h"

@interface DBHInformationDetailForTradingMarketContentTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *terraceLabel;
@property (nonatomic, strong) UILabel *transactionObjectLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *turnoverLabel;
@property (nonatomic, strong) UILabel *refreshTimeLabel;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation DBHInformationDetailForTradingMarketContentTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.terraceLabel];
    [self.contentView addSubview:self.transactionObjectLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.turnoverLabel];
    [self.contentView addSubview:self.refreshTimeLabel];
    [self.contentView addSubview:self.bottomLineView];
    
    WEAKSELF
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(14));
        make.left.offset(AUTOLAYOUTSIZE(19));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.terraceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(17.5));
        make.right.equalTo(weakSelf.transactionObjectLabel.mas_left);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.transactionObjectLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(102));
        make.right.equalTo(weakSelf.priceLabel.mas_left);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(160.5));
        make.right.equalTo(weakSelf.turnoverLabel.mas_left);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.turnoverLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(212.5));
        make.right.equalTo(weakSelf.refreshTimeLabel.mas_left);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.refreshTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(284.5));
        make.right.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.bottom.centerX.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setIsData:(BOOL)isData {
    _isData = isData;
    
    self.iconImageView.hidden = !_isData;
    if (!_isData) {
        self.terraceLabel.text = @"平台";
        self.transactionObjectLabel.text = @"交易对";
        self.priceLabel.text = @"价格";
        self.turnoverLabel.text = @"24H成交量";
        self.refreshTimeLabel.text = @"更新时间";
    }
}
- (void)setModel:(DBHInformationDetailForTradingMarketContentModelData *)model {
    _model = model;
    
    self.iconImageView.hidden = !_isData;
    if (!_isData) {
        self.terraceLabel.text = @"平台";
        self.transactionObjectLabel.text = @"交易对";
        self.priceLabel.text = @"价格";
        self.turnoverLabel.text = @"24H成交量";
        self.refreshTimeLabel.text = @"更新时间";
    } else {
        self.terraceLabel.text = _model.source;
        self.transactionObjectLabel.text = _model.pair;
        self.priceLabel.text = _model.pairce;
        self.turnoverLabel.text = _model.volum24;
        self.refreshTimeLabel.text = _model.update;
    }
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = PICTURECOLOR;
    }
    return _iconImageView;
}
- (UILabel *)terraceLabel {
    if (!_terraceLabel) {
        _terraceLabel = [[UILabel alloc] init];
        _terraceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _terraceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _terraceLabel;
}
- (UILabel *)transactionObjectLabel {
    if (!_transactionObjectLabel) {
        _transactionObjectLabel = [[UILabel alloc] init];
        _transactionObjectLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _transactionObjectLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _transactionObjectLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _priceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _priceLabel;
}
- (UILabel *)turnoverLabel {
    if (!_turnoverLabel) {
        _turnoverLabel = [[UILabel alloc] init];
        _turnoverLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _turnoverLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _turnoverLabel;
}
- (UILabel *)refreshTimeLabel {
    if (!_refreshTimeLabel) {
        _refreshTimeLabel = [[UILabel alloc] init];
        _refreshTimeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _refreshTimeLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _refreshTimeLabel;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xE6E6E6, 1);
    }
    return _bottomLineView;
}

@end
