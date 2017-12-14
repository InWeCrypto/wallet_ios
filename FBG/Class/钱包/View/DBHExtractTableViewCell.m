//
//  DBHExtractTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/12/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHExtractTableViewCell.h"

#import "WalletInfoGntModel.h"

@interface DBHExtractTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *maxExtractGasLabel;
@property (nonatomic, strong) UILabel *maxExtractGasValueLabel;
@property (nonatomic, strong) UILabel *noExtractGasLabel;
@property (nonatomic, strong) UIButton *unfreezeButton;
@property (nonatomic, strong) UILabel *applyExtractGasLabel;
@property (nonatomic, strong) UITextField *extractGasTextField;
@property (nonatomic, strong) UIView *orangeLineView;
@property (nonatomic, strong) UILabel *canExtractGasLabel;
@property (nonatomic, strong) UIButton *allExtractButton;

@property (nonatomic, copy) UnfreezeBlock unfreezeBlock;

@end

@implementation DBHExtractTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
    [self.contentView addSubview:self.maxExtractGasLabel];
    [self.contentView addSubview:self.maxExtractGasValueLabel];
    [self.contentView addSubview:self.noExtractGasLabel];
    [self.contentView addSubview:self.unfreezeButton];
    [self.contentView addSubview:self.applyExtractGasLabel];
    [self.contentView addSubview:self.extractGasTextField];
    [self.contentView addSubview:self.orangeLineView];
    [self.contentView addSubview:self.canExtractGasLabel];
    [self.contentView addSubview:self.allExtractButton];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.height.offset(AUTOLAYOUTSIZE(152));
        make.top.centerX.equalTo(weakSelf.contentView);
    }];
    [self.maxExtractGasLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(32));
    }];
    [self.maxExtractGasValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(4));
    }];
    [self.noExtractGasLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(11));
        make.bottom.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(11.5));
    }];
    [self.unfreezeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(40));
        make.height.offset(AUTOLAYOUTSIZE(14));
        make.left.equalTo(weakSelf.noExtractGasLabel.mas_right).offset(AUTOLAYOUTSIZE(5));
        make.centerY.equalTo(weakSelf.noExtractGasLabel);
    }];
    [self.applyExtractGasLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.boxView.mas_bottom).offset(AUTOLAYOUTSIZE(37));
    }];
    [self.extractGasTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.orangeLineView);
        make.height.offset(AUTOLAYOUTSIZE(62.5));
        make.bottom.centerX.equalTo(weakSelf.orangeLineView);
    }];
    [self.orangeLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(168));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.applyExtractGasLabel.mas_bottom).offset(AUTOLAYOUTSIZE(67.5));
    }];
    [self.canExtractGasLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.orangeLineView);
        make.top.equalTo(weakSelf.orangeLineView.mas_bottom).offset(AUTOLAYOUTSIZE(7.5));
    }];
    [self.allExtractButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(AUTOLAYOUTSIZE(29));
        make.centerY.equalTo(weakSelf.canExtractGasLabel);
        make.right.equalTo(weakSelf.orangeLineView);
    }];
}

#pragma mark ------ Event Responds ------
/**
 解冻
 */
- (void)respondsToUnfreezeButton {
    self.unfreezeBlock();
}
/**
 全部提取
 */
- (void)respondsToAllExtractButton {
    self.extractGasTextField.text = [NSString stringWithFormat:@"%.8lf", self.model.balance.floatValue];
}

