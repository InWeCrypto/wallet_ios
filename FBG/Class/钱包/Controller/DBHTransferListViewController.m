//
//  DBHTransferListViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTransferListViewController.h"

#import "PPNetworkCache.h"

#import "DBHTncTransferViewController.h"
#import "DBHTransferViewController.h"
#import "DBHTransferWithETHViewController.h"
#import "DBHTransferDetailViewController.h"

#import "DBHTransferListHeaderView.h"
#import "DBHTransferListTableViewCell.h"

#import "DBHWalletManagerForNeoModelList.h"
#import "DBHWalletDetailTokenInfomationModelData.h"
#import "DBHTransferListDataModels.h"

static NSString *const kDBHTransferListTableViewCellIdentifier = @"kDBHTransferListTableViewCellIdentifier";

@interface DBHTransferListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DBHTransferListHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *transferButton;

@property (nonatomic, copy) NSString * minBlockNumber;  //最小块号 确认 12
@property (nonatomic, assign) NSString * maxBlockNumber;  //最大块号 当前
@property (nonatomic, copy) NSString * blockPerSecond;  //发生时间  5
@property (nonatomic, copy) NSString *canUseGasBalance; // Gas可用余额
@property (nonatomic, assign) NSInteger page; // 分页
@property (nonatomic, assign) BOOL isRequestSuccess; // 是否请求成功
@property (nonatomic, assign) BOOL isCanTransferAccounts; // 是否可以转账
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 计时器 */
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation DBHTransferListViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blockPerSecond = @"10";
    self.minBlockNumber = @"12";
    
    [self setUI];
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.neoWalletModel.categoryId == 2) {
        [self countDownTime];
        [self timerDown];
    } else {
        [self loadMinblockNumber];
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.transferButton];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.transferButton.mas_top);
    }];
    [self.transferButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(45.5));
        make.centerX.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHTransferListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHTransferListTableViewCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 交易详情
    DBHTransferDetailViewController *transferDetailViewController = [[DBHTransferDetailViewController alloc] init];
    transferDetailViewController.tokenModel = self.tokenModel;
    transferDetailViewController.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:transferDetailViewController animated:YES];
}

#pragma mark ------ Data ------
- (void)loadMinblockNumber
{
    //获取最小块高  默认12
    WEAKSELF
    [PPNetworkHelper GET:@"min-block" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject)
     {
         self.minBlockNumber = [responseObject objectForKey:@"min_block_num"];
         
         //获取轮询时间 当前块发生速度  最小5秒
         [PPNetworkHelper POST:@"extend/blockPerSecond" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject)
          {
              self.blockPerSecond = [NSString stringWithFormat:@"%f",1 / [[responseObject objectForKey:@"bps"] floatValue]];
              [self timerDown];
              [self loadMaxblockNumber];
              
          } failure:^(NSString *error)
          {
          }];
     } failure:^(NSString *error)
     {
         [weakSelf endRefresh];
         [LCProgressHUD showFailure:error];
     }];
}

- (void)loadMaxblockNumber
{
    //当前当前块号  //轮询这个
    WEAKSELF
    [PPNetworkHelper POST:@"extend/blockNumber" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject)
     {
         self.maxBlockNumber = [NSString stringWithFormat:@"%@",[NSString numberHexString:[[responseObject objectForKey:@"value"] substringFromIndex:2]]];
         
         [self getNeoTransferListIsLoadMore:NO];
         
     } failure:^(NSString *error)
     {
         [weakSelf endRefresh];
         [LCProgressHUD showFailure:error];
     }];
}
/**
 获取余额
 */
