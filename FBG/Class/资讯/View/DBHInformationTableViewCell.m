//
//  DBHInformationTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInformationTableViewCell.h"

@interface DBHInformationTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation DBHInformationTableViewCell

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
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.changeLabel];
    [self.contentView addSubview:self.timeLabel];
    
    WEAKSELF
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(45));
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.top.offset(AUTOLAYOUTSIZE(10));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.width.offset(AUTOLAYOUTSIZE(203));
        make.bottom.offset(- AUTOLAYOUTSIZE(10.5));
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLabel);
        make.right.equalTo(weakSelf.changeLabel.mas_left).offset(- AUTOLAYOUTSIZE(10));
    }];
    [self.changeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset([NSString getWidthtWithString:@"+11.09" fontSize:AUTOLAYOUTSIZE(11)] + AUTOLAYOUTSIZE(4));
        make.height.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.titleLabel);
        make.right.offset(- AUTOLAYOUTSIZE(15));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.changeLabel);
        make.centerY.equalTo(weakSelf.contentLabel);
    }];
    
    self.iconImageView.image = [UIImage imageNamed:@"zhuye_inwe_ico"];
    self.titleLabel.text = @"NEO（NEO）";
    self.contentLabel.text = @"（3条）新韩银行推出跨境比特币韩银行推出跨境比特币韩银行推出跨境比特币";
    self.priceLabel.text = @"$87.07";
    self.changeLabel.text = @"+11.09";
    self.timeLabel.text = @"2017-11-11";
}

#pragma mark ------ Getters And Setters ------
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.layer.cornerRadius = AUTOLAYOUTSIZE(5);
    }
    return _iconImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(14);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = FONT(13);
        _contentLabel.textColor = COLORFROM16(0xA5A5A5, 1);
    }
    return _contentLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = FONT(11);
        _priceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _priceLabel;
}
- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.backgroundColor = COLORFROM16(0x008C55, 1);
        _changeLabel.font = FONT(11);
        _changeLabel.textColor = COLORFROM16(0xFFFFFF, 1);
        _changeLabel.textAlignment = NSTextAlignmentCenter;
        _changeLabel.layer.cornerRadius = AUTOLAYOUTSIZE(2);
        _changeLabel.clipsToBounds = YES;
    }
    return _changeLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = FONT(10);
        _timeLabel.textColor = COLORFROM16(0xD8D8D8, 1);
    }
    return _timeLabel;
}

@end
