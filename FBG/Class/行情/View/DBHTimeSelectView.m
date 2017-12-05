//
//  DBHTimeSelectView.m
//  FBG
//
//  Created by 邓毕华 on 2017/12/5.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHTimeSelectView.h"

#import "DBHMarketDetailKLineViewModelData.h"

@interface DBHTimeSelectView ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *openLabel;
@property (nonatomic, strong) UILabel *heightLabel;
@property (nonatomic, strong) UILabel *lowLabel;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, copy) ClickTimeBlock clickTimeBlock;
@property (nonatomic, copy) NSArray *timeTitleArray;

@end

@implementation DBHTimeSelectView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = COLORFROM16(0x1D1C1C, 1);
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    WEAKSELF
    for (NSInteger i = 0; i < self.timeTitleArray.count; i++) {
        UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        timeButton.tag = 200 + i;
        timeButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(15)];
        timeButton.selected = i == self.currentSelectedIndex;
        [timeButton setTitle:self.timeTitleArray[i] forState:UIControlStateNormal];
        [timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [timeButton setBackgroundImage:[UIImage getImageFromColor:COLORFROM16(0x1D1C1C, 1) Rect:CGRectMake(0, 0, SCREEN_WIDTH / (CGFloat)self.timeTitleArray.count, AUTOLAYOUTSIZE(40))] forState:UIControlStateNormal];
        [timeButton setBackgroundImage:[UIImage getImageFromColor:COLORFROM10(42, 46, 51, 1) Rect:CGRectMake(0, 0, SCREEN_WIDTH / (CGFloat)self.timeTitleArray.count, AUTOLAYOUTSIZE(40))] forState:UIControlStateSelected];
        [timeButton setBackgroundImage:[UIImage getImageFromColor:COLORFROM16(0x1D1C1C, 1) Rect:CGRectMake(0, 0, SCREEN_WIDTH / (CGFloat)self.timeTitleArray.count, AUTOLAYOUTSIZE(40))] forState:UIControlStateHighlighted];
        [timeButton addTarget:self action:@selector(respondsToTimeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:timeButton];
        
        [timeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf).multipliedBy(1.0 / weakSelf.timeTitleArray.count);
            make.height.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf);
            if (!i) {
                make.left.equalTo(weakSelf);
            } else {
                make.left.equalTo([weakSelf viewWithTag:199 + i].mas_right);
            }
        }];
    }
    
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.openLabel];
    [self.boxView addSubview:self.heightLabel];
    [self.boxView addSubview:self.lowLabel];
    [self.boxView addSubview:self.incomeLabel];
    [self.boxView addSubview:self.amountLabel];
    
    [self. boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf);
        make.center.equalTo(weakSelf);
    }];
    [self.openLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).multipliedBy(0.2);
        make.height.equalTo(weakSelf.boxView);
        make.left.equalTo(weakSelf.boxView);
        make.centerY.equalTo(weakSelf);
    }];
    [self.heightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.openLabel);
        make.left.equalTo(weakSelf.openLabel.mas_right);
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.lowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.openLabel);
        make.left.equalTo(weakSelf.heightLabel.mas_right);
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.incomeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.openLabel);
        make.left.equalTo(weakSelf.lowLabel.mas_right);
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.openLabel);
        make.left.equalTo(weakSelf.incomeLabel.mas_right);
        make.centerY.equalTo(weakSelf.boxView);
    }];
}

#pragma mark ------ Event Responds ------
/**
 选择时间
 */
- (void)respondsToTimeButton:(UIButton *)timeButton {
    if (timeButton.tag - 200 == self.currentSelectedIndex) {
        return;
    }
    
    self.clickTimeBlock(self.timeValueArray[timeButton.tag - 200]);
    
    UIButton *lastSelectedButton = [self viewWithTag:200 + self.currentSelectedIndex];
    lastSelectedButton.selected = NO;
    
    timeButton.selected = YES;
    self.currentSelectedIndex = timeButton.tag - 200;
}

#pragma mark ------ Public Methods ------
- (void)clickTimeBlock:(ClickTimeBlock)clickTimeBlock {
    self.clickTimeBlock = clickTimeBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setIsShowData:(BOOL)isShowData {
    _isShowData = isShowData;
    
    self.boxView.hidden = !_isShowData;
}
- (void)setModel:(DBHMarketDetailKLineViewModelData *)model {
    _model = model;
    
    NSString *openString = [NSString stringWithFormat:@"%.2lf", _model.openedPrice.floatValue];
    NSMutableAttributedString *openAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"开  %@", openString]];
    [openAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(3, openString.length)];
    
    NSString *heightString = [NSString stringWithFormat:@"%.2lf", _model.maxPrice.floatValue];
    NSMutableAttributedString *heightAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"高  %@", heightString]];
    [heightAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(3, heightString.length)];
    
    NSString *lowString = [NSString stringWithFormat:@"%.2lf", _model.minPrice.floatValue];
    NSMutableAttributedString *lowAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"低  %@", lowString]];
    [lowAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(3, lowString.length)];
    
    NSString *incomeString = [NSString stringWithFormat:@"%.2lf", _model.closedPrice.floatValue];
    NSMutableAttributedString *incomeAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收  %@", incomeString]];
    [incomeAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(3, incomeString.length)];
    
    NSString *amountString = [NSString stringWithFormat:@"%.2lf", _model.volume.floatValue];
    NSMutableAttributedString *amountAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"量  %@", amountString]];
    [amountAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(3, amountString.length)];
    
    self.openLabel.attributedText = openAttributedString;
    self.heightLabel.attributedText = heightAttributedString;
    self.lowLabel.attributedText = lowAttributedString;
    self.incomeLabel.attributedText = incomeAttributedString;
    self.amountLabel.attributedText = amountAttributedString;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = COLORFROM10(42, 46, 51, 1);
        _boxView.hidden = YES;
    }
    return _boxView;
}
- (UILabel *)openLabel {
    if (!_openLabel) {
        _openLabel = [[UILabel alloc] init];
        _openLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _openLabel.textColor = [UIColor grayColor];
        _openLabel.text = @"开";
    }
    return _openLabel;
}
- (UILabel *)heightLabel {
    if (!_heightLabel) {
        _heightLabel = [[UILabel alloc] init];
        _heightLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _heightLabel.textColor = [UIColor grayColor];
        _heightLabel.text = @"高";
    }
    return _heightLabel;
}
- (UILabel *)lowLabel {
    if (!_lowLabel) {
        _lowLabel = [[UILabel alloc] init];
        _lowLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _lowLabel.textColor = [UIColor grayColor];
        _lowLabel.text = @"低";
    }
    return _lowLabel;
}
- (UILabel *)incomeLabel {
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc] init];
        _incomeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _incomeLabel.textColor = [UIColor grayColor];
        _incomeLabel.text = @"收";
    }
    return _incomeLabel;
}
- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _amountLabel.textColor = [UIColor grayColor];
        _amountLabel.text = @"量";
    }
    return _amountLabel;
}

- (NSArray *)timeTitleArray {
    if (!_timeTitleArray) {
        _timeTitleArray = @[@"1min",
                            @"5min",
                            @"15min",
                            @"30min",
                            @"1小时",
                            @"天",
                            @"周"];
    }
    return _timeTitleArray;
}
- (NSArray *)timeValueArray {
    if (!_timeValueArray) {
        _timeValueArray = @[@"1m",
                            @"5m",
                            @"15m",
                            @"30m",
                            @"1h",
                            @"1d",
                            @"1w"];
    }
    return _timeValueArray;
}

@end
