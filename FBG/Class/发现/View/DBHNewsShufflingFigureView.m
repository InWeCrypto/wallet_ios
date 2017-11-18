//
//  DBHNewsShufflingFigureView.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHNewsShufflingFigureView.h"

@interface DBHNewsShufflingFigureView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation DBHNewsShufflingFigureView

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf).multipliedBy(0.5);
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf).multipliedBy(1.5);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = _title;
}
- (void)setContent:(NSString *)content {
    _content = content;
    
    self.contentLabel.text = _content;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"97BDDB"];
    }
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(9)];
        _contentLabel.textColor = [UIColor colorWithHexString:@"97BDDB"];
    }
    return _contentLabel;
}

@end
