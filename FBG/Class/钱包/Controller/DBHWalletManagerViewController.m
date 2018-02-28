//
//  DBHWalletManagerViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHWalletManagerViewController.h"

#import "DBHImportWalletViewController.h"
#import "DBHImportWalletWithETHViewController.h"
#import "DBHCreateWalletViewController.h"
#import "DBHCreateWalletWithETHViewController.h"
#import "DBHWalletDetailViewController.h"
#import "DBHWalletDetailWithETHViewController.h"

#import "DBHAddWalletPromptView.h"
#import "DBHSelectWalletTypeOnePromptView.h"
#import "DBHSelectWalletTypeTwoPromptView.h"
#import "DBHWalletManagerTableViewCell.h"

#import "DBHWalletManagerForNeoDataModels.h"

static NSString *const kDBHWalletManagerTableViewCellIdentifier = @"kDBHWalletManagerTableViewCellIdentifier";

@interface DBHWalletManagerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHAddWalletPromptView *addWalletPromptView;
@property (nonatomic, strong) DBHSelectWalletTypeOnePromptView *selectWalletTypeOnePromptView;
@property (nonatomic, strong) DBHSelectWalletTypeTwoPromptView *selectWalletTypeTwoPromptView;

@property (nonatomic, assign) NSInteger type; // 0:添加钱包 1:导入钱包
@property (nonatomic, assign) NSInteger walletType; // 0:NEO 1:ETH
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHWalletManagerViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Manager Wallets", nil);
    
    [self setUI];
    
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:[UIColor whiteColor] Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
    
    [self getWalletList];
}

#pragma mark ------ UI ------
- (void)setUI {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Add Wallet"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToAddWalletBarButtonItem)];
    
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
    DBHWalletManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHWalletManagerTableViewCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHWalletManagerForNeoModelList *model = self.dataSource[indexPath.row];
    if (model.category.categoryIdentifier == 1) {
        // ETH
        DBHWalletDetailWithETHViewController *walletDetailWithETHViewController = [[DBHWalletDetailWithETHViewController alloc] init];
        walletDetailWithETHViewController.backIndex = 1;
        walletDetailWithETHViewController.ethWalletModel = model;
        [self.navigationController pushViewController:walletDetailWithETHViewController animated:YES];
    } else {
        // NEO
        DBHWalletDetailViewController *walletDetailViewController = [[DBHWalletDetailViewController alloc] init];
        walletDetailViewController.backIndex = 1;
        walletDetailViewController.neoWalletModel = model;
        [self.navigationController pushViewController:walletDetailViewController animated:YES];
    }
}

#pragma mark ------ Data ------
/**
 获取钱包列表
 */
- (void)getWalletList {
    WEAKSELF
    [PPNetworkHelper GET:@"wallet" baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
        [weakSelf.dataSource removeAllObjects];
        for (NSDictionary *dic in responseCache[@"list"]) {
            DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList modelObjectWithDictionary:dic];
            
            model.isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:model.address]];
            model.isBackUpMnemonnic = [[UserSignData share].user.walletIdsArray containsObject:@(model.listIdentifier)];
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf.tableView reloadData];
    } success:^(id responseObject) {
        [weakSelf endRefresh];
        
        [weakSelf.dataSource removeAllObjects];
        for (NSDictionary *dic in responseObject[@"list"]) {
            DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList modelObjectWithDictionary:dic];
            
            model.isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:model.address]];
            model.isBackUpMnemonnic = [[UserSignData share].user.walletIdsArray containsObject:@(model.listIdentifier)];
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure: error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 添加钱包
 */
- (void)respondsToAddWalletBarButtonItem {
    [[UIApplication sharedApplication].keyWindow addSubview:self.addWalletPromptView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.addWalletPromptView animationShow];
    });
}

