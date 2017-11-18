//
//  DBHInformationDetailForCrowdfundingContentViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForCrowdfundingContentTableViewCell.h"

#import "DBHInformationDetailModelProjectDetail.h"

@interface DBHInformationDetailForCrowdfundingContentTableViewCell ()

@property (nonatomic, strong) UILabel *firstRiskGradeLabel;
@property (nonatomic, strong) UIView *firstRiskGradeView;
@property (nonatomic, strong) UILabel *firstRiskGradeValueLabel;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *icoScaleLabel;
@property (nonatomic, strong) UILabel *icoScaleValueLabel;
@property (nonatomic, strong) UILabel *grossLabel;
@property (nonatomic, strong) UILabel *grossValueLabel;
@property (nonatomic, strong) UILabel *acceptCurrencyLabel;
@property (nonatomic, strong) UILabel *acceptCurrencyValueLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *startTimeValueLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *endTimeValueLabel;
@property (nonatomic, strong) UILabel *raisePeriodsLabel;
@property (nonatomic, strong) UILabel *raisePeriodsValueLabel;
@property (nonatomic, strong) UILabel *timingLabel;
@property (nonatomic, strong) UILabel *tensOfDayLabel;
@property (nonatomic, strong) UILabel *unitOfDayLabel;
@property (nonatomic, strong) UILabel *tensOfHourLabel;
@property (nonatomic, strong) UILabel *unitOfHourLabel;
@property (nonatomic, strong) UILabel *tensOfMinuteLabel;
@property (nonatomic, strong) UILabel *unitOfMinuteLabel;
@property (nonatomic, strong) UILabel *tensOfSecondLabel;
@property (nonatomic, strong) UILabel *unitOfSecondLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UIView *sumView;
@property (nonatomic, strong) UIView *currentHaveView;
@property (nonatomic, strong) UIImageView *currentValueImageView;
@property (nonatomic, strong) UILabel *currentValueLabel;
@property (nonatomic, strong) UILabel *hasBeenRaiseLabel;
@property (nonatomic, strong) UILabel *goalLabel;

@end

