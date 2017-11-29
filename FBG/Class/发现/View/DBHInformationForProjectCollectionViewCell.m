//
//  DBHInformationForProjectCollectionViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationForProjectCollectionViewCell.h"

#import "DBHInformationForProjectCollectionModelData.h"
#import "DBHInformationForMoneyConditionModelData.h"

@interface DBHInformationForProjectCollectionViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *frontVersionLabel;
@property (nonatomic, strong) UIView *whiteLineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *currentPriceLabel;
@property (nonatomic, strong) UILabel *maxPriceLabel;
@property (nonatomic, strong) UILabel *minPriceLabel;
@property (nonatomic, strong) UILabel *gainLabel;
@property (nonatomic, strong) UIButton *collectButton;

@property (nonatomic, copy) BackSideBlock backSideBlock;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

@implementation DBHInformationForProjectCollectionViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizer:)];
        [self.leftSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        
        self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizer:)];
        [self.rightSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        
        [self addGestureRecognizer:self.leftSwipeGestureRecognizer];
        [self addGestureRecognizer:self.rightSwipeGestureRecognizer];
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
    [self.boxView addSubview:self.iconImageView];
    [self.boxView addSubview:self.frontVersionLabel];
    [self.boxView addSubview:self.whiteLineView];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.stateLabel];
    [self.boxView addSubview:self.nameLabel];
    [self.boxView addSubview:self.versionLabel];
    [self.boxView addSubview:self.currentPriceLabel];
    [self.boxView addSubview:self.maxPriceLabel];
    [self.boxView addSubview:self.minPriceLabel];
    [self.boxView addSubview:self.gainLabel];
    [self.boxView addSubview:self.collectButton];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
    [self.frontVersionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView).multipliedBy(0.92);
    }];
    [self.whiteLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(38.75));
        make.height.offset(AUTOLAYOUTSIZE(0.85));
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView).multipliedBy(1.06);
    }];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).multipliedBy(0.8);
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView).multipliedBy(1.52);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView).multipliedBy(0.53);
    }];
    [self.versionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView).multipliedBy(1.5);
        make.centerY.equalTo(weakSelf.nameLabel);
    }];
    [self.currentPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView).multipliedBy(0.86);
    }];
    [self.maxPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView).multipliedBy(1.03);
    }];
    [self.minPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView).multipliedBy(1.2);
    }];
    [self.gainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView).multipliedBy(1.37);
    }];
    [self.collectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(weakSelf.contentView.mas_width).multipliedBy(0.15);
        make.top.equalTo(weakSelf.contentView);
        make.right.offset(- AUTOLAYOUTSIZE(7.5));
    }];
}

#pragma mark ------ Event Responds ------
/**
 收藏
 */
- (void)repondsToCollectButton {
    
}
/**
 左滑/右滑
 */
- (void)swipeGestureRecognizer:(UISwipeGestureRecognizer *)recognizer {
    WEAKSELF
    self.backSideBlock();
    
    [UIView transitionWithView:self.boxView duration:1 options:recognizer.direction == UISwipeGestureRecognizerDirectionLeft ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        weakSelf.isBackSide = !weakSelf.isBackSide;
        
        [weakSelf backSideRefreshUI];
    } completion:nil];
}

#pragma mark ------ Public Methods ------
- (void)backSideBlock:(BackSideBlock)backSideBlock {
    self.backSideBlock = backSideBlock;
}

#pragma mark ------ Private Methods ------
/**
 翻面
 */
