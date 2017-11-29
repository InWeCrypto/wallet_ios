
//
//  DBHSearchView.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/21.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHSearchView.h"

@interface DBHSearchView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *searchImageView;

@property (nonatomic, copy) KeywordsUpdateBlock keywordsUpdateBlock;

@end

@implementation DBHSearchView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = AUTOLAYOUTSIZE(4);
        self.backgroundColor = [UIColor colorWithHexString:@"161F26"];
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.searchImageView];
    [self addSubview:self.searchTextField];
    
    WEAKSELF
    [self.searchImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(16));
        make.centerY.equalTo(weakSelf);
        make.left.offset(AUTOLAYOUTSIZE(10));
    }];
    [self.searchTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.searchImageView.mas_right).offset(AUTOLAYOUTSIZE(5));
        make.right.equalTo(weakSelf);
    }];
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *changeAfterString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.keywordsUpdateBlock(changeAfterString);
    
    return YES;
}

#pragma mark ------ Public Methods ------
- (void)keywordsUpdateBlock:(KeywordsUpdateBlock)keywordsUpdateBlock {
    self.keywordsUpdateBlock = keywordsUpdateBlock;
}

#pragma mark ------ Getters And Setters ------
- (UIImageView *)searchImageView {
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_market_search"]];
    }
    return _searchImageView;
}
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"请输入关键字";
        _searchTextField.textColor = COLORFROM16(0x55637E, 1);
        _searchTextField.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_searchTextField setValue:COLORFROM16(0x55637E, 1) forKeyPath:@"_placeholderLabel.textColor"];
        
        _searchTextField.delegate = self;
    }
    return _searchTextField;
}

@end