- (void)getNeoBalance {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%ld", (NSInteger)self.neoWalletModel.listIdentifier] baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
        if (weakSelf.neoWalletModel.categoryId == 1) {
            // ETH
            for (NSDictionary *dic in [responseCache objectForKey:@"list"]) {
                if ([dic[@"name"] isEqualToString:self.tokenModel.name]) {
                    NSString *price_cny = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
                    NSString *price_usd = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
                    NSString *balance = [dic objectForKey:@"balance"];
                    weakSelf.headerView.balance = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[balance substringFromIndex:2]] secend:@"1000000000000000000" value:4];
                    weakSelf.headerView.asset = [UserSignData share].user.walletUnitType == 1 ? price_cny : price_usd;
                }
            }
        } else {
            // NEO
            NSDictionary *record = responseCache[@"record"];
            if ([weakSelf.tokenModel.flag isEqualToString:@"NEO"]) {
                weakSelf.tokenModel.balance = [NSString stringWithFormat:@"%@", record[@"balance"]];
                weakSelf.tokenModel.priceCny = record[@"cap"][@"price_cny"];
                weakSelf.tokenModel.priceUsd = record[@"cap"][@"price_usd"];
            } else if ([weakSelf.tokenModel.flag isEqualToString:@"Gas"]) {
                NSArray *gny = record[@"gnt"];
                NSDictionary *gas = gny.firstObject;
                
                weakSelf.canUseGasBalance = [NSString stringWithFormat:@"%@", gas[@"balance"]];
                weakSelf.tokenModel.balance = [NSString stringWithFormat:@"%@", gas[@"balance"]];
                weakSelf.tokenModel.priceCny = gas[@"cap"][@"price_cny"];
                weakSelf.tokenModel.priceUsd = gas[@"cap"][@"price_usd"];
            } else {
                NSArray *gny = record[@"gnt"];
                NSDictionary *gas = gny.firstObject;
                
                weakSelf.canUseGasBalance = [NSString stringWithFormat:@"%@", gas[@"balance"]];
                
                for (NSDictionary * dic in [responseCache objectForKey:@"list"]) {
                    if ([[dic objectForKey:@"name"] isEqualToString:weakSelf.tokenModel.flag]) {
                        NSData *data = [weakSelf convertHexStrToData:dic[@"balance"]];
                        NSString *decimals = dic[@"decimals"];
                        
                        weakSelf.tokenModel.decimals = decimals;
                        weakSelf.tokenModel.balance = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals.doubleValue)];
                        weakSelf.tokenModel.priceCny = [NSString stringWithFormat:@"%@", dic[@"gnt_category"][@"cap"][@"price_cny"]];
                        weakSelf.tokenModel.priceUsd = [NSString stringWithFormat:@"%@", dic[@"gnt_category"][@"cap"][@"price_usd"]];
                    }
                }
            }
            
            if (![weakSelf.tokenModel.flag isEqualToString:@"NEO"] && ![weakSelf.tokenModel.flag isEqualToString:@"Gas"]) {
                weakSelf.headerView.headImageUrl = weakSelf.tokenModel.icon;
            }
            if ([weakSelf.tokenModel.flag isEqualToString:@"NEO"]) {
                weakSelf.headerView.balance = [NSString stringWithFormat:@"%.0lf", weakSelf.tokenModel.balance.floatValue];
            } else if ([weakSelf.tokenModel.flag isEqualToString:@"TNC"]) {
                weakSelf.headerView.balance = [NSString stringWithFormat:@"%.4lf", weakSelf.tokenModel.balance.floatValue];
            } else {
                weakSelf.headerView.balance = weakSelf.tokenModel.balance;
            }
            NSString *price = [UserSignData share].user.walletUnitType == 1 ? weakSelf.tokenModel.priceCny : weakSelf.tokenModel.priceUsd;
            weakSelf.headerView.asset = [NSString DecimalFuncWithOperatorType:2 first:price secend:weakSelf.tokenModel.balance value:2];
        }
    } success:^(id responseObject) {
        if (weakSelf.neoWalletModel.categoryId == 1) {
            // ETH
            for (NSDictionary *dic in [responseObject objectForKey:@"list"]) {
                if ([dic[@"name"] isEqualToString:self.tokenModel.name]) {
                    NSString *price_cny = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
                    NSString *price_usd = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
                    NSString *balance = [dic objectForKey:@"balance"];
                    weakSelf.headerView.balance = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[balance substringFromIndex:2]] secend:@"1000000000000000000" value:4];
                    weakSelf.headerView.asset = [UserSignData share].user.walletUnitType == 1 ? price_cny : price_usd;
                }
            }
        } else {
            // NEO
            NSDictionary *record = responseObject[@"record"];
            if ([weakSelf.tokenModel.flag isEqualToString:@"NEO"]) {
                weakSelf.tokenModel.balance = [NSString stringWithFormat:@"%@", record[@"balance"]];
                weakSelf.tokenModel.priceCny = record[@"cap"][@"price_cny"];
                weakSelf.tokenModel.priceUsd = record[@"cap"][@"price_usd"];
            } else if ([weakSelf.tokenModel.flag isEqualToString:@"Gas"]) {
                NSArray *gny = record[@"gnt"];
                NSDictionary *gas = gny.firstObject;
                
                weakSelf.tokenModel.balance = [NSString stringWithFormat:@"%@", gas[@"balance"]];
                weakSelf.tokenModel.priceCny = gas[@"cap"][@"price_cny"];
                weakSelf.tokenModel.priceUsd = gas[@"cap"][@"price_usd"];
            } else {
                for (NSDictionary * dic in [responseObject objectForKey:@"list"]) {
                    if ([[dic objectForKey:@"name"] isEqualToString:weakSelf.tokenModel.flag]) {
                        NSData *data = [weakSelf convertHexStrToData:dic[@"balance"]];
                        NSString *decimals = dic[@"decimals"];
                        
                        weakSelf.tokenModel.decimals = decimals;
                        weakSelf.tokenModel.balance = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals.doubleValue)];
                        weakSelf.tokenModel.priceCny = [NSString stringWithFormat:@"%@", dic[@"gnt_category"][@"cap"][@"price_cny"]];
                        weakSelf.tokenModel.priceUsd = [NSString stringWithFormat:@"%@", dic[@"gnt_category"][@"cap"][@"price_usd"]];
                    }
                }
            }
            
            if (![weakSelf.tokenModel.flag isEqualToString:@"NEO"] && ![weakSelf.tokenModel.flag isEqualToString:@"Gas"]) {
                weakSelf.headerView.headImageUrl = weakSelf.tokenModel.icon;
            }
            if ([weakSelf.tokenModel.flag isEqualToString:@"NEO"]) {
                weakSelf.headerView.balance = [NSString stringWithFormat:@"%.0lf", weakSelf.tokenModel.balance.floatValue];
            } else if ([weakSelf.tokenModel.flag isEqualToString:@"TNC"]) {
                weakSelf.headerView.balance = [NSString stringWithFormat:@"%.4lf", weakSelf.tokenModel.balance.floatValue];
            } else {
                weakSelf.headerView.balance = weakSelf.tokenModel.balance;
            }
            NSString *price = [UserSignData share].user.walletUnitType == 1 ? weakSelf.tokenModel.priceCny : weakSelf.tokenModel.priceUsd;
            weakSelf.headerView.asset = [NSString DecimalFuncWithOperatorType:2 first:price secend:weakSelf.tokenModel.balance value:2];
        }
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
/**
 获取转账列表
 */
