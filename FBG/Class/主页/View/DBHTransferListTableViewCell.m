//
//  DBHTransferListTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTransferListTableViewCell.h"

#import "DBHTransferListModelList.h"

@interface DBHTransferListTableViewCell ()

@property (nonatomic, strong) UIImageView *stateImageView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation DBHTransferListTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bottomLineWidth = SCREENWIDTH - AUTOLAYOUTSIZE(48);
        self.bottomLineViewColor = COLORFROM16(0xF6F6F6, 1);
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.stateImageView];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.stateLabel];
    
    WEAKSELF
    [self.stateImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(36));
        make.left.offset(AUTOLAYOUTSIZE(32.5));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).multipliedBy(0.4);
        make.left.equalTo(weakSelf.stateImageView.mas_right).offset(AUTOLAYOUTSIZE(14));
        make.top.offset(AUTOLAYOUTSIZE(12));
    }];
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- AUTOLAYOUTSIZE(24));
        make.centerY.equalTo(weakSelf.addressLabel);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressLabel);
        make.centerY.equalTo(weakSelf.stateLabel);
    }];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.numberLabel);
        make.bottom.offset(- AUTOLAYOUTSIZE(11));
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHTransferListModelList *)model {
    _model = model;
    
    if (!_model.transferType) {
        self.stateImageView.image = [UIImage imageNamed:@"自转"];
        self.numberLabel.text = [NSString stringWithFormat:@"%.8lf", _model.value.floatValue];
    } else {
        self.stateImageView.image = [UIImage imageNamed:_model.transferType == 1 ? @"转出" : @"转入"];
        self.numberLabel.text = [NSString stringWithFormat:@"%@%.8lf", _model.transferType == 1 ? @"-" : @"+", _model.value.floatValue];
    }
    self.addressLabel.text = _model.tx;
    self.timeLabel.text = [NSString getLocalDateFormateUTCDate:_model.createTime];
    self.stateLabel.text = ![NSObject isNulllWithObject:_model.confirmTime] ? @"交易成功" : @"待确认";
}

- (UIImageView *)stateImageView {
    if (!_stateImageView) {
        _stateImageView = [[UIImageView alloc] init];
    }
    return _stateImageView;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = FONT(13);
        _addressLabel.textColor = COLORFROM16(0x3D3D3D, 1);
    }
    return _addressLabel;
}
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = FONT(13);
        _numberLabel.textColor = COLORFROM16(0xFE1C1C, 1);
    }
    return _numberLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = FONT(12);
        _timeLabel.textColor = COLORFROM16(0xC5C5C5, 1);
    }
    return _timeLabel;
}
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = FONT(12);
        _stateLabel.textColor = COLORFROM16(0x3D3D3D, 1);
    }
    return _stateLabel;
}

@end
