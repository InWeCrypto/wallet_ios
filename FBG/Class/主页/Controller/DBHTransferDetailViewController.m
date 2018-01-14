//
//  DBHTransferDetailViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTransferDetailViewController.h"

#import "KKWebView.h"

#import "DBHWalletDetailTokenInfomationModelData.h"
#import "DBHTransferListModelList.h"

@interface DBHTransferDetailViewController ()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UILabel *poundageLabel;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UILabel *collectionAddressLabel;
@property (nonatomic, strong) UILabel *collectionAddressValueLabel;
@property (nonatomic, strong) UILabel *payAddressLabel;
@property (nonatomic, strong) UILabel *payAddressValueLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *timeValueLabel;
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) UILabel *remarkValueLabel;
@property (nonatomic, strong) UIButton *orderNumberButton;

@end

@implementation DBHTransferDetailViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Transaction Details", nil);
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.numberLabel];
    [self.view addSubview:self.unitLabel];
    [self.view addSubview:self.poundageLabel];
    [self.view addSubview:self.grayLineView];
    [self.view addSubview:self.collectionAddressLabel];
    [self.view addSubview:self.collectionAddressValueLabel];
    [self.view addSubview:self.payAddressLabel];
    [self.view addSubview:self.payAddressValueLabel];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.timeValueLabel];
    [self.view addSubview:self.remarkLabel];
    [self.view addSubview:self.remarkValueLabel];
    [self.view addSubview:self.orderNumberButton];
    
    WEAKSELF
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(47));
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.numberLabel.mas_right);
        make.bottom.equalTo(weakSelf.numberLabel).offset(- AUTOLAYOUTSIZE(5));
    }];
    [self.poundageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.numberLabel.mas_bottom).offset(AUTOLAYOUTSIZE(8));
    }];
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(60));
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.numberLabel.mas_bottom).offset(AUTOLAYOUTSIZE(78.5));
    }];
    [self.collectionAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.grayLineView.mas_bottom).offset(AUTOLAYOUTSIZE(14));
    }];
    [self.collectionAddressValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.collectionAddressLabel.mas_bottom).offset(AUTOLAYOUTSIZE(9.5));
    }];
    [self.payAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.collectionAddressValueLabel.mas_bottom).offset(AUTOLAYOUTSIZE(30.5));
    }];
    [self.payAddressValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.payAddressLabel.mas_bottom).offset(AUTOLAYOUTSIZE(9.5));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.payAddressValueLabel.mas_bottom).offset(AUTOLAYOUTSIZE(30.5));
    }];
    [self.timeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(AUTOLAYOUTSIZE(9.5));
    }];
    [self.remarkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.timeValueLabel.mas_bottom).offset(AUTOLAYOUTSIZE(40));
    }];
    [self.remarkValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.remarkLabel.mas_bottom).offset(AUTOLAYOUTSIZE(11.5));
    }];
    [self.orderNumberButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(80));
        make.height.offset(AUTOLAYOUTSIZE(30));
        make.centerX.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ Event Responds ------
/**
 订单号
 */