- (void)backSideRefreshUI {
    self.iconImageView.hidden = self.isBackSide;
    self.titleLabel.hidden = self.isBackSide;
    self.nameLabel.hidden = !self.isBackSide;
    self.versionLabel.hidden = !self.isBackSide;
    self.currentPriceLabel.hidden = !self.isBackSide;
    self.maxPriceLabel.hidden = !self.isBackSide;
    self.minPriceLabel.hidden = !self.isBackSide;
    self.gainLabel.hidden = !self.isBackSide;
    self.collectButton.hidden = !self.isBackSide;
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHInformationForProjectCollectionModelData *)model {
    _model = model;
    
    [self.iconImageView sdsetImageWithURL:_model.img placeholderImage:[UIImage imageNamed:@""]];
    self.frontVersionLabel.text = _model.score;
    self.titleLabel.text = _model.name;
    self.stateLabel.text = _model.desc;
    self.nameLabel.text = _model.name;
    self.versionLabel.text = _model.score;
    self.collectButton.selected = _model.saveUser == 1;
    
    [self backSideRefreshUI];
    
    WEAKSELF
    self.boxView.backgroundColor = [UIColor colorWithHexString:[_model.color substringFromIndex:1]];
    self.frontVersionLabel.hidden = _model.type == 5;
    self.whiteLineView.hidden = _model.type == 5;
    self.stateLabel.hidden = _model.type == 5;
    
    self.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(_model.gridType == 4 ? 36 : 18)];
    self.frontVersionLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(_model.gridType == 4 ? 22 : 11)];
    self.stateLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(_model.gridType == 4 ? 22 : 11)];
    self.nameLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(_model.gridType == 4 ? 36 : 18)];
    self.versionLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(_model.gridType == 4 ? 26 : 13)];
    self.currentPriceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(_model.gridType == 4 ? 16 : 8)];
    self.maxPriceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(_model.gridType == 4 ? 16 : 8)];
    self.minPriceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(_model.gridType == 4 ? 16 : 8)];
    self.gainLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(_model.gridType == 4 ? 16 : 8)];
    
    self.leftSwipeGestureRecognizer.enabled = _model.type == 5;
    self.rightSwipeGestureRecognizer.enabled = _model.type == 5;
    
    if (_model.type != 5) {
        // 未上线
        self.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(_model.gridType == 4 ? 32 : 16)];
        
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(weakSelf.boxView.mas_height).multipliedBy(0.23 * 2);
            make.centerX.equalTo(weakSelf.boxView);
            make.centerY.equalTo(weakSelf.boxView).multipliedBy(0.5);
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.boxView).multipliedBy(0.8);
            make.centerX.equalTo(weakSelf.boxView);
            make.centerY.equalTo(weakSelf.boxView).multipliedBy(1.29);
        }];
        
        return;
    }
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(weakSelf.boxView.mas_height).multipliedBy(0.41 * 2);
        make.centerX.equalTo(weakSelf.boxView);
        make.centerY.equalTo(weakSelf.boxView).multipliedBy(0.75);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).multipliedBy(0.8);
        make.centerX.equalTo(weakSelf.boxView);
        make.centerY.equalTo(weakSelf.boxView).multipliedBy(1.48);
    }];
    
    switch ((NSInteger)model.gridType) {
        case 1: {
            self.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(18)];
            
            break;
        }
        case 2:
        case 3: {
            self.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(18)];
            
            break;
        }
        default: {
            self.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(31)];
            
            break;
        }
    }
}
- (void)setMoneyModel:(DBHInformationForMoneyConditionModelData *)moneyModel {
    _moneyModel = moneyModel;
    
    self.currentPriceLabel.text = [NSString stringWithFormat:@"当前价格：$%@", _moneyModel.price];
    self.maxPriceLabel.text = [NSString stringWithFormat:@"24H最高价格：$%@", _moneyModel.maxPrice24];
    self.minPriceLabel.text = [NSString stringWithFormat:@"24H最低价格：$%@", _moneyModel.minPrice24];
    self.gainLabel.text = [NSString stringWithFormat:@"24H涨幅：%@%%", _moneyModel.change24];
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
    }
    return _boxView;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)frontVersionLabel {
    if (!_frontVersionLabel) {
        _frontVersionLabel = [[UILabel alloc] init];
        _frontVersionLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _frontVersionLabel.textColor = [UIColor whiteColor];
    }
    return _frontVersionLabel;
}
- (UIView *)whiteLineView {
    if (!_whiteLineView) {
        _whiteLineView = [[UIView alloc] init];
        _whiteLineView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteLineView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(31)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.textColor = [UIColor whiteColor];
    }
    return _stateLabel;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.hidden = YES;
        _nameLabel.text = @"sgag";
        _nameLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(18)];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}
- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.hidden = YES;
        _versionLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _versionLabel.textColor = [UIColor whiteColor];
    }
    return _versionLabel;
}
- (UILabel *)currentPriceLabel {
    if (!_currentPriceLabel) {
        _currentPriceLabel = [[UILabel alloc] init];
        _currentPriceLabel.hidden = YES;
        _currentPriceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _currentPriceLabel.text = @"当前价格：NAN";
        _currentPriceLabel.textColor = [UIColor whiteColor];
    }
    return _currentPriceLabel;
}
- (UILabel *)maxPriceLabel {
    if (!_maxPriceLabel) {
        _maxPriceLabel = [[UILabel alloc] init];
        _maxPriceLabel.hidden = YES;
        _maxPriceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _maxPriceLabel.text = @"24H最高价格：NAN";
        _maxPriceLabel.textColor = [UIColor whiteColor];
    }
    return _maxPriceLabel;
}
- (UILabel *)minPriceLabel {
    if (!_minPriceLabel) {
        _minPriceLabel = [[UILabel alloc] init];
        _minPriceLabel.hidden = YES;
        _minPriceLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _minPriceLabel.text = @"24H最低价格：NAN";
        _minPriceLabel.textColor = [UIColor whiteColor];
    }
    return _minPriceLabel;
}
- (UILabel *)gainLabel {
    if (!_gainLabel) {
        _gainLabel = [[UILabel alloc] init];
        _gainLabel.hidden = YES;
        _gainLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _gainLabel.text = @"24H涨幅：NAN";
        _gainLabel.textColor = [UIColor whiteColor];
    }
    return _gainLabel;
}
- (UIButton *)collectButton {
    if (!_collectButton) {
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectButton.hidden = YES;
        [_collectButton setImage:[UIImage imageNamed:@"icon_market_unlike"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"icon_market_like"] forState:UIControlStateSelected];
        [_collectButton addTarget:self action:@selector(repondsToCollectButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectButton;
}

@end
