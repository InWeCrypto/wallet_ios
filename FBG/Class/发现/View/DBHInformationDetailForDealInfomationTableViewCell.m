//
//  DBHInformationDetailForDealInfomationTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForDealInfomationTableViewCell.h"

#import "DBHInformationDetailModelProjectTimePrices.h"
#import "DBHInformationDetailForNewMoneyPriceDataModels.h"

@interface DBHInformationDetailForDealInfomationTableViewCell ()

@property (nonatomic, strong) UILabel *currentPriceLabel;
@property (nonatomic, strong) UIButton *explorerButton;
@property (nonatomic, strong) UIButton *supportWalletButton;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UILabel *volumeValueLabel;
@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, strong) UILabel *maxValueLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *minValueLabel;
@property (nonatomic, strong) UIButton *lookKLineButton;

@property (nonatomic, strong) DBHInformationDetailForNewMoneyPriceModelData *usdmoneyPriceModel; // 美元最新货币价格
@property (nonatomic, strong) DBHInformationDetailForNewMoneyPriceModelData *btcmoneyPriceModel; // BTC最新货币价格

@end

@implementation DBHInformationDetailForDealInfomationTableViewCell

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
    [self.contentView addSubview:self.currentPriceLabel];
    [self.contentView addSubview:self.explorerButton];
    [self.contentView addSubview:self.supportWalletButton];
    [self.contentView addSubview:self.changeLabel];
    [self.contentView addSubview:self.volumeLabel];
    [self.contentView addSubview:self.volumeValueLabel];
    [self.contentView addSubview:self.maxLabel];
    [self.contentView addSubview:self.maxValueLabel];
    [self.contentView addSubview:self.minLabel];
    [self.contentView addSubview:self.minValueLabel];
    [self.contentView addSubview:self.lookKLineButton];
    
    WEAKSELF
    [self.currentPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(12));
        make.right.equalTo(weakSelf.explorerButton.mas_left).offset(- AUTOLAYOUTSIZE(5));
        make.top.offset(AUTOLAYOUTSIZE(8.5));
    }];
    [self.explorerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(54));
        make.height.offset(AUTOLAYOUTSIZE(22));
        make.right.equalTo(weakSelf.supportWalletButton.mas_left).offset(- AUTOLAYOUTSIZE(8));
        make.centerY.equalTo(weakSelf.supportWalletButton);
    }];
    [self.supportWalletButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(66));
        make.height.offset(AUTOLAYOUTSIZE(22));
        make.right.offset(- AUTOLAYOUTSIZE(12));
        make.top.offset(AUTOLAYOUTSIZE(10));
    }];
    [self.changeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.currentPriceLabel);
        make.top.equalTo(weakSelf.currentPriceLabel.mas_bottom).offset(AUTOLAYOUTSIZE(10));
    }];
    [self.volumeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.currentPriceLabel);
        make.top.equalTo(weakSelf.changeLabel.mas_bottom).offset(AUTOLAYOUTSIZE(10));
    }];
    [self.volumeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(152));
        make.right.offset(- AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.volumeLabel);
    }];
    [self.maxLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.currentPriceLabel);
        make.top.equalTo(weakSelf.volumeLabel.mas_bottom).offset(AUTOLAYOUTSIZE(10));
    }];
    [self.maxValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.volumeValueLabel);
        make.left.equalTo(weakSelf.volumeValueLabel);
        make.centerY.equalTo(weakSelf.maxLabel);
    }];
    [self.minLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.currentPriceLabel);
        make.top.equalTo(weakSelf.maxLabel.mas_bottom).offset(AUTOLAYOUTSIZE(10));
    }];
    [self.minValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.volumeValueLabel);
        make.left.equalTo(weakSelf.volumeValueLabel);
        make.centerY.equalTo(weakSelf.minLabel);
    }];
    [self.lookKLineButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(70.5));
        make.height.offset(AUTOLAYOUTSIZE(37.5));
        make.right.bottom.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Data ------
/**
 获取项目详细数据
 */
