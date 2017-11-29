//
//  DBHExtractViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHExtractViewController.h"

@interface DBHExtractViewController ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *maxExtractGasLabel;
@property (nonatomic, strong) UILabel *maxExtractGasValueLabel;
@property (nonatomic, strong) UILabel *noExtractGasLabel;
@property (nonatomic, strong) UILabel *applyExtractGasLabel;
@property (nonatomic, strong) UITextField *extractGasTextField;
@property (nonatomic, strong) UIView *orangeLineView;
@property (nonatomic, strong) UILabel *canExtractGasLabel;
@property (nonatomic, strong) UIButton *allExtractButton;
@property (nonatomic, strong) UIButton *sureButton;

@end

@implementation DBHExtractViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Extract", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
    [self setData];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.boxView];
    [self.view addSubview:self.maxExtractGasLabel];
    [self.view addSubview:self.maxExtractGasValueLabel];
    [self.view addSubview:self.noExtractGasLabel];
    [self.view addSubview:self.applyExtractGasLabel];
    [self.view addSubview:self.extractGasTextField];
    [self.view addSubview:self.orangeLineView];
    [self.view addSubview:self.canExtractGasLabel];
    [self.view addSubview:self.allExtractButton];
    [self.view addSubview:self.sureButton];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(152));
        make.top.centerX.equalTo(weakSelf.view);
    }];
    [self.maxExtractGasLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(32));
    }];
    [self.maxExtractGasValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(4));
    }];
    [self.noExtractGasLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(11));
        make.bottom.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(11.5));
    }];
    [self.applyExtractGasLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.boxView.mas_bottom).offset(AUTOLAYOUTSIZE(37));
    }];
    [self.extractGasTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.orangeLineView);
        make.height.offset(AUTOLAYOUTSIZE(62.5));
        make.bottom.centerX.equalTo(weakSelf.orangeLineView);
    }];
    [self.orangeLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(168));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.view);
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
    [self.sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(88));
        make.height.offset(AUTOLAYOUTSIZE(42));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(36.5));
    }];
}

#pragma mark ------ Event Responds ------
/**
 全部提取
 */
- (void)respondsToAllExtractButton {
    
}
/**
 确定
 */
- (void)respondsToSureButton {
    
}

#pragma mark ------ Getters And Setters ------
- (void)setData {
    self.maxExtractGasValueLabel.text = @"3300.0100";
    self.noExtractGasLabel.text = @"不可提取Gas：100";
    self.canExtractGasLabel.text = @"可提取1.000-3300.0100";
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
        _extractGasTextField.textColor = COLORFROM16(0xF0F0F0, 1);
        _extractGasTextField.textAlignment = NSTextAlignmentCenter;
        _extractGasTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _extractGasTextField.placeholder = @"请输入提取金额";
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
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = COLORFROM16(0x158A1B, 1);
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(respondsToSureButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

@end
