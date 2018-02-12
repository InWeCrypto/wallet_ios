//
//  DBHWalletDetailWithETHViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHWalletDetailWithETHViewController.h"

#import "PackupsWordsVC.h"

#import "DBHQrCodeViewController.h"
#import "DBHAddPropertyViewController.h"
#import "DBHTokenSaleViewController.h"
#import "DBHTransferListViewController.h"
#import "DBHExtractGasViewController.h"
#import "DBHImportWalletWithETHViewController.h"

#import "DBHWalletDetailTitleView.h"
#import "DBHInputPasswordPromptView.h"
#import "DBHWalletDetailHeaderView.h"
#import "DBHMenuView.h"
#import "DBHWalletDetailTableViewCell.h"

#import "WalletLeftListModel.h"
#import "DBHWalletManagerForNeoDataModels.h"
#import "DBHWalletDetailTokenInfomationDataModels.h"

static NSString *const kDBHWalletDetailTableViewCellIdentifier = @"kDBHWalletDetailTableViewCellIdentifier";

@interface DBHWalletDetailWithETHViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) DBHWalletDetailTitleView *titleView;
@property (nonatomic, strong) DBHWalletDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHMenuView *menuView;
@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;

@property (nonatomic, assign) NSInteger operationType; // 操作类型 1:备份助记词 2:备份Keystore 3:删除钱包
@property (nonatomic, strong) NSMutableArray *menuArray; // 菜单选项
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHWalletDetailWithETHViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.titleView = self.titleView;
    
    [self setUI];
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[UserSignData share].user.walletZhujiciIdsArray containsObject:@(self.ethWalletModel.listIdentifier)] && self.menuArray.count > 2) {
        [self.menuArray removeObjectAtIndex:0];
        self.menuView.dataSource = [self.menuArray copy];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.titleView.totalAsset = @"0";
    self.headerView.asset = @"0";
    [self getETHData];
    [self getWalletAssetInfomation];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:[UIColor whiteColor] Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:[UIColor whiteColor] Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"导出"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToMenuBarButtonItem)];
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(- STATUS_HEIGHT - 44);
        make.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHWalletDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHWalletDetailTableViewCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    WEAKSELF
    [cell clickExtractButtonBlock:^{
        // 提取Gas
        DBHExtractGasViewController *extractGasViewController = [[DBHExtractGasViewController alloc] init];
        extractGasViewController.wallectId = [NSString stringWithFormat:@"%ld", (NSInteger)weakSelf.ethWalletModel.listIdentifier];
        extractGasViewController.neoTokenModel = weakSelf.dataSource.firstObject;
        extractGasViewController.gasTokenModel = weakSelf.dataSource[1];
        [weakSelf.navigationController pushViewController:extractGasViewController animated:YES];
    }];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHTransferListViewController *transferListViewController = [[DBHTransferListViewController alloc] init];
    DBHWalletDetailTokenInfomationModelData *model = self.dataSource[indexPath.row];
    transferListViewController.title = model.flag;
    transferListViewController.neoWalletModel = self.ethWalletModel;
    transferListViewController.tokenModel = model;
    [self.navigationController pushViewController:transferListViewController animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row > 0;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加一个删除按钮
    WEAKSELF
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:DBHGetStringWithKeyFromTable(@"Delete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [weakSelf deleteTokenWithIndex:indexPath.row];
        tableView.editing = NO;
    }];
    //删除按钮颜色
    
    deleteAction.backgroundColor = [UIColor colorWithHexString:@"FF841C"];
    
    return @[deleteAction];
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y + STATUS_HEIGHT + 44;
    
    CGFloat alpha = offsetY / 260;
    UIBarButtonItem *backBarButtonItem = self.navigationItem.leftBarButtonItems.firstObject;
    UIButton *backButton = backBarButtonItem.customView;
    self.titleView.hidden = !(alpha >= 0.12);
    [backButton setImage:[UIImage imageNamed:alpha >= 0.12 ? @"关闭-3" : @"关闭-4"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:COLORFROM16(0xFFFFFF, alpha) Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:alpha >= 0.12 ? @"导出1" : @"导出"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToMenuBarButtonItem)];
}

#pragma mark ------ Data ------
/**
 获取ETH数据
 */