- (void)getNeoTransferListIsLoadMore:(BOOL)isLoadMore {
    if (isLoadMore) {
        self.page += 1;
    } else {
        self.page = 0;
    }
    WEAKSELF
    NSString *asset_id;
    if ([self.tokenModel.flag isEqualToString:@"NEO"]) {
        asset_id = @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b";
    } else if ([self.tokenModel.flag isEqualToString:@"Gas"]) {
        asset_id = @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7";
    } else if ([self.tokenModel.flag isEqualToString:@"ETH"]) {
        asset_id = @"0x0000000000000000000000000000000000000000";
    } else {
        asset_id = self.tokenModel.address;
    }
    NSString *flag;
    if ([self.tokenModel.flag isEqualToString:@"NEO"] || [self.tokenModel.flag isEqualToString:@"Gas"] || [self.tokenModel.flag isEqualToString:@"TNC"]) {
        flag = @"NEO";
    } else {
        flag = self.tokenModel.flag;
    }
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(self.neoWalletModel.listIdentifier) forKey:@"wallet_id"];
    [parametersDic setObject:flag forKey:@"flag"];
    [parametersDic setObject:@(self.page) forKey:@"page"];
    [parametersDic setObject:asset_id forKey:@"asset_id"];
    
    //包含事务块高  列表   （当前块高-订单里的块高）/最小块高
    [PPNetworkHelper GET:@"wallet-order" baseUrlType:1 parameters:parametersDic hudString:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        weakSelf.isRequestSuccess = YES;
        [weakSelf endRefresh];
        
        if (!isLoadMore) {
            [self.dataSource removeAllObjects];
        }
        
        NSArray *data = responseObject[@"list"];
        if (data.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        BOOL isHaveNoFinishOrder = NO;
        for (NSDictionary * dic in [responseObject objectForKey:@"list"])
        {
            DBHTransferListModelList *model = [DBHTransferListModelList modelObjectWithDictionary:dic];
            model.flag = weakSelf.tokenModel.flag;
            
            if ([weakSelf.tokenModel.flag isEqualToString:@"TNC"]) {
                model.value = [NSString DecimalFuncWithOperatorType:3 first:model.value secend:[NSString stringWithFormat:@"%lf", pow(10, weakSelf.tokenModel.decimals.floatValue)] value:8];
            }
            
            if (!([weakSelf.tokenModel.flag isEqualToString:@"NEO"] || [weakSelf.tokenModel.flag isEqualToString:@"Gas"] || [weakSelf.tokenModel.flag isEqualToString:@"TNC"])) {
                model.confirmTime = dic[@"confirm_at"];
                model.createTime = dic[@"created_at"];
                model.value = dic[@"fee"];
                model.handleFee = dic[@"handle_fee"];
                model.from = dic[@"pay_address"];
                model.to = dic[@"receive_address"];
                model.remark = dic[@"remark"];
                model.tx = dic[@"trade_no"];
                
                if ([weakSelf.tokenModel.flag isEqualToString:@"ETH"]) {
                    if ([model.value containsString:@"0x"]) {
                        model.value = [NSString numberHexString:[model.value substringFromIndex:2]];
                    }
                    model.value = [NSString DecimalFuncWithOperatorType:3 first:model.value secend:@"1000000000000000000" value:8];
                    model.handleFee = [NSString DecimalFuncWithOperatorType:2 first:[NSString numberHexString:[model.handleFee substringFromIndex:2]] secend:@"1000000000000000000" value:8];
                    model.block_number = dic[@"block_number"];
                    model.maxBlockNumber = self.maxBlockNumber;
                    model.minBlockNumber = self.minBlockNumber;
                }
            }
            
            if ([[model.from lowercaseString] isEqualToString:[model.to lowercaseString]]) {
                // 自转
                model.transferType = 0;
            } else {
                model.transferType = [[model.from lowercaseString] isEqualToString:[self.neoWalletModel.address lowercaseString]] ? 1 : 2;
            }
            
            if (!([weakSelf.tokenModel.flag isEqualToString:@"NEO"] || [weakSelf.tokenModel.flag isEqualToString:@"Gas"] || [weakSelf.tokenModel.flag isEqualToString:@"TNC"])) {
                int number;
                if ([model.maxBlockNumber intValue] - [model.block_number intValue] + 1 < 0)
                {
                    //小于0 置为0
                    number = 0;
                }
                else
                {
                    number = ([model.maxBlockNumber intValue] - [model.block_number intValue] + 1);
                }
                if (number < model.minBlockNumber.floatValue && [NSObject isNulllWithObject:model.createTime]) {
                    isHaveNoFinishOrder = YES;
                }
            } else {
                if ([NSObject isNulllWithObject:model.confirmTime]) {
                    isHaveNoFinishOrder = YES;
                }
            }
            
            [self.dataSource addObject:model];
        }
        self.isCanTransferAccounts = !isHaveNoFinishOrder;
        [self.tableView reloadData];

    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 转账
 */
- (void)respondsToTransferButton {
    if (self.neoWalletModel.isLookWallet) {
        [LCProgressHUD showFailure:@"暂不支持冷钱包转账，请转化为热钱包"];
        
        return;
    }
    if (!self.isRequestSuccess) {
        [LCProgressHUD showFailure:@"订单列表尚未加载完成"];
        
        return;
    }
    if (!self.isCanTransferAccounts) {
        [LCProgressHUD showFailure:@"您还有未完成的订单!请稍后重试!"];
        
        return;
    }
    
    if ([self.tokenModel.flag isEqualToString:@"NEO"] || [self.tokenModel.flag isEqualToString:@"Gas"]) {
        DBHTransferViewController *transferViewController = [[DBHTransferViewController alloc] init];
        transferViewController.neoWalletModel = self.neoWalletModel;
        transferViewController.tokenModel = self.tokenModel;
        [self.navigationController pushViewController:transferViewController animated:YES];
    } else if ([self.tokenModel.flag isEqualToString:@"TNC"]) {
        DBHTncTransferViewController *tncTransferViewController = [[DBHTncTransferViewController alloc] init];
        tncTransferViewController.canUseGasBalance = self.canUseGasBalance;
        tncTransferViewController.neoWalletModel = self.neoWalletModel;
        tncTransferViewController.tokenModel = self.tokenModel;
        [self.navigationController pushViewController:tncTransferViewController animated:YES];
    } else {
        DBHTransferWithETHViewController *transferWithETHViewController = [[DBHTransferWithETHViewController alloc] init];
        transferWithETHViewController.neoWalletModel = self.neoWalletModel;
        transferWithETHViewController.tokenModel = self.tokenModel;
        [self.navigationController pushViewController:transferWithETHViewController animated:YES];
    }
}

#pragma mark ------ Private Methods ------
- (void)timerDown {
    //开始计时
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[self.blockPerSecond intValue] target:self selector:@selector(countDownTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)countDownTime
{
    //10s 请求一次接口
    if (self.neoWalletModel.categoryId == 2) {
        [self getNeoTransferListIsLoadMore:NO];
    } else {
        [self loadMaxblockNumber];
    }
    [self getNeoBalance];
}
- (void)getOrderListCache {
    NSString *asset_id;
    if ([self.tokenModel.flag isEqualToString:@"NEO"]) {
        asset_id = @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b";
    } else if ([self.tokenModel.flag isEqualToString:@"Gas"]) {
        asset_id = @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7";
    } else {
        asset_id = self.tokenModel.address;
    }
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(self.neoWalletModel.listIdentifier) forKey:@"wallet_id"];
    [parametersDic setObject:@"NEO" forKey:@"flag"];
    [parametersDic setObject:@(self.page) forKey:@"page"];
    [parametersDic setObject:asset_id forKey:@"asset_id"];
    if (![NSString isNulllWithObject:[PPNetworkCache getResponseCacheForKey:[NSString stringWithFormat:@"%@/%@", @"wallet-order", [NSString dataTOjsonString:parametersDic]]]])
    {
        NSDictionary *responseCache = [PPNetworkCache getResponseCacheForKey:[NSString stringWithFormat:@"%@/%@", @"wallet-order", [NSString dataTOjsonString:parametersDic]]];
        if (/*self.model.category_id == 2*/1) {
            if (![NSString isNulllWithObject:[responseCache objectForKey:@"list"]])
            {
                [self.dataSource removeAllObjects];
                
                for (NSDictionary * dic in [responseCache objectForKey:@"list"])
                {
                    DBHTransferListModelList *model = [DBHTransferListModelList modelObjectWithDictionary:dic];
                    
                    if ([self.tokenModel.flag isEqualToString:@"TNC"]) {
                        model.value = [NSString DecimalFuncWithOperatorType:3 first:model.value secend:[NSString stringWithFormat:@"%lf", pow(10, self.tokenModel.decimals.floatValue)] value:8];
                    }
                    
                    if ([model.from isEqualToString:model.to]) {
                        // 自转
                        model.transferType = 0;
                    } else {
                        model.transferType = [model.from isEqualToString:self.neoWalletModel.address] ? 1 : 2;
                    }
                    
                    [self.dataSource addObject:model];
                }
                [self.tableView reloadData];
            }
        } else {
            if (![NSString isNulllWithObject:[responseCache objectForKey:@"list"]])
            {
                [self.dataSource removeAllObjects];
                
                for (NSDictionary * dic in [responseCache objectForKey:@"list"])
                {
//                    WalletOrderModel * model = [[WalletOrderModel alloc] initWithDictionary:dic];
//                    model.maxBlockNumber = self.maxBlockNumber;
//                    model.minBlockNumber = self.minBlockNumber;
//                    model.flag = [NSObject isNulllWithObject:self.tokenModel] ? @"ether" : [self.tokenModel.flag lowercaseString];
//                    if ([dic[@"from"] isEqualToString:self.model.address] && [dic[@"to"] isEqualToString:self.model.address]) {
//                        model.isMySelf = YES;
//                    } else {
//                        model.isMySelf = NO;
//
//                        if ([model.pay_address isEqualToString:self.model.address])
//                        {
//                            //热钱包 eth
//                            //转账
//                            model.isReceivables = NO;
//                        }
//                        else
//                        {
//                            //收款
//                            model.isReceivables = YES;
//                        }
//                    }
//                    [self.dataSource addObject:model];
                }
                [self.tableView reloadData];
            }
        }
    }
}
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getNeoBalance];
        [weakSelf loadMinblockNumber];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getNeoTransferListIsLoadMore:YES];
    }];
}
- (void)endRefresh {
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.isRefreshing) {
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
- (void)setTokenModel:(DBHWalletDetailTokenInfomationModelData *)tokenModel {
    _tokenModel = tokenModel;
    
    if ([_tokenModel.flag isEqualToString:@"NEO"]) {
        self.headerView.balance = _tokenModel.balance;
    } else {
        self.headerView.balance = [NSString stringWithFormat:@"%.4lf", _tokenModel.balance.floatValue];
    }
    self.headerView.asset = [UserSignData share].user.walletUnitType == 1 ? _tokenModel.priceCny : _tokenModel.priceUsd;
    self.headerView.headImageUrl = _tokenModel.icon;
}

- (DBHTransferListHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DBHTransferListHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(210))];
    }
    return _headerView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(65);
        
        _tableView.tableHeaderView = self.headerView;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHTransferListTableViewCell class] forCellReuseIdentifier:kDBHTransferListTableViewCellIdentifier];
    }
    return _tableView;
}
- (UIButton *)transferButton {
    if (!_transferButton) {
        _transferButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _transferButton.backgroundColor = COLORFROM16(0xFF841C, 1);
        _transferButton.titleLabel.font = BOLDFONT(14);
        _transferButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, AUTOLAYOUTSIZE(2.5));
        _transferButton.titleEdgeInsets = UIEdgeInsetsMake(0, AUTOLAYOUTSIZE(2.5), 0, 0);
        [_transferButton setImage:[UIImage imageNamed:@"跨行转账"] forState:UIControlStateNormal];
        [_transferButton setTitle:DBHGetStringWithKeyFromTable(@"Transfer", nil) forState:UIControlStateNormal];
        [_transferButton addTarget:self action:@selector(respondsToTransferButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferButton;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
