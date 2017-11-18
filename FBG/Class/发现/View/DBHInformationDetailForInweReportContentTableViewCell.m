//
//  DBHInformationDetailForInweReportContentTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForInweReportContentTableViewCell.h"

#import "DBHInformationDetailForInweModelData.h"

@interface DBHInformationDetailForInweReportContentTableViewCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation DBHInformationDetailForInweReportContentTableViewCell

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
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.playImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.bottomLineView];
    
    WEAKSELF
    [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(183));
        make.height.offset(AUTOLAYOUTSIZE(104));
        make.left.offset(AUTOLAYOUTSIZE(11.5));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.playImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.coverImageView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.coverImageView.mas_right).offset(AUTOLAYOUTSIZE(13.5));
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.top.equalTo(weakSelf.coverImageView);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.titleLabel);
        make.left.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(6));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.titleLabel);
        make.left.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(AUTOLAYOUTSIZE(7.5));
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(23));
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHInformationDetailForInweModelData *)model {
    _model = model;
    
    [self.coverImageView sdsetImageWithURL:_model.img placeholderImage:[UIImage imageNamed:@""]];
    self.playImageView.hidden = _model.type == 2;
    self.titleLabel.text = _model.title;
    self.nameLabel.text = _model.content;
    self.timeLabel.text = _model.updatedAt;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = PICTURECOLOR;
    }
    return _coverImageView;
}
- (UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_play"]];
        _playImageView.hidden = YES;
    }
    return _playImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(9)];
        _titleLabel.textColor = COLORFROM16(0xFF7043, 1);
    }
    return _titleLabel;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _timeLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _timeLabel;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xE6E6E6, 1);
    }
    return _bottomLineView;
}

@end