- (void)respondsToOrderNumberButton {
    NSString * url;
    if ([APP_APIEHEAD isEqualToString:APIEHEAD])
    {
        //测试
        url = /*[self.model.flag isEqualToString:@"ETH"]*/0 ? @"https://ropsten.etherscan.io/tx/" : @"https://neoscan-testnet.io/transaction/";
    }
    else
    {
        //正式
        url = /*[self.model.flag isEqualToString:@"ETH"]*/0 ? @"https://etherscan.io/tx/" : @"https://neoscan.io/transaction/";
    }
    NSString *orderNumber = [[self.model.tx substringToIndex:2] isEqualToString:@"0x"] ? [self.model.tx substringFromIndex:2] : self.model.tx;
    KKWebView * vc = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@%@",url, orderNumber]];
    vc.title = @"订单详情";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHTransferListModelList *)model {
    _model = model;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%.8lf", _model.value.floatValue];
    self.unitLabel.text = [NSString stringWithFormat:@"（%@）", self.tokenModel.flag];
    self.poundageLabel.text = [NSString stringWithFormat:@"%@：%.8lf", NSLocalizedString(@"Poundage", nil), 0.0];
    self.collectionAddressValueLabel.text = _model.to;
    self.payAddressValueLabel.text = _model.from;
    self.timeValueLabel.text = [NSString getLocalDateFormateUTCDate:_model.createTime];
    self.remarkValueLabel.text = _model.remark;
    
    NSAttributedString *orderNumberAttributedString = [[NSAttributedString alloc] initWithString:_model.tx attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    [self.orderNumberButton setAttributedTitle:orderNumberAttributedString forState:UIControlStateNormal];
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = FONT(30);
        _numberLabel.textColor = COLORFROM16(0x008D55, 1);
    }
    return _numberLabel;
}
- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = FONT(8);
        _unitLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _unitLabel;
}
- (UILabel *)poundageLabel {
    if (!_poundageLabel) {
        _poundageLabel = [[UILabel alloc] init];
        _poundageLabel.font = FONT(11);
        _poundageLabel.textColor = COLORFROM16(0xF85803, 1);
    }
    return _poundageLabel;
}
- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xEAEAEA, 1);
    }
    return _grayLineView;
}
- (UILabel *)collectionAddressLabel {
    if (!_collectionAddressLabel) {
        _collectionAddressLabel = [[UILabel alloc] init];
        _collectionAddressLabel.font = FONT(13);
        _collectionAddressLabel.text = NSLocalizedString(@"Collection Wallet Address", nil);
        _collectionAddressLabel.textColor = COLORFROM16(0x8A8A8A, 1);
    }
    return _collectionAddressLabel;
}
- (UILabel *)collectionAddressValueLabel {
    if (!_collectionAddressValueLabel) {
        _collectionAddressValueLabel = [[UILabel alloc] init];
        _collectionAddressValueLabel.font = FONT(13);
        _collectionAddressValueLabel.textColor = COLORFROM16(0x3D3D3D, 1);
    }
    return _collectionAddressValueLabel;
}
- (UILabel *)payAddressLabel {
    if (!_payAddressLabel) {
        _payAddressLabel = [[UILabel alloc] init];
        _payAddressLabel.font = FONT(13);
        _payAddressLabel.text = NSLocalizedString(@"Pay Wallet Address", nil);
        _payAddressLabel.textColor = COLORFROM16(0x8A8A8A, 1);
    }
    return _payAddressLabel;
}
- (UILabel *)payAddressValueLabel {
    if (!_payAddressValueLabel) {
        _payAddressValueLabel = [[UILabel alloc] init];
        _payAddressValueLabel.font = FONT(13);
        _payAddressValueLabel.textColor = COLORFROM16(0x3D3D3D, 1);
    }
    return _payAddressValueLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = FONT(13);
        _timeLabel.text = NSLocalizedString(@"Transaction time", nil);
        _timeLabel.textColor = COLORFROM16(0x8A8A8A, 1);
    }
    return _timeLabel;
}
- (UILabel *)timeValueLabel {
    if (!_timeValueLabel) {
        _timeValueLabel = [[UILabel alloc] init];
        _timeValueLabel.font = FONT(13);
        _timeValueLabel.textColor = COLORFROM16(0x3D3D3D, 1);
    }
    return _timeValueLabel;
}
- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.font = FONT(13);
        _remarkLabel.text = NSLocalizedString(@"Remarks", nil);
        _remarkLabel.textColor = COLORFROM16(0x8A8A8A, 1);
    }
    return _remarkLabel;
}
- (UILabel *)remarkValueLabel {
    if (!_remarkValueLabel) {
        _remarkValueLabel = [[UILabel alloc] init];
        _remarkValueLabel.font = FONT(13);
        _remarkValueLabel.textColor = COLORFROM16(0x3D3D3D, 1);
        _remarkValueLabel.numberOfLines = 0;
    }
    return _remarkValueLabel;
}
- (UIButton *)orderNumberButton {
    if (!_orderNumberButton) {
        _orderNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _orderNumberButton.titleLabel.font = FONT(11);
        [_orderNumberButton setTitleColor:COLORFROM16(0xD3D3D3, 1) forState:UIControlStateNormal];
        [_orderNumberButton addTarget:self action:@selector(respondsToOrderNumberButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderNumberButton;
}

@end
