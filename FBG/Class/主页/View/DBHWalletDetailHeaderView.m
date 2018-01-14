//
//  DBHWalletDetailHeaderView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHWalletDetailHeaderView.h"

#import "DBHWalletManagerForNeoModelList.h"

@interface DBHWalletDetailHeaderView ()

@property (nonatomic, strong) UIImageView *backGroundImageView;
@property (nonatomic, strong) UIImageView *boxImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *qrCodeButton;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *showPriceButton;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *propertyLabel;
@property (nonatomic, strong) UIButton *addPropertyButton;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UILabel *tokenSaleLabel;
@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UILabel *informationLabel;
@property (nonatomic, strong) UIButton *examineButton;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, copy) ClickButtonBlock clickButtonBlock;

@end

@implementation DBHWalletDetailHeaderView

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.backGroundImageView];
    [self addSubview:self.boxImageView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.qrCodeButton];
    [self addSubview:self.priceLabel];
    [self addSubview:self.showPriceButton];
    [self addSubview:self.changeLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.stateLabel];
    [self addSubview:self.propertyLabel];
    [self addSubview:self.addPropertyButton];
    [self addSubview:self.firstLineView];
    [self addSubview:self.tokenSaleLabel];
    [self addSubview:self.joinButton];
    [self addSubview:self.secondLineView];
    [self addSubview:self.informationLabel];
    [self addSubview:self.examineButton];
    [self addSubview:self.bottomLineView];
    
    WEAKSELF
    [self.backGroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf);
        make.center.equalTo(weakSelf);
    }];
    [self.boxImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).offset(- AUTOLAYOUTSIZE(49));
        make.height.offset(AUTOLAYOUTSIZE(196));
        make.top.offset(AUTOLAYOUTSIZE(19) + STATUS_HEIGHT + 44);
        make.centerX.equalTo(weakSelf);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(33.5));
        make.left.equalTo(weakSelf.boxImageView).offset(AUTOLAYOUTSIZE(9.5));
        make.top.equalTo(weakSelf.boxImageView).offset(AUTOLAYOUTSIZE(9.5));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(3.5));
        make.centerY.equalTo(weakSelf.iconImageView);
    }];
    [self.qrCodeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(41));
        make.top.right.equalTo(weakSelf.boxImageView);
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.boxImageView);
        make.top.equalTo(weakSelf.boxImageView).offset(AUTOLAYOUTSIZE(60.5));
    }];
    [self.showPriceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(31.5));
        make.height.equalTo(weakSelf.priceLabel);
        make.left.equalTo(weakSelf.priceLabel.mas_right);
        make.centerY.equalTo(weakSelf.priceLabel);
    }];
    [self.changeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.boxImageView);
        make.top.equalTo(weakSelf.priceLabel.mas_bottom).offset(AUTOLAYOUTSIZE(5));
    }];
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).multipliedBy(0.55);
        make.left.equalTo(weakSelf.boxImageView).offset(AUTOLAYOUTSIZE(11.5));
        make.bottom.equalTo(weakSelf.boxImageView).offset(- AUTOLAYOUTSIZE(10.5));
    }];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.boxImageView).offset(- AUTOLAYOUTSIZE(2.5));
        make.centerY.equalTo(weakSelf.addressLabel);
    }];
    [self.propertyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.addPropertyButton);
        make.top.equalTo(weakSelf.firstLineView).offset(- AUTOLAYOUTSIZE(3));
    }];
    [self.addPropertyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(97));
        make.height.offset(AUTOLAYOUTSIZE(28));
        make.right.equalTo(weakSelf.firstLineView.mas_left);
        make.top.equalTo(weakSelf.propertyLabel.mas_bottom);
    }];
    [self.firstLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(0.5));
        make.height.offset(AUTOLAYOUTSIZE(32));
        make.top.equalTo(weakSelf.boxImageView.mas_bottom).offset(AUTOLAYOUTSIZE(24.5));
        make.right.equalTo(weakSelf.joinButton.mas_left);
    }];
    [self.tokenSaleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.propertyLabel);
        make.centerX.equalTo(weakSelf.joinButton);
    }];
    [self.joinButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(129));
        make.height.equalTo(weakSelf.addPropertyButton);
        make.centerY.equalTo(weakSelf.addPropertyButton);
        make.centerX.equalTo(weakSelf.boxImageView);
    }];
    [self.secondLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.firstLineView);
        make.centerY.equalTo(weakSelf.firstLineView);
        make.left.equalTo(weakSelf.joinButton.mas_right);
    }];
    [self.informationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.propertyLabel);
        make.centerX.equalTo(weakSelf.examineButton);
    }];
    [self.examineButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.addPropertyButton);
        make.centerY.equalTo(weakSelf.addPropertyButton);
        make.left.equalTo(weakSelf.secondLineView.mas_right);
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).offset(- AUTOLAYOUTSIZE(42));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.bottom.equalTo(weakSelf);
    }];
}

#pragma mark ------ Event Responds ------
/**
 二维码
 */
- (void)respondsToQrCodeButton {
    self.clickButtonBlock(0);
}
/**
 显示/隐藏资产
 */
- (void)respondsToShowPriceButton {
    
}
/**
 添加资产
 */
- (void)respondsToAddPropertyButton {
    self.clickButtonBlock(1);
}
/**
 加入
 */
- (void)respondsToJoinButton {
    self.clickButtonBlock(2);
}
/**
 查看
 */
