//
//  DBHInformationDetailForDealInfomationTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForDealInfomationTableViewCell.h"

#import "DBHInformationDetailModelProjectTimePrices.h"
#import "DBHInformationDetailForNewMoneyPriceDataModels.h"

@interface DBHInformationDetailForDealInfomationTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UILabel *currentPriceLabel;
@property (nonatomic, strong) UILabel *currentPriceValueLabel;
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UILabel *volumeValueLabel;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *changeValueLabel;
@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, strong) UILabel *maxValueLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *minValueLabel;

@property (nonatomic, strong) DBHInformationDetailForNewMoneyPriceModelData *moneyPriceModel; // 最新货币价格

@end

@implementation DBHInformationDetailForDealInfomationTableViewCell

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
    [self.contentView addSubview:self.boxView];
    [self.contentView addSubview:self.segmentedControl];
    [self.contentView addSubview:self.currentPriceLabel];
    [self.contentView addSubview:self.currentPriceValueLabel];
    [self.contentView addSubview:self.volumeLabel];
    [self.contentView addSubview:self.volumeValueLabel];
    [self.contentView addSubview:self.changeLabel];
    [self.contentView addSubview:self.changeValueLabel];
    [self.contentView addSubview:self.maxLabel];
    [self.contentView addSubview:self.maxValueLabel];
    [self.contentView addSubview:self.minLabel];
    [self.contentView addSubview:self.minValueLabel];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(23));
        make.height.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
    [self.segmentedControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(210));
        make.height.offset(AUTOLAYOUTSIZE(27));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.offset(AUTOLAYOUTSIZE(14));
    }];
    [self.currentPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(72));
        make.bottom.equalTo(weakSelf.volumeLabel.mas_top).offset(- AUTOLAYOUTSIZE(18));
    }];
    [self.currentPriceValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.segmentedControl.mas_centerX).offset(AUTOLAYOUTSIZE(70));
        make.right.equalTo(weakSelf.boxView);
        make.centerY.equalTo(weakSelf.currentPriceLabel);
    }];
    [self.volumeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.currentPriceLabel);
        make.bottom.equalTo(weakSelf.changeLabel.mas_top).offset(- AUTOLAYOUTSIZE(18));
    }];
    [self.volumeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.currentPriceValueLabel);
        make.left.equalTo(weakSelf.currentPriceValueLabel);
        make.centerY.equalTo(weakSelf.volumeLabel);
    }];
    [self.changeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.currentPriceLabel);
        make.bottom.equalTo(weakSelf.maxLabel.mas_top).offset(- AUTOLAYOUTSIZE(18));
    }];
    [self.changeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.currentPriceValueLabel);
        make.left.equalTo(weakSelf.currentPriceValueLabel);
        make.centerY.equalTo(weakSelf.changeLabel);
    }];
    [self.maxLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.currentPriceLabel);
        make.bottom.equalTo(weakSelf.minLabel.mas_top).offset(- AUTOLAYOUTSIZE(18));
    }];
    [self.maxValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.currentPriceValueLabel);
        make.left.equalTo(weakSelf.currentPriceValueLabel);
        make.centerY.equalTo(weakSelf.maxLabel);
    }];
    [self.minLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.currentPriceLabel);
        make.bottom.offset(- AUTOLAYOUTSIZE(39));
    }];
    [self.minValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.currentPriceValueLabel);
        make.left.equalTo(weakSelf.currentPriceValueLabel);
        make.centerY.equalTo(weakSelf.minLabel);
    }];
}

#pragma mark ------ Data ------
/**
 获取项目详细数据
 */
