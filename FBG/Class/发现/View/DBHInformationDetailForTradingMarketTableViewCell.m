//
//  DBHInformationDetailForTradingMarketTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForTradingMarketTableViewCell.h"

#import "DBHInformationDetailForTradingMarketContentTableViewCell.h"

#import "DBHInformationDetailModelProjectMarkets.h"

static NSString *const kDBHInformationDetailForTradingMarketContentTableViewCellIdentifier = @"kDBHInformationDetailForTradingMarketContentTableViewCellIdentifier";

@interface DBHInformationDetailForTradingMarketTableViewCell ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation DBHInformationDetailForTradingMarketTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.noDataLabel];
    [self.contentView addSubview:self.moreButton];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(12));
        make.top.offset(AUTOLAYOUTSIZE(10));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(8));
        make.centerX.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.moreButton.mas_top);
    }];
    [self.noDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.tableView);
    }];
    [self.moreButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(100));
        make.height.offset(AUTOLAYOUTSIZE(20));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationDetailForTradingMarketContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForTradingMarketContentTableViewCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark ------ Event Responds ------
/**
 更多
 */
- (void)respondsToMoreButton {
    
}

#pragma mark ------ Getters And Setters ------
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    self.noDataLabel.hidden = _dataSource.count;
    
    [self.tableView reloadData];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(16)];
        _titleLabel.text = @"交易市场";
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.rowHeight = AUTOLAYOUTSIZE(60);
        
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHInformationDetailForTradingMarketContentTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForTradingMarketContentTableViewCellIdentifier];
    }
    return _tableView;
}
- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        _noDataLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(15)];
        _noDataLabel.text = @"暂无数据";
        _noDataLabel.textColor = COLORFROM16(0x333333, 1);
        _noDataLabel.hidden = YES;
    }
    return _noDataLabel;
}
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"moreCircle"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(respondsToMoreButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

@end
