//
//  DBHWalletDetailTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHWalletDetailTableViewCell.h"

#import "DBHWalletDetailTokenInfomationModelData.h"

@interface DBHWalletDetailTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *canExtractGasLabel;
@property (nonatomic, strong) UIButton *extractButton;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, copy) ClickExtractButtonBlock clickExtractButtonBlock;

@end

@implementation DBHWalletDetailTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bottomLineViewColor = COLORFROM16(0xF5F5F5, 1);
        self.bottomLineWidth = SCREENWIDTH - AUTOLAYOUTSIZE(42);
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.canExtractGasLabel];
    [self.contentView addSubview:self.extractButton];
    [self.contentView addSubview:self.priceLabel];
    
    WEAKSELF
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(20));
        make.left.offset(AUTOLAYOUTSIZE(21));
        make.centerY.equalTo(weakSelf.nameLabel);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.top.offset(AUTOLAYOUTSIZE(19.5));
    }];
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- AUTOLAYOUTSIZE(21));
        make.top.offset(AUTOLAYOUTSIZE(14.5));
    }];
    [self.canExtractGasLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView);
        make.centerY.equalTo(weakSelf.extractButton);
    }];
    [self.extractButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset([NSString getWidthtWithString:DBHGetStringWithKeyFromTable(@"Claim", nil) fontSize:AUTOLAYOUTSIZE(6)] + AUTOLAYOUTSIZE(6));
        make.height.offset(AUTOLAYOUTSIZE(9));
        make.left.equalTo(weakSelf.canExtractGasLabel.mas_right);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom);
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.numberLabel);
        make.bottom.offset(- AUTOLAYOUTSIZE(10));
    }];
}

#pragma mark ------ Event Responds ------
/**
 提取
 */
- (void)respondsToExtractButton {
    self.clickExtractButtonBlock();
}

#pragma mark ------ Public Methods ------
- (void)clickExtractButtonBlock:(ClickExtractButtonBlock)clickExtractButtonBlock {
    self.clickExtractButtonBlock = clickExtractButtonBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHWalletDetailTokenInfomationModelData *)model {
    _model = model;
    
    if ([_model.flag isEqualToString:@"NEO"] || [_model.flag isEqualToString:@"Gas"]) {
        if ([_model.flag isEqualToString:@"NEO"]) {
            self.numberLabel.text = [NSString stringWithFormat:@"%.0lf", _model.balance.floatValue];
        } else {
            self.numberLabel.text = [NSString stringWithFormat:@"%.8lf", _model.balance.floatValue];
        }
        self.iconImageView.image = [UIImage imageNamed:_model.icon];
    } else {
        self.numberLabel.text = [NSString stringWithFormat:@"%.8lf", _model.balance.floatValue];
        if ([_model.icon containsString:@"http"]) {
            [self.iconImageView sdsetImageWithURL:_model.icon placeholderImage:[UIImage imageNamed:@"NEO_add"]];
        } else {
            self.iconImageView.image = [UIImage imageNamed:![_model.icon isEqual:[NSNull null]] ? _model.icon : @""];
        }
    }
    self.nameLabel.text = _model.flag;
    if ([UserSignData share].user.isHideAsset) {
        self.priceLabel.text = [NSString stringWithFormat:@"%@****", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$"];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"%@%.2lf", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", [UserSignData share].user.walletUnitType == 1 ? _model.priceCny.floatValue : _model.priceUsd.floatValue];
    }
    
    self.canExtractGasLabel.hidden = !_model.canExtractbalance;
    self.extractButton.hidden = !_model.canExtractbalance;
    if (_model.canExtractbalance) {
        self.canExtractGasLabel.text = [NSString stringWithFormat:@"（%.8lfGas %@）", _model.canExtractbalance.floatValue, DBHGetStringWithKeyFromTable(@"Available", nil)];
    }
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(13);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = FONT(11);
        _numberLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _numberLabel;
}
- (UILabel *)canExtractGasLabel {
    if (!_canExtractGasLabel) {
        _canExtractGasLabel = [[UILabel alloc] init];
        _canExtractGasLabel.font = FONT(7);
        _canExtractGasLabel.textColor = COLORFROM16(0xC0C0C0, 1);
    }
    return _canExtractGasLabel;
}
- (UIButton *)extractButton {
    if (!_extractButton) {
        _extractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _extractButton.backgroundColor = COLORFROM16(0xFF841C, 1);
        _extractButton.titleLabel.font = FONT(6);
        [_extractButton setTitle:DBHGetStringWithKeyFromTable(@"Claim", nil) forState:UIControlStateNormal];
        [_extractButton addTarget:self action:@selector(respondsToExtractButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _extractButton;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = FONT(11);
        _priceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _priceLabel;
}

@end
