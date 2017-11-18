//
//  DBHAllInformationTypeTwoTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHAllInformationTypeTwoTableViewCell.h"

#import "DBHAllInformationModelData.h"
#import "DBHInformationDetailForInweModelData.h"

@interface DBHAllInformationTypeTwoTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infomationLabel;
@property (nonatomic, strong) UIImageView *collectImageView;

@end

@implementation DBHAllInformationTypeTwoTableViewCell

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
    [self.contentView addSubview:self.infomationLabel];
    [self.contentView addSubview:self.collectImageView];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(23));
        make.height.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(10));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(21));
        make.right.offset(- AUTOLAYOUTSIZE(33.5));
        make.top.equalTo(weakSelf.boxView);
        make.bottom.equalTo(weakSelf.infomationLabel.mas_top);
    }];
    [self.infomationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
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
    
    self.titleLabel.text = _model.title;
    self.infomationLabel.text = [NSString stringWithFormat:@"%@  |  阅读：%ld  |  回复：%ld |   %@", _model.updatedAt, (NSInteger)_model.clickRate, (NSInteger)_model.commentsCount, _model.saveUser == 1 ? @"已收藏" : @"收藏"];
    self.collectImageView.image = [UIImage imageNamed:_model.saveUser == 1 ? @"icon_market_like" : @"icon_market_unlike"];
}
- (void)setInweModel:(DBHInformationDetailForInweModelData *)inweModel {
    _inweModel = inweModel;
    
    self.titleLabel.text = _inweModel.title;
    self.infomationLabel.text = _inweModel.updatedAt;
    self.collectImageView.hidden = YES;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = [UIColor colorWithHexString:@"27C1B9"];
    }
    return _boxView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
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
