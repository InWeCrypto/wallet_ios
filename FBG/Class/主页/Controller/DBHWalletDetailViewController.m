//
//  DBHWalletDetailViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHWalletDetailViewController.h"

#import "PackupsWordsVC.h"

#import "DBHQrCodeViewController.h"
#import "DBHAddPropertyViewController.h"
#import "DBHTokenSaleViewController.h"
#import "DBHTransferListViewController.h"
#import "DBHExtractGasViewController.h"
#import "DBHImportWalletViewController.h"

#import "DBHWalletDetailTitleView.h"
#import "DBHInputPasswordPromptView.h"
#import "DBHWalletDetailHeaderView.h"
#import "DBHMenuView.h"
#import "DBHWalletDetailTableViewCell.h"

#import "DBHWalletManagerForNeoDataModels.h"
#import "DBHWalletDetailTokenInfomationDataModels.h"

static NSString *const kDBHWalletDetailTableViewCellIdentifier = @"kDBHWalletDetailTableViewCellIdentifier";

@interface DBHWalletDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) DBHWalletDetailTitleView *titleView;
@property (nonatomic, strong) DBHWalletDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHMenuView *menuView;
@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;

@property (nonatomic, assign) NSInteger operationType; // 操作类型 1:备份助记词 2:备份Keystore 3:删除钱包
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHWalletDetailViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.titleView = self.titleView;
    
    [self setUI];
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self getWalletAssetInfomation];
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
        extractGasViewController.wallectId = [NSString stringWithFormat:@"%ld", (NSInteger)weakSelf.neoWalletModel.listIdentifier];
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
    transferListViewController.neoWalletModel = self.neoWalletModel;
    transferListViewController.tokenModel = model;
    [self.navigationController pushViewController:transferListViewController animated:YES];
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2) {
        return @[];
    }
    
    //添加一个删除按钮
    WEAKSELF
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
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
 获取钱包资产信息
 */
