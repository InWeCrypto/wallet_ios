//
//  DBHInformationDetailForInweReportTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForInweReportTableViewCell.h"

#import "DBHInformationDetailForInweReportContentTableViewCell.h"
#import "DBHAllInformationTypeTwoTableViewCell.h"

#import "DBHInformationDetailForInweModelData.h"

static NSString *const kDBHInformationDetailForInweReportContentTableViewCellIdentifier = @"kDBHInformationDetailForInweReportContentTableViewCellIdentifier";
static NSString *const kDBHAllInformationTypeTwoTableViewCellIdentifier = @"kDBHAllInformationTypeTwoTableViewCellIdentifier";

@interface DBHInformationDetailForInweReportTableViewCell ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) SelectInweTypeBlock selectInweTypeBlock;

@end

@implementation DBHInformationDetailForInweReportTableViewCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.segmentedControl];
    [self.contentView addSubview:self.tableView];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(23));
        make.height.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(10));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(AUTOLAYOUTSIZE(27));
        make.top.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.bottom.centerX.equalTo(weakSelf.titleLabel);
    }];
    [self.segmentedControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(210));
        make.height.offset(AUTOLAYOUTSIZE(27));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.bottomLineView.mas_bottom).offset(AUTOLAYOUTSIZE(10));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.segmentedControl.mas_bottom).offset(AUTOLAYOUTSIZE(10));
        make.bottom.equalTo(weakSelf.contentView);
        make.centerX.equalTo(weakSelf.contentView);
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
 分段控件点击
 */
- (void)respondsToSegmentedControl {
    if (self.inweReportType == self.segmentedControl.selectedSegmentIndex) {
        return;
    }
    
    self.selectInweTypeBlock(self.segmentedControl.selectedSegmentIndex);
}

#pragma mark ------ Public Methods ------
- (void)selectInweTypeBlock:(SelectInweTypeBlock)selectInweTypeBlock {
    self.selectInweTypeBlock = selectInweTypeBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setInweReportType:(NSInteger)inweReportType {
    _inweReportType = inweReportType;
    
    self.segmentedControl.selectedSegmentIndex = _inweReportType;
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
        _titleLabel.text = @"INWE报道";
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xE6E6E6, 1);
    }
    return _bottomLineView;
}
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"视频", @"图文"]];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.tintColor = COLORFROM16(0xFF7043, 1);
        
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:COLORFROM16(0xFF7043, 1), NSFontAttributeName:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)]} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)]} forState:UIControlStateSelected];
        [_segmentedControl addTarget:self action:@selector(respondsToSegmentedControl) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.rowHeight = AUTOLAYOUTSIZE(124);
        
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHInformationDetailForInweReportContentTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForInweReportContentTableViewCellIdentifier];
    }
    return _tableView;
}

@end
