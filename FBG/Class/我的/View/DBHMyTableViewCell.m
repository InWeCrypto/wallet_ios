//
//  DBHMyTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/11.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHMyTableViewCell.h"

@interface DBHMyTableViewCell ()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *moreImageView;

@end

@implementation DBHMyTableViewCell

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
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.titleLabel];
    
    WEAKSELF
    [self.leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(34));
        make.left.offset(AUTOLAYOUTSIZE(34));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImageView.mas_right).offset(AUTOLAYOUTSIZE(20));
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = _title;
}
- (void)setLeftImageName:(NSString *)leftImageName {
    _leftImageName = leftImageName;
    
    self.leftImageView.image = [UIImage imageNamed:_leftImageName];
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _titleLabel;
}

@end
