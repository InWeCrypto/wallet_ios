//
//  DBHAllInformationTypeOneTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHAllInformationTypeOneTableViewCell.h"

#import "DBHAllInformationModelData.h"

@interface DBHAllInformationTypeOneTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *infomationLabel;
@property (nonatomic, strong) UIImageView *collectImageView;

@end

@implementation DBHAllInformationTypeOneTableViewCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.playImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.infomationLabel];
    [self.contentView addSubview:self.collectImageView];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(23));
        make.height.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(10));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(175));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.boxView);
        make.bottom.equalTo(weakSelf.coverImageView.mas_top);
    }];
    [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(146.5));
        make.height.offset(AUTOLAYOUTSIZE(96));
        make.left.offset(AUTOLAYOUTSIZE(21));
        make.top.offset(AUTOLAYOUTSIZE(31));
    }];
    [self.playImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.coverImageView);
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.coverImageView);
        make.left.equalTo(weakSelf.coverImageView.mas_right).offset(AUTOLAYOUTSIZE(14));
        make.right.offset(- AUTOLAYOUTSIZE(18));
        make.bottom.equalTo(weakSelf.coverImageView);
    }];
    [self.infomationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.coverImageView);
        make.bottom.offset(- AUTOLAYOUTSIZE(13.5));
    }];
    [self.collectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(8));
        make.left.equalTo(weakSelf.infomationLabel.mas_right).offset(AUTOLAYOUTSIZE(9.5));
        make.centerY.equalTo(weakSelf.infomationLabel);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHAllInformationModelData *)model {
    _model = model;
    
    WEAKSELF
    CGFloat contentHeight = [NSString getHeightWithString:_model.content width:SCREENWIDTH - AUTOLAYOUTSIZE(222.5) lineSpacing:AUTOLAYOUTSIZE(5) fontSize:AUTOLAYOUTSIZE(7)];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.coverImageView);
        make.left.equalTo(weakSelf.coverImageView.mas_right).offset(AUTOLAYOUTSIZE(14));
        make.right.offset(- AUTOLAYOUTSIZE(18));
        make.height.offset(contentHeight >= AUTOLAYOUTSIZE(96) ? AUTOLAYOUTSIZE(96) : contentHeight);
    }];
    
    [self.coverImageView sdsetImageWithURL:_model.img placeholderImage:[UIImage imageNamed:@""]];
    self.playImageView.hidden = _model.type == 2;
    self.titleLabel.text = _model.title;
    
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:_model.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:AUTOLAYOUTSIZE(5)];
    [contentAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _model.content.length)];

    self.contentLabel.attributedText = contentAttributedString;
    self.infomationLabel.text = [NSString stringWithFormat:@"%@  |  阅读：%ld  |  回复：%ld |   %@", _model.updatedAt, (NSInteger)_model.clickRate, (NSInteger)_model.commentsCount, _model.saveUser == 1 ? @"已收藏" : @"收藏"];
    self.collectImageView.image = [UIImage imageNamed:_model.saveUser == 1 ? @"icon_market_like" : @"icon_market_unlike"];
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = [UIColor colorWithHexString:@"1B96D1"];
    }
    return _boxView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = [UIColor lightGrayColor];
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
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(7)];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (UILabel *)infomationLabel {
    if (!_infomationLabel) {
        _infomationLabel = [[UILabel alloc] init];
        _infomationLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(9)];
        _infomationLabel.textColor = [UIColor whiteColor];
    }
    return _infomationLabel;
}
- (UIImageView *)collectImageView {
    if (!_collectImageView) {
        _collectImageView = [[UIImageView alloc] init];
    }
    return _collectImageView;
}

@end
