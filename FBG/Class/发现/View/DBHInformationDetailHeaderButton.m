//
//  DBHInformationDetailHeaderButton.m
//  FBG
//
//  Created by 邓毕华 on 2017/12/7.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailHeaderButton.h"

@interface DBHInformationDetailHeaderButton ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIImageView *extendImageView;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation DBHInformationDetailHeaderButton

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
    [self addSubview:self.leftLabel];
    [self addSubview:self.extendImageView];
    [self addSubview:self.bottomLineView];
    
    WEAKSELF
    [self.leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf);
        make.left.offset(AUTOLAYOUTSIZE(12));
        make.centerY.equalTo(weakSelf);
    }];
    [self.extendImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.offset(- AUTOLAYOUTSIZE(20));
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.bottom.equalTo(weakSelf);
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
        _leftLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(16)];
        _leftLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _leftLabel;
}
- (UIImageView *)extendImageView {
    if (!_extendImageView) {
        _extendImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down"]];
    }
    return _extendImageView;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xE6E6E6, 1);
    }
    return _bottomLineView;
}

@end