- (void)getNewMoneyPriceDataWithModel:(DBHInformationDetailModelProjectTimePrices *)model {
    WEAKSELF
    [PPNetworkHelper GET:model.currentUrl isOtherBaseUrl:YES parameters:nil hudString:nil success:^(id responseObject) {
        if ([model.name isEqualToString:@"美元"]) {
            // 美元
            weakSelf.usdmoneyPriceModel = [DBHInformationDetailForNewMoneyPriceModelData modelObjectWithDictionary:responseObject];
        } else {
            // 比特币
            weakSelf.btcmoneyPriceModel = [DBHInformationDetailForNewMoneyPriceModelData modelObjectWithDictionary:responseObject];
        }
        
        [weakSelf refreshData];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Private Methods ------
/**
 刷新货币价格
 */
- (void)refreshData {
    if (self.btcmoneyPriceModel && self.usdmoneyPriceModel) {
        self.currentPriceLabel.text = [NSString stringWithFormat:@"$%@ /%@ BTC", [NSString getValueWithString:self.usdmoneyPriceModel.price], [NSString getValueWithString:self.btcmoneyPriceModel.price]];
        self.changeLabel.text = [NSString stringWithFormat:@"(%.2lf)", self.btcmoneyPriceModel.change24h];
        self.volumeValueLabel.text = [NSString stringWithFormat:@"$%.0lf/%.2lf BTC", self.usdmoneyPriceModel.volume, self.btcmoneyPriceModel.volume];
        self.maxValueLabel.text = [NSString stringWithFormat:@"$%@/%@ BTC", [NSString getValueWithString:self.usdmoneyPriceModel.maxPrice24h], [NSString getValueWithString:self.btcmoneyPriceModel.maxPrice24h]];
        self.minValueLabel.text = [NSString stringWithFormat:@"$%@/%@ BTC", [NSString getValueWithString:self.usdmoneyPriceModel.minPrice24h], [NSString getValueWithString:self.btcmoneyPriceModel.minPrice24h]];
        self.changeLabel.textColor = self.usdmoneyPriceModel.change24h >= 0 ? COLORFROM16(0xFF3232, 1) : COLORFROM16(0x22AC39, 1);
    }
}

#pragma mark ------ Event Responds ------
/**
 浏览器
 */
- (void)respondsToExplorerButton {
    
}
/**
 支持钱包
 */
- (void)respondsToSupportWalletButton {
    
}
/**
 查看K线
 */
- (void)respondsToLookKLineButton {
    
}

#pragma mark ------ Getters And Setters ------
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    for (DBHInformationDetailModelProjectTimePrices *model in _dataSource) {
        if ([model.name isEqualToString:@"美元"] || [model.name isEqualToString:@"比特币"]) {
            [self getNewMoneyPriceDataWithModel:model];
        }
    }
}

- (UILabel *)currentPriceLabel {
    if (!_currentPriceLabel) {
        _currentPriceLabel = [[UILabel alloc] init];
        _currentPriceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _currentPriceLabel.text = @"当前价格";
        _currentPriceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _currentPriceLabel;
}
- (UIButton *)explorerButton {
    if (!_explorerButton) {
        _explorerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _explorerButton.layer.cornerRadius = AUTOLAYOUTSIZE(1.5);
        _explorerButton.layer.borderWidth = AUTOLAYOUTSIZE(0.5);
        _explorerButton.layer.borderColor = COLORFROM16(0x333333, 1).CGColor;
        _explorerButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        [_explorerButton setTitle:@"浏览器>" forState:UIControlStateNormal];
        [_explorerButton setTitleColor:COLORFROM16(0x333333, 1) forState:UIControlStateNormal];
        [_explorerButton addTarget:self action:@selector(respondsToExplorerButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _explorerButton;
}
- (UIButton *)supportWalletButton {
    if (!_supportWalletButton) {
        _supportWalletButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _supportWalletButton.layer.cornerRadius = AUTOLAYOUTSIZE(1.5);
        _supportWalletButton.layer.borderWidth = AUTOLAYOUTSIZE(0.5);
        _supportWalletButton.layer.borderColor = COLORFROM16(0x333333, 1).CGColor;
        _supportWalletButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        [_supportWalletButton setTitle:@"支持钱包>" forState:UIControlStateNormal];
        [_supportWalletButton setTitleColor:COLORFROM16(0x333333, 1) forState:UIControlStateNormal];
        [_supportWalletButton addTarget:self action:@selector(respondsToSupportWalletButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _supportWalletButton;
}
- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _changeLabel.textColor = COLORFROM16(0x22AC39, 1);
    }
    return _changeLabel;
}
- (UILabel *)volumeLabel {
    if (!_volumeLabel) {
        _volumeLabel = [[UILabel alloc] init];
        _volumeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _volumeLabel.text = @"Volume";
        _volumeLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _volumeLabel;
}
- (UILabel *)volumeValueLabel {
    if (!_volumeValueLabel) {
        _volumeValueLabel = [[UILabel alloc] init];
        _volumeValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _volumeValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _volumeValueLabel;
}
- (UILabel *)maxLabel {
    if (!_maxLabel) {
        _maxLabel = [[UILabel alloc] init];
        _maxLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _maxLabel.text = @"24H最高值";
        _maxLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _maxLabel;
}
- (UILabel *)maxValueLabel {
    if (!_maxValueLabel) {
        _maxValueLabel = [[UILabel alloc] init];
        _maxValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _maxValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _maxValueLabel;
}
- (UILabel *)minLabel {
    if (!_minLabel) {
        _minLabel = [[UILabel alloc] init];
        _minLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _minLabel.text = @"24H最低值";
        _minLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _minLabel;
}
- (UILabel *)minValueLabel {
    if (!_minValueLabel) {
        _minValueLabel = [[UILabel alloc] init];
        _minValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _minValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _minValueLabel;
}
- (UIButton *)lookKLineButton {
    if (!_lookKLineButton) {
        _lookKLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookKLineButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        
        NSString *lookKLine = @"查看K线";
        NSMutableAttributedString *lookKLineAttributedString = [[NSMutableAttributedString alloc] initWithString:lookKLine];
        [lookKLineAttributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, lookKLine.length)];
        [_lookKLineButton setAttributedTitle:lookKLineAttributedString forState:UIControlStateNormal];
        
        [_lookKLineButton setTitleColor:COLORFROM16(0x333333, 1) forState:UIControlStateNormal];
        [_lookKLineButton addTarget:self action:@selector(respondsToLookKLineButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookKLineButton;
}

@end
