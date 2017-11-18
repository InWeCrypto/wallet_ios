
//
//  DBHMyHeaderView.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/9.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHMyHeaderView.h"

@interface DBHMyHeaderView ()

@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, copy) ClickButtonBlock clickButtonBlock;

@end

@implementation DBHMyHeaderView

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.editButton];
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.stateLabel];
    
    WEAKSELF
    [self.editButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(38.5));
        make.right.offset(- AUTOLAYOUTSIZE(13.75));
        make.top.offset(AUTOLAYOUTSIZE(2.5));
    }];
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(76));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.nameLabel.mas_top).offset(- AUTOLAYOUTSIZE(7.5));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).multipliedBy(0.5);
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.stateLabel.mas_top).offset(- AUTOLAYOUTSIZE(8));
    }];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(36));
        make.height.offset(AUTOLAYOUTSIZE(14));
        make.centerX.equalTo(weakSelf);
        make.bottom.offset(- AUTOLAYOUTSIZE(15));
    }];
}

#pragma mark ------ Event Responds ------
/**
 编辑
 */
- (void)respondsToEditButton {
    self.clickButtonBlock();
}
/**
 头像
 */
- (void)respondsToHeadImageView {
    self.clickButtonBlock();
}

#pragma mark ------ Public Methods ------
- (void)clickButtonBlock:(ClickButtonBlock)clickButtonBlock {
    self.clickButtonBlock = clickButtonBlock;
}

#pragma mark ------ Getters And Setter ------
- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setImage:[UIImage imageNamed:@"btn_edit"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(respondsToEditButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"默认头像"]];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.cornerRadius = AUTOLAYOUTSIZE(38);
        _headImageView.backgroundColor = [UIColor greenColor];
        _headImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToHeadImageView)];
        [_headImageView addGestureRecognizer:tapGR];
    }
    return _headImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(18)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.backgroundColor = [UIColor colorWithHexString:@"008C55"];
        _stateLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(10)];
        _stateLabel.text = @"已登录";
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.clipsToBounds = YES;
        _stateLabel.layer.cornerRadius = AUTOLAYOUTSIZE(7);
    }
    return _stateLabel;
}

@end