- (void)respondsToExamineButton {
    self.clickButtonBlock(3);
}

#pragma mark ------ Public Methods ------
- (void)clickButtonBlock:(ClickButtonBlock)clickButtonBlock {
    self.clickButtonBlock = clickButtonBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setNeoWalletModel:(DBHWalletManagerForNeoModelList *)neoWalletModel {
    _neoWalletModel = neoWalletModel;
    
    self.stateLabel.hidden = !_neoWalletModel.isLookWallet && !_neoWalletModel.isBackUpMnemonnic;
    if (_neoWalletModel.isLookWallet) {
        self.stateLabel.text = [NSString stringWithFormat:@"（%@）", NSLocalizedString(@"Observation", nil)];
    } else if (_neoWalletModel.isLookWallet) {
        self.stateLabel.text = [NSString stringWithFormat:@"（%@）", NSLocalizedString(@"Not Backedup", nil)];
    }
    self.nameLabel.text = _neoWalletModel.name;
//    self.changeLabel.text = @"（+12.09%）";
    self.addressLabel.text = [NSString stringWithFormat:@"Address:%@", _neoWalletModel.address];
}
- (void)setAsset:(NSString *)asset {
    _asset = asset;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@%.2lf", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", _asset.floatValue];
}

- (UIImageView *)backGroundImageView {
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle"]];
    }
    return _backGroundImageView;
}
- (UIImageView *)boxImageView {
    if (!_boxImageView) {
        _boxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 3"]];
    }
    return _boxImageView;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"卡片logo"]];
    }
    return _iconImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(14);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}
- (UIButton *)qrCodeButton {
    if (!_qrCodeButton) {
        _qrCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _qrCodeButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
        [_qrCodeButton setImage:[UIImage imageNamed:@"二维码-6"] forState:UIControlStateNormal];
        [_qrCodeButton addTarget:self action:@selector(respondsToQrCodeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrCodeButton;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = FONT(40);
        _priceLabel.text = [NSString stringWithFormat:@"%@0.00", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$"];
        _priceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _priceLabel;
}
- (UIButton *)showPriceButton {
    if (!_showPriceButton) {
        _showPriceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPriceButton setImage:[UIImage imageNamed:@"睁眼1"] forState:UIControlStateNormal];
        [_showPriceButton setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateSelected];
        [_showPriceButton addTarget:self action:@selector(respondsToShowPriceButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPriceButton;
}
- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.font = FONT(11);
        _changeLabel.textColor = COLORFROM16(0x348D00, 1);
    }
    return _changeLabel;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = FONT(11);
        _addressLabel.textColor = COLORFROM16(0xACACAC, 1);
    }
    return _addressLabel;
}
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = BOLDFONT(10);
        _stateLabel.textColor = COLORFROM16(0xFF841C, 1);
    }
    return _stateLabel;
}
- (UILabel *)propertyLabel {
    if (!_propertyLabel) {
        _propertyLabel = [[UILabel alloc] init];
        _propertyLabel.font = FONT(12);
        _propertyLabel.text = NSLocalizedString(@"Asset", nil);
        _propertyLabel.textColor = COLORFROM16(0x6DAD58, 1);
    }
    return _propertyLabel;
}
- (UIButton *)addPropertyButton {
    if (!_addPropertyButton) {
        _addPropertyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPropertyButton.titleLabel.font = FONT(14);
        [_addPropertyButton setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
        [_addPropertyButton addTarget:self action:@selector(respondsToAddPropertyButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPropertyButton;
}
- (UIView *)firstLineView {
    if (!_firstLineView) {
        _firstLineView = [[UIView alloc] init];
        _firstLineView.backgroundColor = COLORFROM16(0x3C8F79, 1);
    }
    return _firstLineView;
}
- (UILabel *)tokenSaleLabel {
    if (!_tokenSaleLabel) {
        _tokenSaleLabel = [[UILabel alloc] init];
        _tokenSaleLabel.font = FONT(12);
        _tokenSaleLabel.text = @"TokenSale";
        _tokenSaleLabel.textColor = COLORFROM16(0x6DAD58, 1);
    }
    return _tokenSaleLabel;
}
- (UIButton *)joinButton {
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinButton.titleLabel.font = FONT(14);
        [_joinButton setTitle:NSLocalizedString(@"Join", nil) forState:UIControlStateNormal];
        [_joinButton addTarget:self action:@selector(respondsToJoinButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinButton;
}
- (UIView *)secondLineView {
    if (!_secondLineView) {
        _secondLineView = [[UIView alloc] init];
        _secondLineView.backgroundColor = COLORFROM16(0x3C8F79, 1);
    }
    return _secondLineView;
}
- (UILabel *)informationLabel {
    if (!_informationLabel) {
        _informationLabel = [[UILabel alloc] init];
        _informationLabel.font = FONT(12);
        _informationLabel.text = NSLocalizedString(@"Information", nil);
        _informationLabel.textColor = COLORFROM16(0x6DAD58, 1);
    }
    return _informationLabel;
}
- (UIButton *)examineButton {
    if (!_examineButton) {
        _examineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _examineButton.titleLabel.font = FONT(14);
        [_examineButton setTitle:NSLocalizedString(@"Look", nil) forState:UIControlStateNormal];
        [_examineButton addTarget:self action:@selector(respondsToExamineButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _examineButton;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xF5F5F5, 1);
    }
    return _bottomLineView;
}

@end
