
//
//  DBHInformationDetailForInweReportSelectedView.m
//  FBG
//
//  Created by 邓毕华 on 2017/12/7.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForInweReportSelectedView.h"

@interface DBHInformationDetailForInweReportSelectedView ()

@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *imageTextButton;
@property (nonatomic, strong) UIView *selectedLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, copy) SelectedButtonBlock selectedButtonBlock;

@end

@implementation DBHInformationDetailForInweReportSelectedView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.videoButton];
    [self addSubview:self.imageTextButton];
    [self addSubview:self.selectedLineView];
    [self addSubview:self.bottomLineView];
    
    WEAKSELF
    [self.videoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).multipliedBy(0.2);
        make.height.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
    }];
    [self.imageTextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.videoButton);
        make.left.equalTo(weakSelf.videoButton.mas_right);
        make.centerY.equalTo(weakSelf);
    }];
    [self.selectedLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(32));
        make.height.offset(AUTOLAYOUTSIZE(2));
        make.bottom.equalTo(weakSelf.bottomLineView.mas_top).offset(- AUTOLAYOUTSIZE(1.5));
        make.centerX.equalTo([weakSelf viewWithTag:200 + weakSelf.currentSelectedIndex]);
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.bottom.equalTo(weakSelf);
    }];
}

#pragma mark ------ Event Responds ------
- (void)respondsToSelectedButton:(UIButton *)button {
    if (button.tag - 200 == self.currentSelectedIndex) {
        return;
    }
    
    WEAKSELF
    [self.selectedLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(32));
        make.height.offset(AUTOLAYOUTSIZE(2));
        make.bottom.equalTo(weakSelf.bottomLineView.mas_top).offset(- AUTOLAYOUTSIZE(1.5));
        make.centerX.equalTo(button);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
    
    self.currentSelectedIndex = button.tag - 200;
    self.selectedButtonBlock(self.currentSelectedIndex);
}

#pragma mark ------ Public Methods ------
- (void)selectedButtonBlock:(SelectedButtonBlock)selectedButtonBlock {
    self.selectedButtonBlock = selectedButtonBlock;
}

#pragma mark ------ Getters And Setters ------
- (UIButton *)videoButton {
    if (!_videoButton) {
        _videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _videoButton.tag = 200;
        _videoButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        [_videoButton setTitle:@"视频" forState:UIControlStateNormal];
        [_videoButton setTitleColor:COLORFROM16(0x333333, 1) forState:UIControlStateNormal];
        [_videoButton addTarget:self action:@selector(respondsToSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoButton;
}
- (UIButton *)imageTextButton {
    if (!_imageTextButton) {
        _imageTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageTextButton.tag = 201;
        _imageTextButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        [_imageTextButton setTitle:@"图文" forState:UIControlStateNormal];
        [_imageTextButton setTitleColor:COLORFROM16(0x333333, 1) forState:UIControlStateNormal];
        [_imageTextButton addTarget:self action:@selector(respondsToSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageTextButton;
}
- (UIView *)selectedLineView {
    if (!_selectedLineView) {
        _selectedLineView = [[UIView alloc] init];
        _selectedLineView.backgroundColor = COLORFROM16(0xFF7800, 1);
    }
    return _selectedLineView;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xE6E6E6, 1);
    }
    return _bottomLineView;
}

@end
