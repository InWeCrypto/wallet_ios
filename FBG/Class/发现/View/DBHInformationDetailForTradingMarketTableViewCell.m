//
//  DBHInformationDetailForTradingMarketTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForTradingMarketTableViewCell.h"

#import "DBHInformationDetailForTradingMarketButton.h"
#import "DBHSpinnerView.h"
#import "DBHInformationDetailForTradingMarketContentTableViewCell.h"

#import "DBHInformationDetailModelProjectMarkets.h"
#import "DBHInformationDetailForTradingMarketContentDataModels.h"

static NSString *const kDBHInformationDetailForTradingMarketContentTableViewCellIdentifier = @"kDBHInformationDetailForTradingMarketContentTableViewCellIdentifier";

@interface DBHInformationDetailForTradingMarketTableViewCell ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) DBHInformationDetailForTradingMarketButton *selectButton;
@property (nonatomic, strong) DBHSpinnerView *spinnerView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentSelectedIndex; // 当前选中货币类型下标
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *moneyNameArray;

@end

@implementation DBHInformationDetailForTradingMarketTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUI];
        [self addRefresh];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.tableView];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(23));
        make.height.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(10));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(AUTOLAYOUTSIZE(26.5));
        make.top.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
    }];
    [self.selectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(53));
        make.height.equalTo(weakSelf.titleLabel);
        make.right.top.equalTo(weakSelf.boxView);
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.bottom.centerX.equalTo(weakSelf.titleLabel);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.bottomLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.contentView);
        make.centerX.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationDetailForTradingMarketContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForTradingMarketContentTableViewCellIdentifier forIndexPath:indexPath];
    cell.isData = indexPath.row;
    if (indexPath.row) {
        cell.model = self.dataSource[indexPath.row - 1];
    }
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark ------ Data ------
/**
 获取市场交易信息数据
 */
- (void)getTradeInformationData {
    WEAKSELF
    if (!self.currencyTypeArray.count) {
        [self endRefresh];
        return;
    }
    
    DBHInformationDetailModelProjectMarkets *model = self.currencyTypeArray[self.currentSelectedIndex];
    [PPNetworkHelper GET:[NSString stringWithFormat:@"https://dev.inwecrypto.com/%@", model.url] isOtherBaseUrl:NO parameters:nil hudString:nil success:^(id responseObject) {
        [weakSelf.dataSource removeAllObjects];
        for (NSDictionary *dic in responseObject) {
            DBHInformationDetailForTradingMarketContentModelData *model = [DBHInformationDetailForTradingMarketContentModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf endRefresh];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 选择币种
 */
- (void)respondsToSelectButton {
    WEAKSELF
    if (self.spinnerView.superview) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.spinnerView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.spinnerView removeFromSuperview];
        }];
    } else {
        self.spinnerView.frame = CGRectMake(SCREEN_WIDTH - AUTOLAYOUTSIZE(64.5), AUTOLAYOUTSIZE(36.5), AUTOLAYOUTSIZE(53), AUTOLAYOUTSIZE(26.5) * (self.currencyTypeArray.count <= 5 ? self.currencyTypeArray.count : 5));
        
        
        self.spinnerView.titleArray = [self.moneyNameArray copy];
        
        [weakSelf.contentView addSubview:self.spinnerView];
        
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.spinnerView.alpha = 1;
        }];
    }
}

#pragma mark ------ Private Methods ------
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getTradeInformationData];
    }];
}
- (void)endRefresh {
    if (self.tableView.mj_header.refreshing) {
        [self.tableView.mj_header endRefreshing];
    }
}

#pragma mark ------ Getters And Setters ------
- (void)setCurrencyTypeArray:(NSArray *)currencyTypeArray {
    _currencyTypeArray = currencyTypeArray;
    
    DBHInformationDetailModelProjectMarkets *model = _currencyTypeArray.firstObject;
    self.selectButton.leftTitle = model.enName;
    
    [self.moneyNameArray removeAllObjects];
    for (DBHInformationDetailModelProjectMarkets *model in _currencyTypeArray) {
        [self.moneyNameArray addObject:model.enName];
    }
    
    [self getTradeInformationData];
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = [UIColor whiteColor];
    }
    return _boxView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _titleLabel.text = @"交易市场";
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (DBHInformationDetailForTradingMarketButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [DBHInformationDetailForTradingMarketButton buttonWithType:UIButtonTypeCustom];
        _selectButton.backgroundColor = COLORFROM16(0x2DA4DA, 1);
        [_selectButton addTarget:self action:@selector(respondsToSelectButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}
- (DBHSpinnerView *)spinnerView {
    if (!_spinnerView) {
        _spinnerView = [[DBHSpinnerView alloc] init];
        _spinnerView.alpha = 0;
        
        WEAKSELF
        [_spinnerView clickMoneyBlock:^(NSInteger selectedMoneyType) {
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.spinnerView.alpha = 0;
            } completion:^(BOOL finished) {
                [weakSelf.spinnerView removeFromSuperview];
            }];
            
            if (weakSelf.currentSelectedIndex != selectedMoneyType) {
                weakSelf.currentSelectedIndex = selectedMoneyType;
                
                DBHInformationDetailModelProjectMarkets *model = weakSelf.currencyTypeArray[selectedMoneyType];
                weakSelf.selectButton.leftTitle = model.enName;
                
                [weakSelf getTradeInformationData];
            }
        }];
    }
    return _spinnerView;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xE6E6E6, 1);
    }
    return _bottomLineView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.rowHeight = AUTOLAYOUTSIZE(27.1);
        
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHInformationDetailForTradingMarketContentTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForTradingMarketContentTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)moneyNameArray {
    if (!_moneyNameArray) {
        _moneyNameArray = [NSMutableArray array];
    }
    return _moneyNameArray;
}

@end
