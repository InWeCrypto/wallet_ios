//
//  DBHEvaluatingIcoTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHEvaluatingIcoTableViewCell.h"

#import "DBHEvaluatingIcoModelData.h"

@interface DBHEvaluatingIcoTableViewCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *officialWebsiteLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation DBHEvaluatingIcoTableViewCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.officialWebsiteLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.bottomLineView];
    
    WEAKSELF
    [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(30));
        make.height.offset(AUTOLAYOUTSIZE(203));
        make.top.offset(AUTOLAYOUTSIZE(11));
        make.centerX.top.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).multipliedBy(0.5);
        make.left.equalTo(weakSelf.coverImageView);
        make.top.equalTo(weakSelf.coverImageView.mas_bottom).offset(AUTOLAYOUTSIZE(10));
    }];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.coverImageView);
        make.centerY.equalTo(weakSelf.titleLabel);
    }];
    [self.officialWebsiteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.coverImageView);
        make.right.equalTo(weakSelf.coverImageView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(8));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.coverImageView);
        make.top.equalTo(weakSelf.officialWebsiteLabel.mas_bottom).offset(AUTOLAYOUTSIZE(8));
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.coverImageView);
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHEvaluatingIcoModelData *)model {
    _model = model;
    
    [self.coverImageView sdsetImageWithURL:_model.img placeholderImage:[UIImage imageNamed:@""]];
    
    self.titleLabel.text = _model.title;
    self.stateLabel.text = [NSString stringWithFormat:@"目前状态：%@", _model.assessStatus];
    self.officialWebsiteLabel.text = [NSString stringWithFormat:@"官网：%@", _model.website];
    self.timeLabel.text = _model.updatedAt;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = PICTURECOLOR;
    }
    return _coverImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:AUTOLAYOUTSIZE(14)];
        _titleLabel.textColor = COLORFROM16(0x404040, 1);
    }
    return _titleLabel;
}
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(9)];
        _stateLabel.textColor = COLORFROM16(0xB0B0B0, 1);
    }
    return _stateLabel;
}
- (UILabel *)officialWebsiteLabel {
    if (!_officialWebsiteLabel) {
        _officialWebsiteLabel = [[UILabel alloc] init];
        _officialWebsiteLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(9)];
        _officialWebsiteLabel.textColor = COLORFROM16(0x545252, 1);
    }
    return _officialWebsiteLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(9)];
        _timeLabel.textColor = COLORFROM16(0xB0B0B0, 1);
    }
    return _timeLabel;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xD4D4D4, 1);
    }
    return _bottomLineView;
}

@end
