//
//  DBHSpinnerView.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/17.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHSpinnerView.h"

#import "DBHSpinnerViewTableViewCell.h"

static NSString *const kDBHSpinnerViewTableViewCellIdentifier = @"kDBHSpinnerViewTableViewCellIdentifier";

@interface DBHSpinnerView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) ClickMoneyBlock clickMoneyBlock;

@end

@implementation DBHSpinnerView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf);
        make.center.equalTo(weakSelf);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.titleArray) {
        return 0;
    }
    
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHSpinnerViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHSpinnerViewTableViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    cell.isHiddenBottomLineView = indexPath.row == self.titleArray.count - 1;
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.clickMoneyBlock(indexPath.row);
}

#pragma mark ------ Private Methods ------
- (void)clickMoneyBlock:(ClickMoneyBlock)clickMoneyBlock {
    self.clickMoneyBlock = clickMoneyBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.rowHeight = AUTOLAYOUTSIZE(26.5);
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHSpinnerViewTableViewCell class] forCellReuseIdentifier:kDBHSpinnerViewTableViewCellIdentifier];
    }
    return _tableView;
}

@end
