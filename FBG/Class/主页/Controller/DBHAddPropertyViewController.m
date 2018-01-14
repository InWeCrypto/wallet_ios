//
//  DBHAddPropertyViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHAddPropertyViewController.h"

#import "DBHAddPropertyTableViewCell.h"

#import "DBHWalletManagerForNeoModelList.h"
#import "DBHAddPropertyDataModels.h"

static NSString *const kDBHAddPropertyTableViewCellIdentifier = @"kDBHAddPropertyTableViewCellIdentifier";

@interface DBHAddPropertyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectedTokenIdArray;

@end

@implementation DBHAddPropertyViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Add NEP-5 Property", nil);
    
    [self setUI];
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getTokenList];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Complete", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToFinishBarButtonItem)];
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHAddPropertyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHAddPropertyTableViewCellIdentifier forIndexPath:indexPath];
    DBHAddPropertyModelList *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.isSelected = [self.selectedTokenIdArray containsObject:@(model.listIdentifier)];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHAddPropertyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    DBHAddPropertyModelList *model = self.dataSource[indexPath.row];
    if (cell.isSelected) {
        [self.selectedTokenIdArray removeObject:@(model.listIdentifier)];
    } else {
        [self.selectedTokenIdArray addObject:@(model.listIdentifier)];
    }
    cell.isSelected = [self.selectedTokenIdArray containsObject:@(model.listIdentifier)];
}

#pragma mark ------ Data ------
/**
 获取代币列表
 */
- (void)getTokenList {
    NSDictionary *paramters = @{@"wallet_category_id":@(self.neoWalletModel.categoryId),
                                @"wallet_id":@(self.neoWalletModel.listIdentifier)};
    
    WEAKSELF
    [PPNetworkHelper GET:@"gnt-category" isOtherBaseUrl:NO parameters:paramters hudString:@"加载中..." success:^(id responseObject) {
        [weakSelf endRefresh];
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.selectedTokenIdArray removeAllObjects];
        
        for (NSDictionary *dic in responseObject[@"list"]) {
            DBHAddPropertyModelList *model = [DBHAddPropertyModelList modelObjectWithDictionary:dic];
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    }];
}
/**
 添加代币
 */
- (void)addToken {
    NSDictionary *paramters = @{@"wallet_id":@(self.neoWalletModel.listIdentifier), @"gnt_category_ids":[self.selectedTokenIdArray toJSONStringForArray]};
    
    WEAKSELF
    [PPNetworkHelper POST:@"user-gnt" parameters:paramters hudString:@"添加中..." success:^(id responseObject)
     {
         [weakSelf.navigationController popViewControllerAnimated:YES];
         
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
}

#pragma mark ------ Event Responds ------
/**
 完成
 */
- (void)respondsToFinishBarButtonItem {
    if (!self.selectedTokenIdArray.count) {
        [LCProgressHUD showInfoMsg:NSLocalizedString(@"Please select a token", nil)];
        
        return;
    }
    
    [self addToken];
}

#pragma mark ------ Private Methods ------
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getTokenList];
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
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(55);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHAddPropertyTableViewCell class] forCellReuseIdentifier:kDBHAddPropertyTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)selectedTokenIdArray {
    if (!_selectedTokenIdArray) {
        _selectedTokenIdArray = [NSMutableArray array];
    }
    return _selectedTokenIdArray;
}

@end
