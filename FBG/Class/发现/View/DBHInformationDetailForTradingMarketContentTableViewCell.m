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

//@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *terraceLabel;
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
//    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.terraceLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.turnoverLabel];
    [self.contentView addSubview:self.refreshTimeLabel];
    [self.contentView addSubview:self.bottomLineView];
    
    WEAKSELF
//    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.offset(AUTOLAYOUTSIZE(14));
//        make.left.offset(AUTOLAYOUTSIZE(19));
//        make.centerY.equalTo(weakSelf.contentView);
//    }];
    [self.terraceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(18));
        make.top.offset(AUTOLAYOUTSIZE(14));
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- AUTOLAYOUTSIZE(20));
        make.centerY.equalTo(weakSelf.terraceLabel);
    }];
    [self.turnoverLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.terraceLabel);
        make.bottom.offset(- AUTOLAYOUTSIZE(8.5));
    }];
    [self.refreshTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- AUTOLAYOUTSIZE(10.5));
        make.centerY.equalTo(weakSelf.turnoverLabel);
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(24));
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.bottom.centerX.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHInformationDetailForTradingMarketContentModelData *)model {
    _model = model;
    
    NSMutableAttributedString *terraceLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", _model.source, _model.pair]];
    [terraceLabelAttributedString addAttributes:@{NSForegroundColorAttributeName:COLORFROM16(0x333333, 1), NSFontAttributeName:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)]} range:NSMakeRange(0, _model.source.length)];
    
    self.terraceLabel.attributedText = terraceLabelAttributedString;
    self.priceLabel.text = [NSString stringWithFormat:@"≈$%.2lf", _model.pairce.floatValue];
    self.turnoverLabel.text = [NSString stringWithFormat:@"Volume %@", _model.volum24];
    self.refreshTimeLabel.text = _model.update;
}

//- (UIImageView *)iconImageView {
//    if (!_iconImageView) {
//        _iconImageView = [[UIImageView alloc] init];
//        _iconImageView.backgroundColor = PICTURECOLOR;
//    }
//    return _iconImageView;
//}
- (UILabel *)terraceLabel {
    if (!_terraceLabel) {
        _terraceLabel = [[UILabel alloc] init];
        _terraceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(10)];
        _terraceLabel.textColor = COLORFROM16(0x666666, 1);
    }
    return _terraceLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _priceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _priceLabel;
}
- (UILabel *)turnoverLabel {
    if (!_turnoverLabel) {
        _turnoverLabel = [[UILabel alloc] init];
        _turnoverLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(10)];
        _turnoverLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _turnoverLabel;
}
- (UILabel *)refreshTimeLabel {
    if (!_refreshTimeLabel) {
        _refreshTimeLabel = [[UILabel alloc] init];
        _refreshTimeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(10)];
        _refreshTimeLabel.textColor = COLORFROM16(0x666666, 1);
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
