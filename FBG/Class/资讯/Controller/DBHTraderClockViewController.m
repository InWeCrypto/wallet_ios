//
//  DBHTraderClockViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTraderClockViewController.h"

#import "DBHFunctionalUnitLookViewController.h"

#import "DBHProjectHomeHeaderView.h"
#import "DBHTraderClockTableViewCell.h"

static NSString *const kDBHTraderClockTableViewCellIdentifier = @"kDBHTraderClockTableViewCellIdentifier";

@interface DBHTraderClockViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHTraderClockViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self addRefresh];
    
    if ([self.conversation isKindOfClass:[EMConversation class]]) {
        [self getLastMessage];
    }
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiangmuzhuye_ren_ico"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToPersonBarButtonItem)];
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHTraderClockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHTraderClockTableViewCellIdentifier forIndexPath:indexPath];
    cell.message = self.dataSource[indexPath.section];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    EMMessage *message = self.dataSource[section];
    NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    DBHProjectHomeHeaderView *headerView = [[DBHProjectHomeHeaderView alloc] init];
    headerView.time = [messageDate formattedTime];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(42);
}

#pragma mark ------ Data ------
/**
 获取最后1页信息
 */
- (void)getLastMessage {
    WEAKSELF
    weakSelf.currentPage = 1;
    [self.conversation loadMessagesStartFromId:nil count:5 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        [weakSelf.dataSource addObjectsFromArray:aMessages];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[weakSelf.dataSource count] - 1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}
/**
 获取前1页信息
 */
- (void)getMessage {
    EMMessage *message = self.dataSource.firstObject;
    
    WEAKSELF
    [self.conversation loadMessagesStartFromId:message.messageId count:self.currentPage * 5 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        [weakSelf.dataSource insertObjects:aMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, aMessages.count)]];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:aMessages.count] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}

#pragma mark ------ Event Responds ------
/**
 项目查看
 */
- (void)respondsToPersonBarButtonItem {
    DBHFunctionalUnitLookViewController *functionalUnitLookViewController = [[DBHFunctionalUnitLookViewController alloc] init];
    functionalUnitLookViewController.title = self.title;
    functionalUnitLookViewController.functionalUnitType = self.functionalUnitType;
    [self.navigationController pushViewController:functionalUnitLookViewController animated:YES];
}

#pragma mark ------ Private Methods ------
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.dataSource.count < weakSelf.currentPage * 5 || ![self.conversation isKindOfClass:[EMConversation class]]) {
            [weakSelf endRefresh];
            
            return ;
        }
        
        weakSelf.currentPage += 1;
        [weakSelf getMessage];
    }];
}
/**
 结束刷新
 */
- (void)endRefresh {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLORFROM10(235, 235, 235, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(308);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHTraderClockTableViewCell class] forCellReuseIdentifier:kDBHTraderClockTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