@implementation DBHInformationDetailForCrowdfundingContentTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.firstRiskGradeLabel];
    [self.contentView addSubview:self.firstRiskGradeView];
    [self.contentView addSubview:self.firstRiskGradeValueLabel];
    [self.contentView addSubview:self.boxView];
    [self.contentView addSubview:self.icoScaleLabel];
    [self.contentView addSubview:self.icoScaleValueLabel];
    [self.contentView addSubview:self.grossLabel];
    [self.contentView addSubview:self.grossValueLabel];
    [self.contentView addSubview:self.acceptCurrencyLabel];
    [self.contentView addSubview:self.acceptCurrencyValueLabel];
    [self.contentView addSubview:self.startTimeLabel];
    [self.contentView addSubview:self.startTimeValueLabel];
    [self.contentView addSubview:self.endTimeLabel];
    [self.contentView addSubview:self.endTimeValueLabel];
    [self.contentView addSubview:self.raisePeriodsLabel];
    [self.contentView addSubview:self.raisePeriodsValueLabel];
    [self.contentView addSubview:self.timingLabel];
    [self.contentView addSubview:self.tensOfDayLabel];
    [self.contentView addSubview:self.unitOfDayLabel];
    [self.contentView addSubview:self.tensOfHourLabel];
    [self.contentView addSubview:self.unitOfHourLabel];
    [self.contentView addSubview:self.tensOfMinuteLabel];
    [self.contentView addSubview:self.unitOfMinuteLabel];
    [self.contentView addSubview:self.tensOfSecondLabel];
    [self.contentView addSubview:self.unitOfSecondLabel];
    [self.contentView addSubview:self.dayLabel];
    [self.contentView addSubview:self.hourLabel];
    [self.contentView addSubview:self.minuteLabel];
    [self.contentView addSubview:self.secondLabel];
    [self.contentView addSubview:self.sumView];
    [self.contentView addSubview:self.currentHaveView];
    [self.contentView addSubview:self.currentValueImageView];
    [self.contentView addSubview:self.currentValueLabel];
    [self.contentView addSubview:self.hasBeenRaiseLabel];
    [self.contentView addSubview:self.goalLabel];
    
    WEAKSELF
    [self.firstRiskGradeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.boxView);
        make.top.offset(AUTOLAYOUTSIZE(10));
    }];
    [self.firstRiskGradeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(11));
        make.left.equalTo(weakSelf.firstRiskGradeLabel.mas_right);
        make.centerY.equalTo(weakSelf.firstRiskGradeLabel);
    }];
    [self.firstRiskGradeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.firstRiskGradeView.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.firstRiskGradeLabel);
    }];
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(23));
        make.height.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(39));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
    [self.icoScaleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(10));
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(7.5));
    }];
    [self.icoScaleValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.icoScaleLabel);
        make.top.equalTo(weakSelf.icoScaleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(4));
    }];
    [self.grossLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(10.5));
        make.centerY.equalTo(weakSelf.icoScaleLabel);
    }];
    [self.grossValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grossLabel);
        make.centerY.equalTo(weakSelf.icoScaleValueLabel);
    }];
    
    [self.acceptCurrencyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.icoScaleLabel);
    }];
    [self.acceptCurrencyValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.acceptCurrencyLabel);
        make.centerY.equalTo(weakSelf.icoScaleValueLabel);
    }];
    [self.startTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.icoScaleLabel);
        make.top.equalTo(weakSelf.icoScaleValueLabel.mas_bottom).offset(AUTOLAYOUTSIZE(10));
    }];
    [self.startTimeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.startTimeLabel);
        make.top.equalTo(weakSelf.startTimeLabel.mas_bottom).offset(AUTOLAYOUTSIZE(4));
    }];
    [self.endTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grossLabel);
        make.centerY.equalTo(weakSelf.startTimeLabel);
    }];
    [self.endTimeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grossLabel);
        make.centerY.equalTo(weakSelf.startTimeValueLabel);
    }];
    [self.raisePeriodsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.acceptCurrencyLabel);
        make.centerY.equalTo(weakSelf.startTimeLabel);
    }];
    [self.raisePeriodsValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.acceptCurrencyLabel);
        make.centerY.equalTo(weakSelf.startTimeValueLabel);
    }];
    [self.timingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.startTimeValueLabel.mas_bottom).offset(AUTOLAYOUTSIZE(15.5));
    }];
    [self.tensOfDayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(14));
        make.height.offset(AUTOLAYOUTSIZE(26.5));
        make.top.equalTo(weakSelf.timingLabel.mas_bottom).offset(AUTOLAYOUTSIZE(8));
        make.right.equalTo(weakSelf.unitOfDayLabel.mas_left).offset(- AUTOLAYOUTSIZE(7));
    }];
    [self.unitOfDayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.tensOfDayLabel);
        make.centerY.equalTo(weakSelf.tensOfDayLabel);
        make.right.equalTo(weakSelf.tensOfHourLabel.mas_left).offset(- AUTOLAYOUTSIZE(14.5));
    }];
    [self.tensOfHourLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.tensOfDayLabel);
        make.centerY.equalTo(weakSelf.tensOfDayLabel);
        make.right.equalTo(weakSelf.unitOfHourLabel.mas_left).offset(- AUTOLAYOUTSIZE(7));
    }];
    [self.unitOfHourLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.tensOfDayLabel);
        make.centerY.equalTo(weakSelf.tensOfDayLabel);
        make.right.equalTo(weakSelf.boxView.mas_centerX).offset(- AUTOLAYOUTSIZE(7.25));
    }];
    [self.tensOfMinuteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.tensOfDayLabel);
        make.centerY.equalTo(weakSelf.tensOfDayLabel);
        make.left.equalTo(weakSelf.boxView.mas_centerX).offset(AUTOLAYOUTSIZE(7.25));
    }];
    [self.unitOfMinuteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.tensOfDayLabel);
        make.centerY.equalTo(weakSelf.tensOfDayLabel);
        make.left.equalTo(weakSelf.tensOfMinuteLabel.mas_right).offset(AUTOLAYOUTSIZE(7));
    }];
    [self.tensOfSecondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.tensOfDayLabel);
        make.centerY.equalTo(weakSelf.tensOfDayLabel);
        make.left.equalTo(weakSelf.unitOfMinuteLabel.mas_right).offset(AUTOLAYOUTSIZE(14.5));
    }];
    [self.unitOfSecondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.tensOfDayLabel);
        make.centerY.equalTo(weakSelf.tensOfDayLabel);
        make.left.equalTo(weakSelf.tensOfSecondLabel.mas_right).offset(AUTOLAYOUTSIZE(7));
    }];
    [self.dayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.tensOfDayLabel);
        make.right.equalTo(weakSelf.unitOfDayLabel);
        make.top.equalTo(weakSelf.tensOfDayLabel.mas_bottom).offset(AUTOLAYOUTSIZE(8));
    }];
    [self.hourLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.tensOfHourLabel);
        make.right.equalTo(weakSelf.unitOfHourLabel);
        make.centerY.equalTo(weakSelf.dayLabel);
    }];
    [self.minuteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.tensOfMinuteLabel);
        make.right.equalTo(weakSelf.unitOfMinuteLabel);
        make.centerY.equalTo(weakSelf.dayLabel);
    }];
    [self.secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.tensOfSecondLabel);
        make.right.equalTo(weakSelf.unitOfSecondLabel);
        make.centerY.equalTo(weakSelf.dayLabel);
    }];
    [self.sumView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(100));
        make.height.offset(AUTOLAYOUTSIZE(14));
        make.centerX.equalTo(weakSelf.boxView);
        make.bottom.offset(- AUTOLAYOUTSIZE(31));
    }];
    [self.currentHaveView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(0.5));
        make.height.equalTo(weakSelf.sumView);
        make.left.centerY.equalTo(weakSelf.sumView);
    }];
    [self.currentValueImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(18));
        make.height.offset(AUTOLAYOUTSIZE(21.5));
        make.bottom.equalTo(weakSelf.currentHaveView.mas_top);
        make.centerX.equalTo(weakSelf.currentHaveView.mas_right);
    }];
    [self.currentValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.currentValueImageView);
        make.height.offset(AUTOLAYOUTSIZE(18));
        make.top.centerX.equalTo(weakSelf.currentValueImageView);
    }];
    [self.hasBeenRaiseLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.sumView);
        make.top.equalTo(weakSelf.sumView.mas_bottom);
        make.bottom.equalTo(weakSelf.boxView);
    }];
    [self.goalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.sumView);
        make.centerY.equalTo(weakSelf.hasBeenRaiseLabel);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHInformationDetailModelProjectDetail *)model {
    _model = model;
    
    self.firstRiskGradeValueLabel.text = _model.riskLevelName;
    self.firstRiskGradeView.backgroundColor = [UIColor colorWithHexString:[_model.riskLevelColor substringFromIndex:1]];
    self.icoScaleValueLabel.text = _model.icoScale;
    self.grossValueLabel.text = _model.total;
    self.acceptCurrencyValueLabel.text = _model.accept;
    self.startTimeValueLabel.text = _model.startAt;
    self.endTimeValueLabel.text = _model.endAt;
    self.raisePeriodsValueLabel.text = _model.crowdfundPeriods;
    self.currentValueLabel.text = [NSString stringWithFormat:@"%.2lf%%", _model.currentQuantity.floatValue / _model.targetQuantity.floatValue * 100];
    self.hasBeenRaiseLabel.text = [NSString stringWithFormat:@"已募集：%ldKNC", _model.currentQuantity.integerValue];
    self.goalLabel.text = [NSString stringWithFormat:@"目标：%ldKNC", _model.targetQuantity.integerValue];
    
    WEAKSELF
    [self.currentHaveView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.sumView).multipliedBy(_model.currentQuantity.floatValue >= _model.targetQuantity.floatValue ? 1 : _model.currentQuantity.floatValue / _model.targetQuantity.floatValue);
        make.height.equalTo(weakSelf.sumView);
        make.left.centerY.equalTo(weakSelf.sumView);
    }];
    [self.currentValueImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset([NSString getWidthtWithString:[NSString stringWithFormat:@"%.2lf%%", _model.currentQuantity.floatValue / _model.targetQuantity.floatValue * 100] fontSize:AUTOLAYOUTSIZE(8)] + AUTOLAYOUTSIZE(5));
        make.height.offset(AUTOLAYOUTSIZE(21.5));
        make.bottom.equalTo(weakSelf.currentHaveView.mas_top);
        make.centerX.equalTo(weakSelf.currentHaveView.mas_right);
    }];
}

