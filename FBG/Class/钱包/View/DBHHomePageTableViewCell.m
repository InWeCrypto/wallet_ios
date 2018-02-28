//
//  DBHHomePageTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHHomePageTableViewCell.h"

#import "DBHWalletDetailTokenInfomationModelData.h"

@interface DBHHomePageTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation DBHHomePageTableViewCell

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
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numberLabel];
    
    WEAKSELF
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(20));
        make.left.offset(AUTOLAYOUTSIZE(33));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- AUTOLAYOUTSIZE(33));
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHWalletDetailTokenInfomationModelData *)model {
    _model = model;
    
    if ([_model.flag isEqualToString:@"NEO"] || [_model.flag isEqualToString:@"Gas"] || [_model.flag isEqualToString:@"ETH"]) {
        self.iconImageView.image = [UIImage imageNamed:_model.icon];
    } else {
        [self.iconImageView sdsetImageWithURL:_model.icon placeholderImage:[UIImage imageNamed:@"NEO_add"]];
    }
    self.nameLabel.text = _model.name;
    self.numberLabel.text = [NSString stringWithFormat:@"%.5lf", _model.balance.floatValue];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = PICTURECOLOR;
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
        _numberLabel.font = FONT(13);
        _numberLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _numberLabel;
}

@end