#pragma mark ------ Private Methods ------
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getWalletList];
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
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(70);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHWalletManagerTableViewCell class] forCellReuseIdentifier:kDBHWalletManagerTableViewCellIdentifier];
    }
    return _tableView;
}
- (DBHAddWalletPromptView *)addWalletPromptView {
    if (!_addWalletPromptView) {
        _addWalletPromptView = [[DBHAddWalletPromptView alloc] init];
        
        WEAKSELF
        [_addWalletPromptView selectedBlock:^(NSInteger index) {
            if (!index) {
                // 添加新钱包
                weakSelf.type = 0;
                [[UIApplication sharedApplication].keyWindow addSubview:self.selectWalletTypeOnePromptView];
                
                WEAKSELF
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.selectWalletTypeOnePromptView animationShow];
                });
            } else {
                // 导入钱包
                weakSelf.type = 1;
                [[UIApplication sharedApplication].keyWindow addSubview:self.selectWalletTypeOnePromptView];
                
                WEAKSELF
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.selectWalletTypeOnePromptView animationShow];
                });
            }
        }];
    }
    return _addWalletPromptView;
}
- (DBHSelectWalletTypeOnePromptView *)selectWalletTypeOnePromptView {
    if (!_selectWalletTypeOnePromptView) {
        _selectWalletTypeOnePromptView = [[DBHSelectWalletTypeOnePromptView alloc] init];
        
        WEAKSELF
        [_selectWalletTypeOnePromptView selectedBlock:^(NSInteger index) {
            if (index == - 1) {
                // 返回
                [[UIApplication sharedApplication].keyWindow addSubview:self.addWalletPromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.addWalletPromptView animationShow];
                });
            } else if (!index) {
                if (!weakSelf.type) {
                    // 添加NEO
                    weakSelf.walletType = 0;
                    [[UIApplication sharedApplication].keyWindow addSubview:self.selectWalletTypeTwoPromptView];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.selectWalletTypeTwoPromptView animationShow];
                    });
                } else {
                    // 导入NEO
                    DBHImportWalletViewController *importWalletViewController = [[DBHImportWalletViewController alloc] init];
                    [weakSelf.navigationController pushViewController:importWalletViewController animated:YES];
                }
            } else {
                if (!weakSelf.type) {
                    // 添加ETH
                    weakSelf.walletType = 1;
                    [[UIApplication sharedApplication].keyWindow addSubview:self.selectWalletTypeTwoPromptView];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.selectWalletTypeTwoPromptView animationShow];
                    });
                } else {
                    // 导入ETH
                    DBHImportWalletWithETHViewController *importWalletWithETHViewController = [[DBHImportWalletWithETHViewController alloc] init];
                    [weakSelf.navigationController pushViewController:importWalletWithETHViewController animated:YES];
                }
            }
        }];
    }
    return _selectWalletTypeOnePromptView;
}
- (DBHSelectWalletTypeTwoPromptView *)selectWalletTypeTwoPromptView {
    if (!_selectWalletTypeTwoPromptView) {
        _selectWalletTypeTwoPromptView = [[DBHSelectWalletTypeTwoPromptView alloc] init];
        
        WEAKSELF
        [_selectWalletTypeTwoPromptView selectedBlock:^(NSInteger index) {
            if (index == - 1) {
                // 返回
                [[UIApplication sharedApplication].keyWindow addSubview:self.selectWalletTypeOnePromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.selectWalletTypeOnePromptView animationShow];
                });
            } else {
                if (!index) {
                    // 热钱包
                    if (!self.walletType) {
                        // NEO
                        DBHCreateWalletViewController *createWalletViewController = [[DBHCreateWalletViewController alloc] init];
                        [weakSelf.navigationController pushViewController:createWalletViewController animated:YES];
                    } else {
                        // ETH
                        DBHCreateWalletWithETHViewController *createWalletWithETHViewController = [[DBHCreateWalletWithETHViewController alloc] init];
                        [weakSelf.navigationController pushViewController:createWalletWithETHViewController animated:YES];
                    }
                } else {
                    // 冷钱包
                    [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
                }
            }
        }];
    }
    return _selectWalletTypeTwoPromptView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
