//
//  DBHInformationDetailForInweReportTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForInweReportTableViewCell.h"

#import "DBHInformationDetailForInweReportSelectedView.h"
#import "DBHInformationDetailForInweReportContentTableViewCell.h"
#import "DBHAllInformationTypeTwoTableViewCell.h"

#import "DBHInformationDetailForInweModelData.h"

static NSString *const kDBHInformationDetailForInweReportContentTableViewCellIdentifier = @"kDBHInformationDetailForInweReportContentTableViewCellIdentifier";
static NSString *const kDBHAllInformationTypeTwoTableViewCellIdentifier = @"kDBHAllInformationTypeTwoTableViewCellIdentifier";

@interface DBHInformationDetailForInweReportTableViewCell ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) DBHInformationDetailForInweReportSelectedView *informationDetailForInweReportSelectedView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, copy) SelectInweTypeBlock selectInweTypeBlock;

@end

@implementation DBHInformationDetailForInweReportTableViewCell

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
    [self.contentView addSubview:self.informationDetailForInweReportSelectedView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.noDataLabel];
    [self.contentView addSubview:self.moreButton];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(12));
        make.height.offset(AUTOLAYOUTSIZE(39));
        make.top.equalTo(weakSelf.contentView);
    }];
    [self.informationDetailForInweReportSelectedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.height.offset(AUTOLAYOUTSIZE(27.5));
        make.top.equalTo(weakSelf.titleLabel.mas_bottom);
        make.centerX.equalTo(weakSelf.contentView);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.informationDetailForInweReportSelectedView.mas_bottom).offset(AUTOLAYOUTSIZE(4));
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
    if (!self.dataSource) {
        return 0;
    }
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationDetailForInweModelData *model = self.dataSource[indexPath.row];
    if (model.type == 1) {
        DBHAllInformationTypeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHAllInformationTypeTwoTableViewCellIdentifier forIndexPath:indexPath];
        cell.inweModel = model;
        
        return cell;
    } else {
        DBHInformationDetailForInweReportContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForInweReportContentTableViewCellIdentifier forIndexPath:indexPath];
        cell.model = model;
        
        return cell;
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationDetailForInweModelData *model = self.dataSource[indexPath.row];
    return model.type != 1 ? AUTOLAYOUTSIZE(124) : AUTOLAYOUTSIZE(67);
}

#pragma mark ------ Event Responds ------
/**
 更多
 */
- (void)respondsToMoreButton {
    
}

#pragma mark ------ Public Methods ------
- (void)selectInweTypeBlock:(SelectInweTypeBlock)selectInweTypeBlock {
    self.selectInweTypeBlock = selectInweTypeBlock;
}

#pragma mark ------ Private Methods ------
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf endRefresh];
        });
    }];
}
- (void)endRefresh {
    if (self.tableView.mj_header.refreshing) {
        [self.tableView.mj_header endRefreshing];
    }
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
        _titleLabel.text = @"INWE报道";
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (DBHInformationDetailForInweReportSelectedView *)informationDetailForInweReportSelectedView {
    if (!_informationDetailForInweReportSelectedView) {
        _informationDetailForInweReportSelectedView = [[DBHInformationDetailForInweReportSelectedView alloc] init];
        _informationDetailForInweReportSelectedView.currentSelectedIndex = self.inweReportType;
        
        WEAKSELF
        [_informationDetailForInweReportSelectedView selectedButtonBlock:^(NSInteger currentSelectedIndex) {
            weakSelf.selectInweTypeBlock(currentSelectedIndex);
        }];
    }
    return _informationDetailForInweReportSelectedView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.rowHeight = AUTOLAYOUTSIZE(94);
        
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHInformationDetailForInweReportContentTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForInweReportContentTableViewCellIdentifier];
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
