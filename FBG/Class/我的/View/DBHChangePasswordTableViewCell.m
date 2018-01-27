//
//  DBHChangePasswordTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHChangePasswordTableViewCell.h"

@interface DBHChangePasswordTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) GetVerificationCodeBlock getVerificationCodeBlock;

@end

@implementation DBHChangePasswordTableViewCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.valueTextField];
    [self.contentView addSubview:self.emailVerificationCodeButton];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.valueTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(96));
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.height.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.emailVerificationCodeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(70.5));
        make.height.offset(AUTOLAYOUTSIZE(27.5));
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Event Responds ------
/**
 邮箱验证码
 */
- (void)respondsToEmailVerificationCodeButton {
    self.getVerificationCodeBlock();
}

#pragma mark ------ Public Methods ------
- (void)getVerificationCodeBlock:(GetVerificationCodeBlock)getVerificationCodeBlock {
    self.getVerificationCodeBlock = getVerificationCodeBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.emailVerificationCodeButton.hidden = ![_title isEqualToString:@"Verification code"];
    self.valueTextField.keyboardType = [_title isEqualToString:@"Verification code"] ? UIKeyboardTypeNumberPad : UIKeyboardTypeASCIICapable;
    self.valueTextField.secureTextEntry = ![_title isEqualToString:@"Verification code"];
    
    WEAKSELF
    if (self.emailVerificationCodeButton.hidden) {
        [self.valueTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(AUTOLAYOUTSIZE(96));
            make.right.offset(- AUTOLAYOUTSIZE(15));
            make.height.equalTo(weakSelf.contentView);
            make.centerY.equalTo(weakSelf.contentView);
        }];
    } else {
        [self.valueTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(AUTOLAYOUTSIZE(96));
            make.right.equalTo(weakSelf.emailVerificationCodeButton.mas_left);
            make.height.equalTo(weakSelf.contentView);
            make.centerY.equalTo(weakSelf.contentView);
        }];
    }
    
    self.titleLabel.text = DBHGetStringWithKeyFromTable(_title, nil);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(13);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UITextField *)valueTextField {
    if (!_valueTextField) {
        _valueTextField = [[UITextField alloc] init];
        _valueTextField.font = FONT(13);
        _valueTextField.textColor = COLORFROM16(0x333333, 1);
    }
    return _valueTextField;
}
- (UIButton *)emailVerificationCodeButton {
    if (!_emailVerificationCodeButton) {
        _emailVerificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _emailVerificationCodeButton.backgroundColor = COLORFROM16(0xFF841C, 1);
        _emailVerificationCodeButton.titleLabel.font = FONT(10);
        _emailVerificationCodeButton.layer.cornerRadius = AUTOLAYOUTSIZE(5);
        [_emailVerificationCodeButton setTitle:NSLocalizedString(@"Email verification code", nil) forState:UIControlStateNormal];
        [_emailVerificationCodeButton addTarget:self action:@selector(respondsToEmailVerificationCodeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emailVerificationCodeButton;
}

@end