#pragma mark ------ Private Methods ------
- (void)unfreezeBlock:(UnfreezeBlock)unfreezeBlock {
    self.unfreezeBlock = unfreezeBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(WalletInfoGntModel *)model {
    _model = model;
    
    self.maxExtractGasValueLabel.text = _model.balance;
    self.noExtractGasLabel.text = [NSString stringWithFormat:@"不可提取Gas：%@", _model.noExtractbalance];
    self.canExtractGasLabel.text = [NSString stringWithFormat:@"可提取1.000-%@", _model.balance];
    self.extractGasTextField.text = [NSString stringWithFormat:@"%.8lf", self.model.balance.floatValue];
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = COLORFROM16(0x158A1B, 1);
    }
    return _boxView;
}
- (UILabel *)maxExtractGasLabel {
    if (!_maxExtractGasLabel) {
        _maxExtractGasLabel = [[UILabel alloc] init];
        _maxExtractGasLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _maxExtractGasLabel.text = @"最高可提取Gas";
        _maxExtractGasLabel.textColor = COLORFROM16(0xD7D7D7, 1);
    }
    return _maxExtractGasLabel;
}
- (UILabel *)maxExtractGasValueLabel {
    if (!_maxExtractGasValueLabel) {
        _maxExtractGasValueLabel = [[UILabel alloc] init];
        _maxExtractGasValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(32)];
        _maxExtractGasValueLabel.textColor = COLORFROM16(0xF7F7F7, 1);
    }
    return _maxExtractGasValueLabel;
}
- (UILabel *)noExtractGasLabel {
    if (!_noExtractGasLabel) {
        _noExtractGasLabel = [[UILabel alloc] init];
        _noExtractGasLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(10)];
        _noExtractGasLabel.textColor = COLORFROM16(0xD7D7D7, 1);
    }
    return _noExtractGasLabel;
}
- (UIButton *)unfreezeButton {
    if (!_unfreezeButton) {
        _unfreezeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _unfreezeButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(10)];
        _unfreezeButton.layer.cornerRadius = AUTOLAYOUTSIZE(7);
        _unfreezeButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _unfreezeButton.layer.borderWidth = AUTOLAYOUTSIZE(0.5);
        [_unfreezeButton setTitle:@"解冻" forState:UIControlStateNormal];
        [_unfreezeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_unfreezeButton addTarget:self action:@selector(respondsToUnfreezeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unfreezeButton;
}
- (UILabel *)applyExtractGasLabel {
    if (!_applyExtractGasLabel) {
        _applyExtractGasLabel = [[UILabel alloc] init];
        _applyExtractGasLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _applyExtractGasLabel.text = @"申请提取";
        _applyExtractGasLabel.textColor = COLORFROM16(0x000000, 1);
    }
    return _applyExtractGasLabel;
}
- (UITextField *)extractGasTextField {
    if (!_extractGasTextField) {
        _extractGasTextField = [[UITextField alloc] init];
        _extractGasTextField.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(24)];
        _extractGasTextField.textColor = COLORFROM16(0x333333, 1);
        _extractGasTextField.textAlignment = NSTextAlignmentCenter;
        _extractGasTextField.keyboardType = UIKeyboardTypeDecimalPad;
        //        _extractGasTextField.placeholder = @"请输入提取金额";
        _extractGasTextField.userInteractionEnabled = NO;
        //        _extractGasTextField.text = @"0.00000000";
    }
    return _extractGasTextField;
}
- (UIView *)orangeLineView {
    if (!_orangeLineView) {
        _orangeLineView = [[UIView alloc] init];
        _orangeLineView.backgroundColor = COLORFROM16(0xFB7B33, 1);
    }
    return _orangeLineView;
}
- (UILabel *)canExtractGasLabel {
    if (!_canExtractGasLabel) {
        _canExtractGasLabel = [[UILabel alloc] init];
        _canExtractGasLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(10)];
        _canExtractGasLabel.textColor = COLORFROM16(0xA8A8A8, 1);
    }
    return _canExtractGasLabel;
}
- (UIButton *)allExtractButton {
    if (!_allExtractButton) {
        _allExtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _allExtractButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(10)];
        [_allExtractButton setTitle:@"全部提取" forState:UIControlStateNormal];
        [_allExtractButton setTitleColor:COLORFROM16(0xF95A00, 1) forState:UIControlStateNormal];
        [_allExtractButton addTarget:self action:@selector(respondsToAllExtractButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allExtractButton;
}

@end
