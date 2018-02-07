//
//  DBHProjectHomeTypeOneTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectHomeTypeOneTableViewCell.h"

#import "DBHInformationDataModels.h"

@interface DBHProjectHomeTypeOneTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UILabel *realTimeQuotesLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UIButton *realTimeQuotesButton;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UILabel *tradingMarketLabel;
@property (nonatomic, strong) UIImageView *tradingMarketImageView;
@property (nonatomic, strong) UIButton *tradingMarketButton;

@property (nonatomic, copy) ClickButtonBlock clickButtonBlock;

@end

@implementation DBHProjectHomeTypeOneTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLORFROM10(235, 235, 235, 1);
        self.isHideBottomLineView = YES;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
    [self.boxView addSubview:self.coverImageView];
    [self.contentView addSubview:self.firstLineView];
    [self.contentView addSubview:self.realTimeQuotesLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.changeLabel];
    [self.contentView addSubview:self.realTimeQuotesButton];
    [self.contentView addSubview:self.secondLineView];
    [self.contentView addSubview:self.tradingMarketLabel];
    [self.contentView addSubview:self.tradingMarketImageView];
    [self.contentView addSubview:self.tradingMarketButton];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(30));
        make.height.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
    [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.height.offset(AUTOLAYOUTSIZE(155));
        make.centerX.top.equalTo(weakSelf.boxView);
    }];
    [self.firstLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.coverImageView.mas_bottom);
    }];
    [self.realTimeQuotesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(18));
        make.top.equalTo(weakSelf.firstLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.secondLineView.mas_top);
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(17));
        make.top.equalTo(weakSelf.firstLineView).offset(AUTOLAYOUTSIZE(14));
    }];
    [self.changeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.priceLabel);
        make.top.equalTo(weakSelf.priceLabel.mas_bottom);
    }];
    [self.realTimeQuotesButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.firstLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.secondLineView.mas_top);
    }];
    [self.secondLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(36));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.firstLineView.mas_bottom).offset(AUTOLAYOUTSIZE(60));
    }];
    [self.tradingMarketLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.realTimeQuotesLabel);
        make.top.equalTo(weakSelf.secondLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.boxView);
    }];
    [self.tradingMarketImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(34.5));
        make.right.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(17));
        make.centerY.equalTo(weakSelf.tradingMarketLabel);
    }];
    [self.tradingMarketButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.secondLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.boxView);
    }];
}

#pragma mark ------ Event Responds ------
/**
 项目全览
 */
- (void)respondsToProjectOverview {
    self.clickButtonBlock(0);
}
/**
 实时行情
 */
- (void)respondsToRealTimeQuotesButton {
    self.clickButtonBlock(1);
}
/**
 交易市场
 */
- (void)respondsToTradingMarketButton {
    self.clickButtonBlock(2);
}

#pragma mark ------ Public Methods ------
- (void)clickButtonBlock:(ClickButtonBlock)clickButtonBlock {
    self.clickButtonBlock = clickButtonBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setProjectModel:(DBHInformationModelData *)projectModel {
    _projectModel = projectModel;
    
    [self.coverImageView sdsetImageWithURL:_projectModel.coverImg placeholderImage:[UIImage imageNamed:@"fenxiang_jietu"]];
    NSString *price = [UserSignData share].user.walletUnitType == 1 ? _projectModel.ico.priceCny : _projectModel.ico.priceUsd;
    self.priceLabel.text = [NSString stringWithFormat:@"%@%.2lf", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", price.floatValue];
    self.changeLabel.text = [NSString stringWithFormat:@"%@%.2lf%%", _projectModel.ico.percentChange24h.floatValue >= 0 ? @"+" : @"", _projectModel.ico.percentChange24h.floatValue];
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIImageView alloc] init];
        _boxView.backgroundColor = [UIColor whiteColor];
        _boxView.layer.cornerRadius = AUTOLAYOUTSIZE(5);
        _boxView.clipsToBounds = YES;
        _boxView.userInteractionEnabled = YES;
    }
    return _boxView;
}
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToProjectOverview)];
        [_coverImageView addGestureRecognizer:tapGR];
    }
    return _coverImageView;
}
- (UIView *)firstLineView {
    if (!_firstLineView) {
        _firstLineView = [[UIView alloc] init];
        _firstLineView.backgroundColor = COLORFROM16(0xE4E4E4, 1);
    }
    return _firstLineView;
}
- (UILabel *)realTimeQuotesLabel {
    if (!_realTimeQuotesLabel) {
        _realTimeQuotesLabel = [[UILabel alloc] init];
        _realTimeQuotesLabel.font = FONT(13);
        _realTimeQuotesLabel.text = DBHGetStringWithKeyFromTable(@"Real-Time Quotes", nil);
        _realTimeQuotesLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _realTimeQuotesLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = BOLDFONT(15);
        _priceLabel.textColor = COLORFROM16(0xFF7624, 1);
    }
    return _priceLabel;
}
- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.font = FONT(10);
        _changeLabel.textColor = COLORFROM16(0xFF680F, 1);
    }
    return _changeLabel;
}
- (UIButton *)realTimeQuotesButton {
    if (!_realTimeQuotesButton) {
        _realTimeQuotesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_realTimeQuotesButton addTarget:self action:@selector(respondsToRealTimeQuotesButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _realTimeQuotesButton;
}
- (UIView *)secondLineView {
    if (!_secondLineView) {
        _secondLineView = [[UIView alloc] init];
        _secondLineView.backgroundColor = COLORFROM16(0xD2D2D2, 1);
    }
    return _secondLineView;
}
- (UILabel *)tradingMarketLabel {
    if (!_tradingMarketLabel) {
        _tradingMarketLabel = [[UILabel alloc] init];
        _tradingMarketLabel.font = FONT(13);
        _tradingMarketLabel.text = DBHGetStringWithKeyFromTable(@"Trading Market", nil);
        _tradingMarketLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _tradingMarketLabel;
}
- (UIImageView *)tradingMarketImageView {
    if (!_tradingMarketImageView) {
        _tradingMarketImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuzhuye_jiaoyishichang"]];
    }
    return _tradingMarketImageView;
}
- (UIButton *)tradingMarketButton {
    if (!_tradingMarketButton) {
        _tradingMarketButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tradingMarketButton addTarget:self action:@selector(respondsToTradingMarketButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tradingMarketButton;
}

@end