- (void)getETHData {
    NSDictionary *paramters = @{@"wallet_ids":[@[@(self.ethWalletModel.listIdentifier)] toJSONStringForArray]};
    
    WEAKSELF
    [PPNetworkHelper GET:@"conversion" baseUrlType:1 parameters:paramters hudString:nil responseCache:^(id responseCache) {
        if (weakSelf.dataSource.count > 1) {
            return ;
        }
        DBHWalletDetailTokenInfomationModelData *model = weakSelf.dataSource.firstObject;
        for (NSDictionary * dic in [responseCache objectForKey:@"list"]) {
            if (![NSString isNulllWithObject:[dic objectForKey:@"balance"]])
            {
                model.balance = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[dic objectForKey:@"balance"] substringFromIndex:2]] secend:@"1000000000000000000" value:4];
            }
            else
            {
                model.balance = @"0";
            }
            
            NSString *price_cny = [[[dic objectForKey:@"category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
            NSString *price_usd = [[[dic objectForKey:@"category"] objectForKey:@"cap"] objectForKey:@"price_usd"];
            if ([NSObject isNulllWithObject:dic[@"category"][@"cap"]]) {
                price_cny = @"0";
                price_usd = @"0";
            }
            model.priceCny = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_cny value:2];
            model.priceUsd = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_usd value:2];
            model.address = dic[@"address"];
        }
        weakSelf.titleView.totalAsset = [NSString DecimalFuncWithOperatorType:0 first:[UserSignData share].user.walletUnitType == 1 ? model.priceCny : model.priceUsd secend:weakSelf.titleView.totalAsset value:5];
        weakSelf.headerView.asset = [NSString DecimalFuncWithOperatorType:0 first:[UserSignData share].user.walletUnitType == 1 ? model.priceCny : model.priceUsd secend:weakSelf.headerView.asset value:5];
        
        [weakSelf.tableView reloadData];
    } success:^(id responseObject) {
        DBHWalletDetailTokenInfomationModelData *model = weakSelf.dataSource.firstObject;
        for (NSDictionary * dic in [responseObject objectForKey:@"list"]) {
            if (![NSString isNulllWithObject:[dic objectForKey:@"balance"]])
            {
                model.balance = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[dic objectForKey:@"balance"] substringFromIndex:2]] secend:@"1000000000000000000" value:4];
            }
            else
            {
                model.balance = @"0";
            }
            
            NSString *price_cny = [[[dic objectForKey:@"category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
            NSString *price_usd = [[[dic objectForKey:@"category"] objectForKey:@"cap"] objectForKey:@"price_usd"];
            if ([NSObject isNulllWithObject:dic[@"category"][@"cap"]]) {
                price_cny = @"0";
                price_usd = @"0";
            }
            model.priceCny = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_cny value:2];
            model.priceUsd = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_usd value:2];
            model.address = dic[@"address"];
        }
//        weakSelf.titleView.totalAsset = [NSString DecimalFuncWithOperatorType:0 first:[UserSignData share].user.walletUnitType == 1 ? model.priceCny : model.priceUsd secend:weakSelf.titleView.totalAsset value:5];
//        weakSelf.headerView.asset = [NSString DecimalFuncWithOperatorType:0 first:[UserSignData share].user.walletUnitType == 1 ? model.priceCny : model.priceUsd secend:weakSelf.headerView.asset value:5];
        
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
/**
 获取钱包资产信息
 */
