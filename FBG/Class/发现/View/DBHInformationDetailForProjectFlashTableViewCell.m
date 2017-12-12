//
//  DBHInformationDetailForProjectFlashTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/12/6.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForProjectFlashTableViewCell.h"

@interface DBHInformationDetailForProjectFlashTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *orangeCircleView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation DBHInformationDetailForProjectFlashTableViewCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.orangeCircleView];
    [self.contentView addSubview:self.contentLabel];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(weakSelf.contentView.mas_height);
        make.left.centerY.equalTo(weakSelf.contentView);
    }];
    [self.orangeCircleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(5));
        make.left.equalTo(weakSelf.titleLabel.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.orangeCircleView.mas_right).offset(AUTOLAYOUTSIZE(6));
        make.right.offset(- AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = COLORFROM16(0xFF7800, 1);
        _titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _titleLabel.text = @"项目\n快讯";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UIView *)orangeCircleView {
    if (!_orangeCircleView) {
        _orangeCircleView = [[UIView alloc] init];
        _orangeCircleView.backgroundColor = COLORFROM16(0xFF7800, 1);
        _orangeCircleView.layer.cornerRadius = AUTOLAYOUTSIZE(2.5);
    }
    return _orangeCircleView;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _contentLabel.text = @"Kyber Network（KNC）即将开始ICO";
        _contentLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _contentLabel;
}

@end