- (void)getWalletAssetInfomation {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%ld", (NSInteger)self.neoWalletModel.listIdentifier] isOtherBaseUrl:NO parameters:nil hudString:nil responseCache:^(id responseCache) {
        if (!responseCache) {
            return ;
        }
        [weakSelf.dataSource removeAllObjects];

        NSString *sum = @"0.00";
        NSDictionary *record = responseCache[@"record"];
        NSString *neoNumber = [NSString stringWithFormat:@"%@", record[@"balance"]];
        NSString *neoPriceForCny = record[@"cap"][@"price_cny"];
        NSString *neoPriceForUsd = record[@"cap"][@"price_usd"];
        DBHWalletDetailTokenInfomationModelData *neoModel = [[DBHWalletDetailTokenInfomationModelData alloc] init];
        neoModel.address = record[@"address"];
        neoModel.name = @"NEO";
        neoModel.icon = @"NEO_add";
        neoModel.balance = neoNumber;
        neoModel.priceCny = [NSString DecimalFuncWithOperatorType:2 first:neoNumber secend:neoPriceForCny value:2];
        neoModel.priceUsd = [NSString DecimalFuncWithOperatorType:2 first:neoNumber secend:neoPriceForUsd value:2];
        neoModel.flag = @"NEO";
        sum = [NSString DecimalFuncWithOperatorType:0 first:sum secend:[UserSignData share].user.walletUnitType == 1 ? neoModel.priceCny : neoModel.priceUsd value:2];

        NSArray *gny = record[@"gnt"];
        NSDictionary *gas = gny.firstObject;
        NSString *gasPriceForCny = gas[@"cap"][@"price_cny"];
        NSString *gasPriceForUsd = gas[@"cap"][@"price_usd"];
        NSString *gasNumber = [NSString stringWithFormat:@"%@", gas[@"balance"]];
        DBHWalletDetailTokenInfomationModelData *gasModel = [[DBHWalletDetailTokenInfomationModelData alloc] init];
        gasModel.address = record[@"address"];
        gasModel.name = @"Gas";
        gasModel.icon = @"NEO_add";//@"NEO_project_icon_Gas";
        gasModel.balance = gasNumber;
        gasModel.priceCny = [NSString DecimalFuncWithOperatorType:2 first:gasNumber secend:gasPriceForCny value:2];
        gasModel.priceUsd = [NSString DecimalFuncWithOperatorType:2 first:gasNumber secend:gasPriceForUsd value:2];
        gasModel.flag = @"Gas";
        gasModel.canExtractbalance = gas[@"available"];
        gasModel.noExtractbalance = gas[@"unavailable"];
        gasModel.dataIdentifier = gas[@"cap"][@"id"];
        sum = [NSString DecimalFuncWithOperatorType:0 first:sum secend:[UserSignData share].user.walletUnitType == 1 ? gasModel.priceCny : gasModel.priceUsd value:2];

        [self.dataSource addObject:neoModel];
        [self.dataSource addObject:gasModel];

        for (NSDictionary * dic in [responseCache objectForKey:@"list"])
        {
            DBHWalletDetailTokenInfomationModelData *model = [[DBHWalletDetailTokenInfomationModelData alloc] init];
            model.icon = [[dic objectForKey:@"gnt_category"] objectForKey:@"icon"];
            model.address = [[dic objectForKey:@"gnt_category"] objectForKey:@"address"];
            //                model.symbol = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"symbol"];
            model.flag = [dic objectForKey:@"name"];
            
            NSData *data = [weakSelf convertHexStrToData:dic[@"balance"]];
            
            NSString *decimals = dic[@"decimals"];
            
            model.balance = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals.doubleValue)];
            model.priceCny = @"0";
            model.priceUsd = @"0";
            //                model.gas = [[[dic objectForKey:@"gnt_category"] objectForKey:@"gas"] intValue];
            [weakSelf.dataSource addObject:model];
        }

        weakSelf.titleView.totalAsset = sum;
        weakSelf.headerView.asset = sum;
        [weakSelf.tableView reloadData];
    } success:^(id responseObject) {
        [weakSelf endRefresh];
        [weakSelf.dataSource removeAllObjects];

        NSString *sum = @"0.00";
        NSDictionary *record = responseObject[@"record"];
        NSString *neoNumber = [NSString stringWithFormat:@"%@", record[@"balance"]];
        NSString *neoPriceForCny = record[@"cap"][@"price_cny"];
        NSString *neoPriceForUsd = record[@"cap"][@"price_usd"];
        DBHWalletDetailTokenInfomationModelData *neoModel = [[DBHWalletDetailTokenInfomationModelData alloc] init];
        neoModel.address = record[@"address"];
        neoModel.name = @"NEO";
        neoModel.icon = @"NEO_add";
        neoModel.balance = neoNumber;
        neoModel.priceCny = [NSString DecimalFuncWithOperatorType:2 first:neoNumber secend:neoPriceForCny value:2];;
        neoModel.priceUsd = [NSString DecimalFuncWithOperatorType:2 first:neoNumber secend:neoPriceForUsd value:2];
        neoModel.flag = @"NEO";
        sum = [NSString DecimalFuncWithOperatorType:0 first:sum secend:[UserSignData share].user.walletUnitType == 1 ? neoModel.priceCny : neoModel.priceUsd value:2];

        NSArray *gny = record[@"gnt"];
        NSDictionary *gas = gny.firstObject;
        NSString *gasPriceForCny = gas[@"cap"][@"price_cny"];
        NSString *gasPriceForUsd = gas[@"cap"][@"price_usd"];
        NSString *gasNumber = [NSString stringWithFormat:@"%@", gas[@"balance"]];
        DBHWalletDetailTokenInfomationModelData *gasModel = [[DBHWalletDetailTokenInfomationModelData alloc] init];
        gasModel.address = record[@"address"];
        gasModel.name = @"Gas";
        gasModel.icon = @"NEO_add";//@"NEO_project_icon_Gas";
        gasModel.balance = gasNumber;
        gasModel.priceCny = [NSString DecimalFuncWithOperatorType:2 first:gasNumber secend:gasPriceForCny value:2];
        gasModel.priceUsd = [NSString DecimalFuncWithOperatorType:2 first:gasNumber secend:gasPriceForUsd value:2];;
        gasModel.flag = @"Gas";
        gasModel.canExtractbalance = gas[@"available"];
        gasModel.noExtractbalance = gas[@"unavailable"];
        gasModel.dataIdentifier = gas[@"cap"][@"id"];
        sum = [NSString DecimalFuncWithOperatorType:0 first:sum secend:[UserSignData share].user.walletUnitType == 1 ? gasModel.priceCny : gasModel.priceUsd value:2];

        [self.dataSource addObject:neoModel];
        [self.dataSource addObject:gasModel];

        for (NSDictionary * dic in [responseObject objectForKey:@"list"])
        {
            DBHWalletDetailTokenInfomationModelData *model = [[DBHWalletDetailTokenInfomationModelData alloc] init];
            model.dataIdentifier = dic[@"id"];
            model.icon = [[dic objectForKey:@"gnt_category"] objectForKey:@"icon"];
            model.address = [[dic objectForKey:@"gnt_category"] objectForKey:@"address"];
            //                model.symbol = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"symbol"];
            model.flag = [dic objectForKey:@"name"];

            NSData *data = [weakSelf convertHexStrToData:dic[@"balance"]];
            NSString *decimals = dic[@"decimals"];
            model.decimals = decimals;
            model.balance = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals.doubleValue)];
            model.priceCny = @"0";
            model.priceUsd = @"0";
            //                model.gas = [[[dic objectForKey:@"gnt_category"] objectForKey:@"gas"] intValue];
            [weakSelf.dataSource addObject:model];
        }

        weakSelf.titleView.totalAsset = sum;
        weakSelf.headerView.asset = sum;
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
    [PPNetworkHelper DELETE:[NSString stringWithFormat:@"user-gnt/%@", model.dataIdentifier] isOtherBaseUrl:NO parameters:nil hudString:@"删除中..." success:^(id responseObject) {
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
/**
 将16进制的字符串转换成NSData
 */
- (NSData *)convertHexStrToData:(NSString *)str {
    NSString *balance = [NSString stringWithFormat:@"%@", str];
    if (!balance || [balance length] == 0) {
        
        return nil;
        
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    
    NSRange range;
    
    if ([balance length] %2 == 0) {
        
        range = NSMakeRange(0,2);
        
    } else {
        
        range = NSMakeRange(0,1);
        
    }
    
    for (NSInteger i = range.location; i < [balance length]; i += 2) {
        
        unsigned int anInt;
        
        NSString *hexCharStr = [balance substringWithRange:range];
        
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        
        
        [scanner scanHexInt:&anInt];
        
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        
        [hexData appendData:entity];
        
        
        
        range.location += range.length;
        
        range.length = 2;
        
    }
    
    return [hexData copy];
}
/**
 byte转换成余额
 */
- (unsigned long long)getBalanceWithByte:(Byte *)byte length:(NSInteger)length {
    Byte newByte[length];
    for (NSInteger i = 0; i < length; i++) {
        newByte[i] = byte[length - i - 1];
    }
    
    NSString *hexStr = @"";
    for(int i=0;i < length;i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",newByte[i]&0xff]; // 16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    NSScanner * scanner = [NSScanner scannerWithString:hexStr];
    
    unsigned long long balance;
    
    [scanner scanHexLongLong:&balance];
    
    return balance;
}

#pragma mark ------ Getters And Setters ------
- (DBHWalletDetailTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[DBHWalletDetailTitleView alloc] initWithFrame:CGRectMake(0, 0, AUTOLAYOUTSIZE(SCREENWIDTH), 44)];
        _titleView.intrinsicContentSize = CGSizeMake(SCREENWIDTH, 44);
        _titleView.hidden = YES;
    }
    return _titleView;
}
- (DBHWalletDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DBHWalletDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(336.5) + STATUS_HEIGHT + 44)];
        _headerView.neoWalletModel = self.neoWalletModel;
        
        WEAKSELF
        [_headerView clickButtonBlock:^(NSInteger index) {
            switch (index) {
                case 0: {
                    // 二维码
                    DBHQrCodeViewController *qrCodeViewController = [[DBHQrCodeViewController alloc] init];
                    qrCodeViewController.address = weakSelf.neoWalletModel.address;
                    [weakSelf.navigationController pushViewController:qrCodeViewController animated:YES];
                    
                    break;
                }
                case 1: {
                    // 添加资产
                    DBHAddPropertyViewController *addPropertyViewController = [[DBHAddPropertyViewController alloc] init];
                    addPropertyViewController.neoWalletModel = weakSelf.neoWalletModel;
                    [weakSelf.navigationController pushViewController:addPropertyViewController animated:YES];
                    
                    break;
                }
                case 2: {
                    // 加入
                    [LCProgressHUD showInfoMsg:NSLocalizedString(@"Coming Soon", nil)];
                    
//                    DBHTokenSaleViewController *tokenSaleViewController = [[DBHTokenSaleViewController alloc] init];
//                    [weakSelf.navigationController pushViewController:tokenSaleViewController animated:YES];
                    break;
                }
                    
                default: {
                    // 查看
                    [LCProgressHUD showInfoMsg:NSLocalizedString(@"Coming Soon", nil)];
                    
                    break;
                }
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
        _menuView.dataSource = self.neoWalletModel.isLookWallet ? @[@"Transform Wallet", @"Delete Wallet"] : @[@"Backup Mnemonic", @"Backup Keystore", @"Delete Wallet"];
        
        WEAKSELF
        [_menuView selectedBlock:^(NSInteger index) {
            if (weakSelf.neoWalletModel.isLookWallet) {
                if (!index) {
                    // 转化钱包
                    DBHImportWalletViewController *importWalletViewController = [[DBHImportWalletViewController alloc] init];
                    importWalletViewController.neoWalletModel = weakSelf.neoWalletModel;
                    [self.navigationController pushViewController:importWalletViewController animated:YES];
                } else {
                    // 删除钱包
                    weakSelf.operationType = 3;
                    
                    // 弹出密码框
                    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.inputPasswordPromptView];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.inputPasswordPromptView animationShow];
                    });
                }
            } else {
                switch (index) {
                    case 0: {
                        // 备份助记词
                        weakSelf.operationType = 1;
                        break;
                    }
                    case 1: {
                        // 备份Keystore
                        weakSelf.operationType = 2;
                        break;
                    }
                    case 2: {
                        // 删除钱包
                        weakSelf.operationType = 3;
                        break;
                    }
                        
                    default:
                        break;
                }
                
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
                    NSString *data = [PDKeyChain load:self.neoWalletModel.address];
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
                                                              NSString * mnemonic = [Wallet mnemonic:&error];
                                                              
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
                                                                                     model.id = self.neoWalletModel.listIdentifier;
                                                                                     model.category_id = self.neoWalletModel.categoryId;
                                                                                     model.name = self.neoWalletModel.name;
                                                                                     model.address = self.neoWalletModel.address;
                                                                                     model.created_at = self.neoWalletModel.createdAt;
                                                                                     vc.model = model;
                                                                                     
                                                                                     [self.navigationController pushViewController:vc animated:YES];
                                                                                     //                                                                             _isMnemonic = YES;
                                                                                     //                                                                             self.alertView.alertContInfoLB.text = NSLocalizedString(@"Please keep in mind the following account security code, which is the effective way to retrieve the wallet, the wallet is once forgot to be able to retrieve account failure, please remember the security code and copied down, no longer appear this operation is not reversible and backup", nil);
                                                                                     //                                                                             [self.alertView.alertSureButton setTitle:NSLocalizedString(@"I remember", nil) forState:UIControlStateNormal];
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
                    NSString *data = [PDKeyChain load:self.neoWalletModel.address];
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
                                                                      if (![[UserSignData share].user.walletIdsArray containsObject:@(self.neoWalletModel.listIdentifier)])
                                                                      {
                                                                          [[UserSignData share].user.walletIdsArray addObject:@(self.neoWalletModel.listIdentifier)];
                                                                          [[UserSignData share] storageData:[UserSignData share].user];
                                                                      }
                                                                      
                                                                      self.neoWalletModel.isBackUpMnemonnic = YES;
                                                                      self.headerView.neoWalletModel = self.neoWalletModel;
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
                    NSString *data = [PDKeyChain load:self.neoWalletModel.address];
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
                                                              
                                                              [PPNetworkHelper DELETE:[NSString stringWithFormat:@"wallet/%ld", (NSInteger)self.neoWalletModel.listIdentifier] isOtherBaseUrl:NO parameters:nil hudString:@"删除中..." success:^(id responseObject)
                                                               {
                                                                   [LCProgressHUD showSuccess:@"删除成功"];
                                                                   [PDKeyChain delete:self.neoWalletModel.address];
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

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