- (void)getWalletAssetInfomation {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%ld", (NSInteger)self.ethWalletModel.listIdentifier] baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
        if (weakSelf.dataSource.count > 1) {
            return ;
        }
        
        [weakSelf.dataSource removeObjectsInRange:NSMakeRange(1, weakSelf.dataSource.count - 1)];
        
        NSString *sum = @"0";
        for (NSDictionary *dic in responseCache[@"list"]) {
            DBHWalletDetailTokenInfomationModelData *model = [[DBHWalletDetailTokenInfomationModelData alloc] init];
            model.dataIdentifier = [NSString stringWithFormat:@"%@", dic[@"id"]];
            model.address = dic[@"gnt_category"][@"address"];
            model.name = dic[@"gnt_category"][@"name"];
            model.icon = dic[@"gnt_category"][@"icon"];
            model.gas = dic[@"gnt_category"][@"gas"];
            
            if (![NSString isNulllWithObject:dic[@"balance"]])
            {
                model.balance = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[dic[@"balance"] substringFromIndex:2]] secend:@"1000000000000000000" value:4];
            }
            else
            {
                model.balance = @"0.0000";
            }
            
            NSString *price_cny = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
            NSString *price_usd = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_usd"];
            if ([NSObject isNulllWithObject:dic[@"gnt_category"][@"cap"]]) {
                price_cny = @"0";
                price_usd = @"0";
            }
            model.priceCny = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_cny value:2];
            model.priceUsd = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_usd value:2];
            model.flag = dic[@"gnt_category"][@"name"];
            
            NSString *price = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:[UserSignData share].user.walletUnitType == 1 ? model.priceCny : model.priceUsd value:5];
            sum = [NSString DecimalFuncWithOperatorType:0 first:sum secend:price value:5];
            
            [weakSelf.dataSource addObject:model];
        }
        
//        weakSelf.titleView.totalAsset = [NSString DecimalFuncWithOperatorType:0 first:sum secend:weakSelf.titleView.totalAsset value:5];
//        weakSelf.headerView.asset = [NSString DecimalFuncWithOperatorType:0 first:sum secend:weakSelf.headerView.asset value:5];
        [weakSelf.tableView reloadData];
    } success:^(id responseObject) {
        [weakSelf endRefresh];
        [weakSelf.dataSource removeObjectsInRange:NSMakeRange(1, weakSelf.dataSource.count - 1)];
        
        NSString *sum = @"0";
        for (NSDictionary *dic in responseObject[@"list"]) {
            DBHWalletDetailTokenInfomationModelData *model = [[DBHWalletDetailTokenInfomationModelData alloc] init];
            model.dataIdentifier = [NSString stringWithFormat:@"%@", dic[@"id"]];
            model.address = dic[@"gnt_category"][@"address"];
            model.name = dic[@"gnt_category"][@"name"];
            model.icon = dic[@"gnt_category"][@"icon"];
            model.gas = dic[@"gnt_category"][@"gas"];
            
            if (![NSString isNulllWithObject:dic[@"balance"]])
            {
                model.balance = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[dic[@"balance"] substringFromIndex:2]] secend:@"1000000000000000000" value:4];
            }
            else
            {
                model.balance = @"0.0000";
            }
            
            NSString *price_cny = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
            NSString *price_usd = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_usd"];
            if ([NSObject isNulllWithObject:dic[@"gnt_category"][@"cap"]]) {
                price_cny = @"0";
                price_usd = @"0";
            }
            model.priceCny = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_cny value:2];
            model.priceUsd = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_usd value:2];
            model.flag = dic[@"gnt_category"][@"name"];
            
            NSString *price = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:[UserSignData share].user.walletUnitType == 1 ? model.priceCny : model.priceUsd value:5];
            sum = [NSString DecimalFuncWithOperatorType:0 first:sum secend:price value:5];
            
            [weakSelf.dataSource addObject:model];
        }
        
        weakSelf.titleView.totalAsset = [NSString DecimalFuncWithOperatorType:0 first:sum secend:weakSelf.titleView.totalAsset value:5];
        weakSelf.headerView.asset = [NSString DecimalFuncWithOperatorType:0 first:sum secend:weakSelf.headerView.asset value:5];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    }];
}
/**
 删除代币
 */
- (void)deleteTokenWithIndex:(NSInteger)index {
    DBHWalletDetailTokenInfomationModelData *model = self.dataSource[index];
    WEAKSELF
    [PPNetworkHelper DELETE:[NSString stringWithFormat:@"user-gnt/%@", model.dataIdentifier] baseUrlType:1 parameters:nil hudString:@"删除中..." success:^(id responseObject) {
        //1.更新数据
        [self.dataSource removeObjectAtIndex:index];
        //2.更新UI
        [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
}

#pragma mark ------ Event Responds ------
/**
 菜单
 */
- (void)respondsToMenuBarButtonItem {
    if (!self.ethWalletModel.isLookWallet && self.menuArray.count > 2 && [[UserSignData share].user.walletZhujiciIdsArray containsObject:@(self.ethWalletModel.listIdentifier)]) {
        [self.menuArray removeObjectAtIndex:0];
    }
    self.menuView.dataSource = [self.menuArray copy];
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.menuView animationShow];
    });
}

