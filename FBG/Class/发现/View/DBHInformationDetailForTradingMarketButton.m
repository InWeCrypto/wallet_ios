//
//  DBHInformationDetailForTradingMarketButton.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForTradingMarketButton.h"

@interface DBHInformationDetailForTradingMarketButton ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation DBHInformationDetailForTradingMarketButton

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
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightImageView];
    
    WEAKSELF
    [self.leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.rightImageView.mas_left).offset(- AUTOLAYOUTSIZE(6));
        make.centerY.equalTo(weakSelf);
    }];
    [self.rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(5.5));
        make.height.offset(AUTOLAYOUTSIZE(10));
        make.right.offset(- AUTOLAYOUTSIZE(7.5));
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setLeftTitle:(NSString *)leftTitle {
    _leftTitle = leftTitle;
    
    self.leftLabel.text = _leftTitle;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _leftLabel.textColor = [UIColor whiteColor];
    }
    return _leftLabel;
}
- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"矩形81"]];
    }
    return _rightImageView;
}

@end
