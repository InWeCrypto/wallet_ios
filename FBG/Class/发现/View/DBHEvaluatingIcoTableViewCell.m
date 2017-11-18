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

@property (nonatomic, strong) UIView *boxView;
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
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.officialWebsiteLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.bottomLineView];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(23));
        make.height.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
    [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(117.5));
        make.height.offset(AUTOLAYOUTSIZE(77));
        make.left.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(18.5));
        make.top.offset(AUTOLAYOUTSIZE(17.5));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.coverImageView.mas_right).offset(AUTOLAYOUTSIZE(8.5));
        make.right.equalTo(weakSelf.bottomLineView);
        make.top.equalTo(weakSelf.coverImageView);
    }];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.titleLabel);
        make.centerX.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.officialWebsiteLabel.mas_top).offset(- AUTOLAYOUTSIZE(10));
    }];
    [self.officialWebsiteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.titleLabel);
        make.centerX.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.timeLabel.mas_top).offset(- AUTOLAYOUTSIZE(10));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.titleLabel);
        make.centerX.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.coverImageView);
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(20));
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHEvaluatingIcoModelData *)model {
    _model = model;
    
    [self.coverImageView sdsetImageWithURL:_model.img placeholderImage:[UIImage imageNamed:@""]];
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:_model.title];
    [titleAttributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, _model.title.length)];
    self.titleLabel.attributedText = titleAttributedString;
    
    self.stateLabel.text = [NSString stringWithFormat:@"目前状态：%@", _model.assessStatus];
    self.officialWebsiteLabel.text = [NSString stringWithFormat:@"官网：%@", _model.website];
    self.timeLabel.text = _model.updatedAt;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = [UIColor colorWithHexString:@"2EAFEA"];
    }
    return _boxView;
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
        _titleLabel.font = [UIFont boldSystemFontOfSize:AUTOLAYOUTSIZE(13)];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(9)];
        _stateLabel.textColor = [UIColor whiteColor];
    }
    return _stateLabel;
}
- (UILabel *)officialWebsiteLabel {
    if (!_officialWebsiteLabel) {
        _officialWebsiteLabel = [[UILabel alloc] init];
        _officialWebsiteLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(9)];
        _officialWebsiteLabel.textColor = [UIColor whiteColor];
    }
    return _officialWebsiteLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(9)];
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return _timeLabel;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomLineView;
}

@end
