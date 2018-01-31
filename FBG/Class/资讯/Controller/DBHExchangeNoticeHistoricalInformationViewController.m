//
//  DBHExchangeNoticeHistoricalInformationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHExchangeNoticeHistoricalInformationViewController.h"

#import "DBHMyFavoriteTableViewCell.h"

#import "DBHExchangeNoticeDataModels.h"

static NSString *const kDBHMyFavoriteTableViewCellIdentifier = @"kDBHMyFavoriteTableViewCellIdentifier";

@interface DBHExchangeNoticeHistoricalInformationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHExchangeNoticeHistoricalInformationViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Historical Information", nil);
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getExchangeNotice];
}

#pragma mark ------ UI ------
- (void)setUI {
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
    DBHMyFavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHMyFavoriteTableViewCellIdentifier forIndexPath:indexPath];
    cell.exchangeNoticeModel = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark ------ Data ------
/**
 获取交易所公告
 */
- (void)getExchangeNotice {
    WEAKSELF
    [PPNetworkHelper GET:@"exchange_notice" baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        if (weakSelf.dataSource.count) {
            return ;
        }
        
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseCache[@"data"]) {
            DBHExchangeNoticeModelData *model = [DBHExchangeNoticeModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf.tableView reloadData];
    } success:^(id responseObject) {
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            DBHExchangeNoticeModelData *model = [DBHExchangeNoticeModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(75.5);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHMyFavoriteTableViewCell class] forCellReuseIdentifier:kDBHMyFavoriteTableViewCellIdentifier];
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