#pragma mark ------ Private Methods ------
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.titleView.totalAsset = @"0";
        weakSelf.headerView.asset = @"0";
        
        [weakSelf getETHData];
        [weakSelf getWalletAssetInfomation];
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
- (DBHWalletDetailTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[DBHWalletDetailTitleView alloc] initWithFrame:CGRectMake(0, 0, AUTOLAYOUTSIZE(SCREENWIDTH), 44)];
        _titleView.intrinsicContentSize = CGSizeMake(SCREENWIDTH, 44);
        _titleView.hidden = YES;
        
        WEAKSELF
        [_titleView clickShowPriceBlock:^{
            [weakSelf.tableView reloadData];
            [weakSelf.headerView refreshAsset];
        }];
    }
    return _titleView;
}
- (DBHWalletDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DBHWalletDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(336.5) + STATUS_HEIGHT + 44)];
        _headerView.neoWalletModel = self.ethWalletModel;
        
        WEAKSELF
        [_headerView clickButtonBlock:^(NSInteger index) {
            switch (index) {
                case -1: {
                    // 显示/隐藏资产
                    weakSelf.titleView.totalAsset = weakSelf.titleView.totalAsset;
                    [weakSelf.tableView reloadData];
                    
                    break;
                }
                case 0: {
                    // 二维码
                    DBHQrCodeViewController *qrCodeViewController = [[DBHQrCodeViewController alloc] init];
                    qrCodeViewController.walletModel = weakSelf.ethWalletModel;
                    [weakSelf.navigationController pushViewController:qrCodeViewController animated:YES];
                    
                    break;
                }
                case 1: {
                    // 添加资产
                    DBHAddPropertyViewController *addPropertyViewController = [[DBHAddPropertyViewController alloc] init];
                    addPropertyViewController.walletModel = weakSelf.ethWalletModel;
                    [weakSelf.navigationController pushViewController:addPropertyViewController animated:YES];
                    
                    break;
                }
                case 2: {
                    // 加入
                    [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
                    
                    //                    DBHTokenSaleViewController *tokenSaleViewController = [[DBHTokenSaleViewController alloc] init];
                    //                    [weakSelf.navigationController pushViewController:tokenSaleViewController animated:YES];
                    break;
                }
                case 3: {
                    // 查看
                    [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
                    
                    break;
                }
                case 4: {
                    // 查看
                    [weakSelf.titleView refreshAsset];
                    
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    return _headerView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(62);
        
        _tableView.tableHeaderView = self.headerView;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHWalletDetailTableViewCell class] forCellReuseIdentifier:kDBHWalletDetailTableViewCellIdentifier];
    }
    return _tableView;
}
- (DBHMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[DBHMenuView alloc] init];
        _menuView.dataSource = self.menuArray;
        
        WEAKSELF
        [_menuView selectedBlock:^(NSInteger index) {
            if (weakSelf.ethWalletModel.isLookWallet) {
                if (!index) {
                    // 转化钱包
                    DBHImportWalletWithETHViewController *importWalletWithETHViewController = [[DBHImportWalletWithETHViewController alloc] init];
                    importWalletWithETHViewController.ethWalletModel = weakSelf.ethWalletModel;
                    [self.navigationController pushViewController:importWalletWithETHViewController animated:YES];
                } else {
                    // 删除钱包
                    [PPNetworkHelper DELETE:[NSString stringWithFormat:@"wallet/%ld", (NSInteger)self.ethWalletModel.listIdentifier] baseUrlType:1 parameters:nil hudString:@"删除中..." success:^(id responseObject)
                     {
                         [LCProgressHUD showSuccess:@"删除成功"];
                         [PDKeyChain delete:self.ethWalletModel.address];
                         [self.navigationController popViewControllerAnimated:YES];
                         
                     } failure:^(NSString *error)
                     {
                         [LCProgressHUD showFailure:error];
                     }];
                }
            } else {
                weakSelf.operationType = index + (self.menuArray.count == 3 ? 1 : 2);
                
                // 弹出密码框
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.inputPasswordPromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.inputPasswordPromptView animationShow];
                });
            }
        }];
    }
    return _menuView;
}
- (DBHInputPasswordPromptView *)inputPasswordPromptView {
    if (!_inputPasswordPromptView) {
        _inputPasswordPromptView = [[DBHInputPasswordPromptView alloc] init];
        
        WEAKSELF
        [_inputPasswordPromptView commitBlock:^(NSString *password) {
            switch (weakSelf.operationType) {
                case 1: {
                    // 备份助记词
                    NSString *data = [PDKeyChain load:self.ethWalletModel.address];
                    [LCProgressHUD showLoading:@"验证中..."];
                    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(globalQueue, ^
                                   {
                                       //子线程异步执行下载任务，防止主线程卡顿
                                       NSError * error;
                                       NeomobileWallet *Wallet = NeomobileFromKeyStore(data,password,&error);
                                       
                                       dispatch_queue_t mainQueue = dispatch_get_main_queue();
                                       //异步返回主线程，根据获取的数据，更新UI
                                       dispatch_async(mainQueue, ^
                                                      {
                                                          if (!error)
                                                          {
                                                              //子线程异步执行下载任务，防止主线程卡顿
                                                              NSError * error;
                                                              NSString * mnemonic = [Wallet mnemonic:[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] isEqualToString:@"zh"] ? @"zh_CN" : @"en_US" error:&error];
                                                              
                                                              dispatch_queue_t mainQueue = dispatch_get_main_queue();
                                                              //异步返回主线程，根据获取的数据，更新UI
                                                              dispatch_async(mainQueue, ^
                                                                             {
                                                                                 if (!error)
                                                                                 {
                                                                                     [LCProgressHUD hide];
                                                                                     
                                                                                     PackupsWordsVC * vc = [[PackupsWordsVC alloc] init];
                                                                                     vc.mnemonic = mnemonic;
                                                                                     
                                                                                     WalletLeftListModel *model = [[WalletLeftListModel alloc] init];
                                                                                     model.id = self.ethWalletModel.listIdentifier;
                                                                                     model.category_id = self.ethWalletModel.categoryId;
                                                                                     model.name = self.ethWalletModel.name;
                                                                                     model.address = self.ethWalletModel.address;
                                                                                     model.created_at = self.ethWalletModel.createdAt;
                                                                                     vc.model = model;
                                                                                     
                                                                                     [self.navigationController pushViewController:vc animated:YES];
                                                                                     //                                                                             _isMnemonic = YES;
                                                                                     //                                                                             self.alertView.alertContInfoLB.text = DBHGetStringWithKeyFromTable(@"Please keep in mind the following account security code, which is the effective way to retrieve the wallet, the wallet is once forgot to be able to retrieve account failure, please remember the security code and copied down, no longer appear this operation is not reversible and backup", nil);
                                                                                     //                                                                             [self.alertView.alertSureButton setTitle:DBHGetStringWithKeyFromTable(@"I remember", nil) forState:UIControlStateNormal];
                                                                                     //                                                                             self.alertView.alertTextView.text = mnemonic;
                                                                                     //                                                                             self.alertView.alertTextView.userInteractionEnabled = NO;
                                                                                     //                                                                             [self.alertView showWithView:nil];
                                                                                     
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                     [LCProgressHUD hide];
                                                                                     [LCProgressHUD showMessage:@"获取助记词失败，请稍后重试"];
                                                                                 }
                                                                             });
                                                              
                                                          }
                                                          else
                                                          {
                                                              [LCProgressHUD hide];
                                                              [LCProgressHUD showMessage:@"密码错误，请稍后重试"];
                                                          }
                                                      });
                                       
                                       
                                   });
                    
                    break;
                }
                case 2: {
                    //备份keyStore
                    NSString *data = [PDKeyChain load:self.ethWalletModel.address];
                    [LCProgressHUD showLoading:@"验证中..."];
                    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(globalQueue, ^
                                   {
                                       //子线程异步执行下载任务，防止主线程卡顿
                                       NSError * error;
                                       NeomobileFromKeyStore(data,password,&error);
                                       
                                       dispatch_queue_t mainQueue = dispatch_get_main_queue();
                                       //异步返回主线程，根据获取的数据，更新UI
                                       dispatch_async(mainQueue, ^
                                                      {
                                                          if (!error)
                                                          {
                                                              //要分享内容
                                                              [LCProgressHUD hide];
                                                              NSString *result = data;
                                                              NSArray* activityItems = [[NSArray alloc] initWithObjects:result,nil];
                                                              
                                                              UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                                                              //applicationActivities可以指定分享的应用，不指定为系统默认支持的
                                                              
                                                              kWeakSelf(activityVC)
                                                              activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError)
                                                              {
                                                                  if(completed)
                                                                  {
                                                                      NSLog(@"Share success");
                                                                      //本地记录备份了
                                                                      if ([NSString isNulllWithObject:[UserSignData share].user.walletIdsArray])
                                                                      {
                                                                          [UserSignData share].user.walletIdsArray = [[NSMutableArray alloc] init];
                                                                      }
                                                                      if (![[UserSignData share].user.walletIdsArray containsObject:@(self.ethWalletModel.listIdentifier)])
                                                                      {
                                                                          [[UserSignData share].user.walletIdsArray addObject:@(self.ethWalletModel.listIdentifier)];
                                                                          [[UserSignData share] storageData:[UserSignData share].user];
                                                                      }
                                                                      
                                                                      self.ethWalletModel.isBackUpMnemonnic = YES;
//                                                                      self.headerView.ethWalletModel = self.ethWalletModel;
                                                                  }
                                                                  else
                                                                  {
                                                                      NSLog(@"Cancel the share");
                                                                  }
                                                                  [weakactivityVC dismissViewControllerAnimated:YES completion:nil];
                                                              };
                                                              [self presentViewController:activityVC animated:YES completion:nil];
                                                          }
                                                          else
                                                          {
                                                              [LCProgressHUD hide];
                                                              [LCProgressHUD showMessage:@"密码错误，请重新输入"];
                                                          }
                                                      });
                                       
                                   });
                    
                    break;
                }
                case 3: {
                    //删除
                    NSString *data = [PDKeyChain load:self.ethWalletModel.address];
                    [LCProgressHUD showLoading:@"验证中..."];
                    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(globalQueue, ^
                                   {
                                       //子线程异步执行下载任务，防止主线程卡顿
                                       NSError * error;
                                       NeomobileFromKeyStore(data,password,&error);
                                       
                                       dispatch_queue_t mainQueue = dispatch_get_main_queue();
                                       //异步返回主线程，根据获取的数据，更新UI
                                       dispatch_async(mainQueue, ^
                                                      {
                                                          if (!error)
                                                          {
                                                              [LCProgressHUD hide];
                                                              
                                                              [PPNetworkHelper DELETE:[NSString stringWithFormat:@"wallet/%ld", (NSInteger)self.ethWalletModel.listIdentifier] baseUrlType:1 parameters:nil hudString:@"删除中..." success:^(id responseObject)
                                                               {
                                                                   [LCProgressHUD showSuccess:@"删除成功"];
                                                                   [PDKeyChain delete:self.ethWalletModel.address];
                                                                   [self.navigationController popViewControllerAnimated:YES];
                                                                   
                                                               } failure:^(NSString *error)
                                                               {
                                                                   [LCProgressHUD showFailure:error];
                                                               }];
                                                              
                                                          }
                                                          else
                                                          {
                                                              [LCProgressHUD hide];
                                                              [LCProgressHUD showMessage:@"密码错误，请稍后重试"];
                                                          }
                                                      });
                                       
                                   });
                    
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    return _inputPasswordPromptView;
}

- (NSMutableArray *)menuArray {
    if (!_menuArray) {
        _menuArray = [NSMutableArray array];
        
        if (self.ethWalletModel.isLookWallet) {
            _menuArray = [@[@"Transform Wallet", @"Delete Wallet"] mutableCopy];
        } else {
            _menuArray = [@[@"Backup Mnemonic", @"Backup Keystore", @"Delete Wallet"] mutableCopy];
        }
    }
    return _menuArray;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        DBHWalletDetailTokenInfomationModelData *model = [[DBHWalletDetailTokenInfomationModelData alloc] init];
        model.name = @"ETH";
        model.icon = @"ETH";
        model.balance = @"0.0000";
        model.priceCny = @"0.0000";
        model.priceUsd = @"0.0000";
        model.flag = @"ETH";
        
        [_dataSource addObject:model];
    }
    return _dataSource;
}

@end