- (UILabel *)firstRiskGradeLabel {
    if (!_firstRiskGradeLabel) {
        _firstRiskGradeLabel = [[UILabel alloc] init];
        _firstRiskGradeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _firstRiskGradeLabel.text = @"风险等级：";
        _firstRiskGradeLabel.textColor = [UIColor whiteColor];
    }
    return _firstRiskGradeLabel;
}
- (UIView *)firstRiskGradeView {
    if (!_firstRiskGradeView) {
        _firstRiskGradeView = [[UIView alloc] init];
        _firstRiskGradeView.backgroundColor = [UIColor redColor];
    }
    return _firstRiskGradeView;
}
- (UILabel *)firstRiskGradeValueLabel {
    if (!_firstRiskGradeValueLabel) {
        _firstRiskGradeValueLabel = [[UILabel alloc] init];
        _firstRiskGradeValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _firstRiskGradeValueLabel.textColor = [UIColor whiteColor];
    }
    return _firstRiskGradeValueLabel;
}
- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = COLORFROM16(0x2DA4DA, 1);
    }
    return _boxView;
}
- (UILabel *)icoScaleLabel {
    if (!_icoScaleLabel) {
        _icoScaleLabel = [[UILabel alloc] init];
        _icoScaleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _icoScaleLabel.text = @"ICO规模";
        _icoScaleLabel.textColor = [UIColor whiteColor];
    }
    return _icoScaleLabel;
}
- (UILabel *)icoScaleValueLabel {
    if (!_icoScaleValueLabel) {
        _icoScaleValueLabel = [[UILabel alloc] init];
        _icoScaleValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _icoScaleValueLabel.textColor = [UIColor whiteColor];
    }
    return _icoScaleValueLabel;
}
- (UILabel *)grossLabel {
    if (!_grossLabel) {
        _grossLabel = [[UILabel alloc] init];
        _grossLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _grossLabel.text = @"总量";
        _grossLabel.textColor = [UIColor whiteColor];
    }
    return _grossLabel;
}
- (UILabel *)grossValueLabel {
    if (!_grossValueLabel) {
        _grossValueLabel = [[UILabel alloc] init];
        _grossValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _grossValueLabel.textColor = [UIColor whiteColor];
    }
    return _grossValueLabel;
}
- (UILabel *)acceptCurrencyLabel {
    if (!_acceptCurrencyLabel) {
        _acceptCurrencyLabel = [[UILabel alloc] init];
        _acceptCurrencyLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _acceptCurrencyLabel.text = @"接受币种";
        _acceptCurrencyLabel.textColor = [UIColor whiteColor];
    }
    return _acceptCurrencyLabel;
}
- (UILabel *)acceptCurrencyValueLabel {
    if (!_acceptCurrencyValueLabel) {
        _acceptCurrencyValueLabel = [[UILabel alloc] init];
        _acceptCurrencyValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _acceptCurrencyValueLabel.textColor = [UIColor whiteColor];
    }
    return _acceptCurrencyValueLabel;
}
- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        _startTimeLabel = [[UILabel alloc] init];
        _startTimeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _startTimeLabel.text = @"开始时间";
        _startTimeLabel.textColor = [UIColor whiteColor];
    }
    return _startTimeLabel;
}
- (UILabel *)startTimeValueLabel {
    if (!_startTimeValueLabel) {
        _startTimeValueLabel = [[UILabel alloc] init];
        _startTimeValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _startTimeValueLabel.textColor = [UIColor whiteColor];
    }
    return _startTimeValueLabel;
}
- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _endTimeLabel.text = @"结束时间";
        _endTimeLabel.textColor = [UIColor whiteColor];
    }
    return _endTimeLabel;
}
- (UILabel *)endTimeValueLabel {
    if (!_endTimeValueLabel) {
        _endTimeValueLabel = [[UILabel alloc] init];
        _endTimeValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _endTimeValueLabel.textColor = [UIColor whiteColor];
    }
    return _endTimeValueLabel;
}
- (UILabel *)raisePeriodsLabel {
    if (!_raisePeriodsLabel) {
        _raisePeriodsLabel = [[UILabel alloc] init];
        _raisePeriodsLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _raisePeriodsLabel.text = @"众筹期数";
        _raisePeriodsLabel.textColor = [UIColor whiteColor];
    }
    return _raisePeriodsLabel;
}
- (UILabel *)raisePeriodsValueLabel {
    if (!_raisePeriodsValueLabel) {
        _raisePeriodsValueLabel = [[UILabel alloc] init];
        _raisePeriodsValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _raisePeriodsValueLabel.textColor = [UIColor whiteColor];
    }
    return _raisePeriodsValueLabel;
}
- (UILabel *)timingLabel {
    if (!_timingLabel) {
        _timingLabel = [[UILabel alloc] init];
        _timingLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _timingLabel.text = @"离项目开始";
        _timingLabel.textColor = [UIColor whiteColor];
    }
    return _timingLabel;
}
- (UILabel *)tensOfDayLabel {
    if (!_tensOfDayLabel) {
        _tensOfDayLabel = [[UILabel alloc] init];
        _tensOfDayLabel.backgroundColor = COLORFROM16(0x346699, 1);
        _tensOfDayLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _tensOfDayLabel.text = @"0";
        _tensOfDayLabel.textColor = [UIColor whiteColor];
        _tensOfDayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tensOfDayLabel;
}
- (UILabel *)unitOfDayLabel {
    if (!_unitOfDayLabel) {
        _unitOfDayLabel = [[UILabel alloc] init];
        _unitOfDayLabel.backgroundColor = COLORFROM16(0x346699, 1);
        _unitOfDayLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _unitOfDayLabel.text = @"0";
        _unitOfDayLabel.textColor = [UIColor whiteColor];
        _unitOfDayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _unitOfDayLabel;
}
- (UILabel *)tensOfHourLabel {
    if (!_tensOfHourLabel) {
        _tensOfHourLabel = [[UILabel alloc] init];
        _tensOfHourLabel.backgroundColor = COLORFROM16(0x346699, 1);
        _tensOfHourLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _tensOfHourLabel.text = @"0";
        _tensOfHourLabel.textColor = [UIColor whiteColor];
        _tensOfHourLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tensOfHourLabel;
}
- (UILabel *)unitOfHourLabel {
    if (!_unitOfHourLabel) {
        _unitOfHourLabel = [[UILabel alloc] init];
        _unitOfHourLabel.backgroundColor = COLORFROM16(0x346699, 1);
        _unitOfHourLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _unitOfHourLabel.text = @"0";
        _unitOfHourLabel.textColor = [UIColor whiteColor];
        _unitOfHourLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _unitOfHourLabel;
}
- (UILabel *)tensOfMinuteLabel {
    if (!_tensOfMinuteLabel) {
        _tensOfMinuteLabel = [[UILabel alloc] init];
        _tensOfMinuteLabel.backgroundColor = COLORFROM16(0x346699, 1);
        _tensOfMinuteLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _tensOfMinuteLabel.text = @"0";
        _tensOfMinuteLabel.textColor = [UIColor whiteColor];
        _tensOfMinuteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tensOfMinuteLabel;
}
- (UILabel *)unitOfMinuteLabel {
    if (!_unitOfMinuteLabel) {
        _unitOfMinuteLabel = [[UILabel alloc] init];
        _unitOfMinuteLabel.backgroundColor = COLORFROM16(0x346699, 1);
        _unitOfMinuteLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _unitOfMinuteLabel.text = @"0";
        _unitOfMinuteLabel.textColor = [UIColor whiteColor];
        _unitOfMinuteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _unitOfMinuteLabel;
}
- (UILabel *)tensOfSecondLabel {
    if (!_tensOfSecondLabel) {
        _tensOfSecondLabel = [[UILabel alloc] init];
        _tensOfSecondLabel.backgroundColor = COLORFROM16(0x346699, 1);
        _tensOfSecondLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _tensOfSecondLabel.text = @"0";
        _tensOfSecondLabel.textColor = [UIColor whiteColor];
        _tensOfSecondLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tensOfSecondLabel;
}
- (UILabel *)unitOfSecondLabel {
    if (!_unitOfSecondLabel) {
        _unitOfSecondLabel = [[UILabel alloc] init];
        _unitOfSecondLabel.backgroundColor = COLORFROM16(0x346699, 1);
        _unitOfSecondLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _unitOfSecondLabel.text = @"0";
        _unitOfSecondLabel.textColor = [UIColor whiteColor];
        _unitOfSecondLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _unitOfSecondLabel;
}
- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _dayLabel.text = @"天";
        _dayLabel.textColor = [UIColor whiteColor];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dayLabel;
}
- (UILabel *)hourLabel {
    if (!_hourLabel) {
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _hourLabel.text = @"时";
        _hourLabel.textColor = [UIColor whiteColor];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hourLabel;
}
- (UILabel *)minuteLabel {
    if (!_minuteLabel) {
        _minuteLabel = [[UILabel alloc] init];
        _minuteLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _minuteLabel.text = @"分";
        _minuteLabel.textColor = [UIColor whiteColor];
        _minuteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _minuteLabel;
}
- (UILabel *)secondLabel {
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _secondLabel.text = @"秒";
        _secondLabel.textColor = [UIColor whiteColor];
        _secondLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _secondLabel;
}
- (UIView *)sumView {
    if (!_sumView) {
        _sumView = [[UIView alloc] init];
        _sumView.backgroundColor = COLORFROM16(0x346699, 1);
    }
    return _sumView;
}
- (UIView *)currentHaveView {
    if (!_currentHaveView) {
        _currentHaveView = [[UIView alloc] init];
        _currentHaveView.backgroundColor = COLORFROM16(0x66CC66, 1);
    }
    return _currentHaveView;
}
- (UIImageView *)currentValueImageView {
    if (!_currentValueImageView) {
        _currentValueImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"矩形93"]];
    }
    return _currentValueImageView;
}
- (UILabel *)currentValueLabel {
    if (!_currentValueLabel) {
        _currentValueLabel = [[UILabel alloc] init];
        _currentValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _currentValueLabel.text = @"0%";
        _currentValueLabel.textColor = [UIColor whiteColor];
        _currentValueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentValueLabel;
}
- (UILabel *)hasBeenRaiseLabel {
    if (!_hasBeenRaiseLabel) {
        _hasBeenRaiseLabel = [[UILabel alloc] init];
        _hasBeenRaiseLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _hasBeenRaiseLabel.text = @"已募集：0KNC";
        _hasBeenRaiseLabel.textColor = [UIColor whiteColor];
    }
    return _hasBeenRaiseLabel;
}
- (UILabel *)goalLabel {
    if (!_goalLabel) {
        _goalLabel = [[UILabel alloc] init];
        _goalLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _goalLabel.text = @"目标：0KNC";
        _goalLabel.textColor = [UIColor whiteColor];
    }
    return _goalLabel;
}

@end
