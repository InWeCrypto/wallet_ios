//
//  DBHSearchTitleView.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSearchTitleView.h"

@interface DBHSearchTitleView ()

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation DBHSearchTitleView

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
    [self addSubview:self.searchTextField];
    [self addSubview:self.cancelButton];
    
    WEAKSELF
    [self.searchTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(AUTOLAYOUTSIZE(40));
        make.centerY.equalTo(weakSelf);
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.right.equalTo(weakSelf.cancelButton.mas_left);
    }];
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf);
        make.width.offset(AUTOLAYOUTSIZE(66));
        make.right.equalTo(weakSelf);
    }];
}

#pragma mark ------ Event Responds ------
/**
 取消
 */
- (void)respondsToCancelButton {
    
}

#pragma mark ------ Getters And Setters ------
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.font = FONT(13);
        _searchTextField.placeholder = DBHGetStringWithKeyFromTable(@"Information", nil);
        _searchTextField.textColor = COLORFROM16(0x333333, 1);
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AUTOLAYOUTSIZE(40), AUTOLAYOUTSIZE(40))];
        UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhuye_sousuo_ico"]];
        searchImageView.frame = CGRectMake(AUTOLAYOUTSIZE(15), AUTOLAYOUTSIZE(12.5), AUTOLAYOUTSIZE(15), AUTOLAYOUTSIZE(15));
        [leftView addSubview:searchImageView];
        _searchTextField.leftView = leftView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _searchTextField;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = FONT(18);
        [_cancelButton setTitle:DBHGetStringWithKeyFromTable(@"Cancel", nil) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:COLORFROM16(0x333333, 1) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(respondsToCancelButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
