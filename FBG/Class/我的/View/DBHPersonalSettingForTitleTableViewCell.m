//
//  DBHPersonalSettingForTitleTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHPersonalSettingForTitleTableViewCell.h"

@interface DBHPersonalSettingForTitleTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *moreImageView;

@end

@implementation DBHPersonalSettingForTitleTableViewCell

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
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.moreImageView];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.moreImageView.mas_left).offset(- AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.moreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(4.5));
        make.height.offset(AUTOLAYOUTSIZE(8.5));
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.valueLabel.hidden = ![_title isEqualToString:DBHGetStringWithKeyFromTable(@"Account Number", nil)] && ![_title isEqualToString:DBHGetStringWithKeyFromTable(@"Nickname", nil)];
    self.moreImageView.hidden = [_title isEqualToString:DBHGetStringWithKeyFromTable(@"Account Number", nil)];
    self.valueLabel.textColor = [_title isEqualToString:DBHGetStringWithKeyFromTable(@"Account Number", nil)] ? COLORFROM16(0xB4B4B4, 1) : COLORFROM16(0x333333, 1);
    
    WEAKSELF
    if ([_title isEqualToString:DBHGetStringWithKeyFromTable(@"Account Number", nil)]) {
        [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(- AUTOLAYOUTSIZE(15));
            make.centerY.equalTo(weakSelf.contentView);
        }];
    } else {
        [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.moreImageView.mas_left).offset(- AUTOLAYOUTSIZE(10));
            make.centerY.equalTo(weakSelf.contentView);
        }];
    }
    
    self.titleLabel.text = DBHGetStringWithKeyFromTable(_title, nil);;
}
- (void)setValue:(NSString *)value {
    _value = value;
    
    self.valueLabel.text = _value;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(13);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = FONT(13);
    }
    return _valueLabel;
}
- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fanhui"]];
    }
    return _moreImageView;
}

@end
