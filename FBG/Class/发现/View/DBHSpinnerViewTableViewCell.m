//
//  DBHSpinnerViewTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/17.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHSpinnerViewTableViewCell.h"

@interface DBHSpinnerViewTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation DBHSpinnerViewTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLORFROM16(0x161F26, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.bottomLineView];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(13));
        make.right.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = _title;
}
- (void)setIsHiddenBottomLineView:(BOOL)isHiddenBottomLineView {
    _isHiddenBottomLineView = isHiddenBottomLineView;
    
    self.bottomLineView.hidden = _isHiddenBottomLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xFFFFFF, 1);
    }
    return _bottomLineView;
}

@end
