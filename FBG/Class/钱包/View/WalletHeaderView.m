//
//  WalletHeaderView.m
//  FBG
//
//  Created by mac on 2017/7/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "WalletHeaderView.h"

@interface WalletHeaderView ()

@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation WalletHeaderView

- (void)drawRect:(CGRect)rect
{
    NSMutableAttributedString *ethNameAttributedString = [[NSMutableAttributedString alloc] initWithString:@"ETH链"];
    [ethNameAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)] range:NSMakeRange(3, 1)];
    self.ethNameLabel.attributedText = ethNameAttributedString;
    
    NSMutableAttributedString *neoNameAttributedString = [[NSMutableAttributedString alloc] initWithString:@"NEO链"];
    [neoNameAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)] range:NSMakeRange(3, 1)];
    self.neoNameLabel.attributedText = neoNameAttributedString;
    
    self.totleLB.text = NSLocalizedString(@"Total Assets", nil);
    
    self.leftButton.selected = YES;
    self.rightButton.selected = NO;
    [self addSubview:self.bottomLineView];
    
    WEAKSELF
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).multipliedBy(0.5).offset(- AUTOLAYOUTSIZE(40));
        make.height.offset(AUTOLAYOUTSIZE(2));
        make.centerX.equalTo(weakSelf.leftButton);
        make.bottom.equalTo(weakSelf.leftButton);
    }];
}

#pragma mark ------ Event Responds ------
- (IBAction)respondsToEthButton:(UIButton *)sender {
    WEAKSELF
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).multipliedBy(0.5).offset(- AUTOLAYOUTSIZE(40));
        make.height.offset(AUTOLAYOUTSIZE(2));
        make.centerX.equalTo(sender);
        make.bottom.equalTo(weakSelf.leftButton);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}
- (IBAction)respondsToNeoButton:(UIButton *)sender {
    WEAKSELF
    [self.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).multipliedBy(0.5).offset(- AUTOLAYOUTSIZE(40));
        make.height.offset(AUTOLAYOUTSIZE(2));
        make.centerX.equalTo(weakSelf.rightButton);
        make.bottom.equalTo(weakSelf.leftButton);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

#pragma mark ------ Getters And Setters ------
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM10(18, 139, 87, 1);
    }
    return _bottomLineView;
}

@end