- (void)getNewMoneyPriceDataWithUrl:(NSString *)url {
    WEAKSELF
    [PPNetworkHelper GET:url parameters:nil hudString:nil success:^(id responseObject) {
        weakSelf.moneyPriceModel = [DBHInformationDetailForNewMoneyPriceModelData modelObjectWithDictionary:responseObject];
        
        [weakSelf refreshData];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 分段控件点击
 */
- (void)respondsToSegmentedControl {
    DBHInformationDetailModelProjectTimePrices *model = self.dataSource[self.segmentedControl.selectedSegmentIndex];
    [self getNewMoneyPriceDataWithUrl:[NSString stringWithFormat:@"https://dev.inwecrypto.com/%@", model.currentUrl]];
}

#pragma mark ------ Private Methods ------
/**
 刷新货币价格
 */
- (void)refreshData {
    if (self.moneyPriceModel) {
        self.currentPriceValueLabel.text = [NSString stringWithFormat:@"$%@", self.moneyPriceModel.price];
        self.volumeValueLabel.text = [NSString stringWithFormat:@"%.2lf", self.moneyPriceModel.volume];
        self.changeValueLabel.text = [NSString stringWithFormat:@"%.2lf%%", self.moneyPriceModel.change24h];
        self.maxValueLabel.text = self.moneyPriceModel.maxPrice24h;
        self.minValueLabel.text = self.moneyPriceModel.minPrice24h;
        
        self.changeValueLabel.textColor = self.moneyPriceModel.change24h >= 0 ? COLORFROM16(0xFF3232, 1) : COLORFROM16(0x22AC39, 1);
    } else {
        self.currentPriceValueLabel.text = @"$0.00";
        self.volumeValueLabel.text = @"0.00";
        self.changeValueLabel.text = @"0.00%";
        self.maxValueLabel.text = @"0.00000000";
        self.minValueLabel.text = @"0.00000000";
    }
}

#pragma mark ------ Getters And Setters ------
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    WEAKSELF
    [self.segmentedControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(70) * _dataSource.count);
        make.height.offset(AUTOLAYOUTSIZE(27));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.offset(AUTOLAYOUTSIZE(14));
    }];
    
    [self.segmentedControl removeAllSegments];
    
    for (DBHInformationDetailModelProjectTimePrices *model in _dataSource) {
        if ([model isEqual:_dataSource.firstObject]) {
            [self getNewMoneyPriceDataWithUrl:[NSString stringWithFormat:@"https://dev.inwecrypto.com/%@", model.currentUrl]];
        }
        
        [self.segmentedControl insertSegmentWithTitle:model.name atIndex:self.segmentedControl.numberOfSegments animated:YES];
    }
    
    self.segmentedControl.selectedSegmentIndex = 0;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = COLORFROM10(0, 0, 0, 0.5);
    }
    return _boxView;
}
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@""]];
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.tintColor = COLORFROM16(0xFF7043, 1);
        
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)]} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)]} forState:UIControlStateSelected];
        [_segmentedControl addTarget:self action:@selector(respondsToSegmentedControl) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}
- (UILabel *)currentPriceLabel {
    if (!_currentPriceLabel) {
        _currentPriceLabel = [[UILabel alloc] init];
        _currentPriceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _currentPriceLabel.text = @"当前价格";
        _currentPriceLabel.textColor = [UIColor whiteColor];
    }
    return _currentPriceLabel;
}
- (UILabel *)currentPriceValueLabel {
    if (!_currentPriceValueLabel) {
        _currentPriceValueLabel = [[UILabel alloc] init];
        _currentPriceValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _currentPriceValueLabel.textColor = [UIColor whiteColor];
    }
    return _currentPriceValueLabel;
}
- (UILabel *)volumeLabel {
    if (!_volumeLabel) {
        _volumeLabel = [[UILabel alloc] init];
        _volumeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _volumeLabel.text = @"Volume";
        _volumeLabel.textColor = [UIColor whiteColor];
    }
    return _volumeLabel;
}
- (UILabel *)volumeValueLabel {
    if (!_volumeValueLabel) {
        _volumeValueLabel = [[UILabel alloc] init];
        _volumeValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _volumeValueLabel.textColor = [UIColor whiteColor];
    }
    return _volumeValueLabel;
}
- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _changeLabel.text = @"24H-Change";
        _changeLabel.textColor = [UIColor whiteColor];
    }
    return _changeLabel;
}
- (UILabel *)changeValueLabel {
    if (!_changeValueLabel) {
        _changeValueLabel = [[UILabel alloc] init];
        _changeValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _changeValueLabel.textColor = COLORFROM16(0xFF3232, 1);
    }
    return _changeValueLabel;
}
- (UILabel *)maxLabel {
    if (!_maxLabel) {
        _maxLabel = [[UILabel alloc] init];
        _maxLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _maxLabel.text = @"24H最高值";
        _maxLabel.textColor = [UIColor whiteColor];
    }
    return _maxLabel;
}
- (UILabel *)maxValueLabel {
    if (!_maxValueLabel) {
        _maxValueLabel = [[UILabel alloc] init];
        _maxValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _maxValueLabel.textColor = COLORFROM16(0xFF3232, 1);
    }
    return _maxValueLabel;
}
- (UILabel *)minLabel {
    if (!_minLabel) {
        _minLabel = [[UILabel alloc] init];
        _minLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _minLabel.text = @"24H最低值";
        _minLabel.textColor = [UIColor whiteColor];
    }
    return _minLabel;
}
- (UILabel *)minValueLabel {
    if (!_minValueLabel) {
        _minValueLabel = [[UILabel alloc] init];
        _minValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _minValueLabel.textColor = COLORFROM16(0x22AC39, 1);
    }
    return _minValueLabel;
}

@end
