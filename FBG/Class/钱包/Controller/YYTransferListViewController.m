//
//  YYTransferListViewController.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYTransferListViewController.h"
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
#import "DBHWalletManagerForNeoModelCategory.h"
#import "YYWalletConversionListModel.h"

static NSString *const kDBHTransferListTableViewCellIdentifier = @"kDBHTransferListTableViewCellIdentifier";

@interface YYTransferListViewController ()<UITableViewDataSource, UITableViewDelegate>

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
@property (nonatomic, assign) BOOL isNeedInvalidateTimer; // 是否将timer置空
/** 计时器 */
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation YYTransferListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setUI];
}

- (void)dealloc {
    [self removeTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([UserSignData share].user.isLogin) {
        [self getDataFromServer];
    }

    if ([self isEth]) {
        [self loadMinblockNumber];
    } else {
        [self countDownTime];
        [self timerDown];
    }
}

- (void)getDataFromServer {
    [self loadMinblockNumber];
    [self getNeoBalance];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.isNeedInvalidateTimer = YES;
    [self removeTimer];
}

- (void)removeTimer {
    if (_timer) {
        [self.timer invalidate];
        _timer = nil;
    }
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
    [self addRefresh];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHTransferListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHTransferListTableViewCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.dataSource.count) {
        cell.neoWalletModel = self.neoWalletModel; //必须放在第一行
        cell.model = self.dataSource[indexPath.row];
    }
    
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
- (void)getDataFromCache {
    //TODO
}

- (void)initData {
    self.blockPerSecond = @"10";
    self.minBlockNumber = @"12";
    
    [self getDataFromCache];
}

- (BOOL)isEth {
    return self.neoWalletModel.categoryId == 1;
}

- (NSString *)flag {
    return self.tokenModel.flag;
}

- (void)loadMinblockNumber {
    //获取最小块高  默认12
    WEAKSELF
    [PPNetworkHelper GET:@"min-block" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
        [weakSelf handleResponseObject:responseObject type:1];
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    }];
}

- (void)handleResponseObject:(id)responseObject type:(NSInteger)type {
    if ([NSObject isNulllWithObject:responseObject]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (type == 1) { // min-block
            self.minBlockNumber = [responseObject objectForKey:MIN_BLOCK_NUM];
            WEAKSELF
            //获取轮询时间 当前块发生速度  最小5秒
            [PPNetworkHelper POST:@"extend/blockPerSecond" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
                [weakSelf handleResponseObject:responseObject type:2];
            } failure:^(NSString *error) {
            }];
        } else if (type == 2) { // extend/blockPerSecond
            self.blockPerSecond = [NSString stringWithFormat:@"%f", 1 / [[responseObject objectForKey:BPS] floatValue]];
            [self timerDown];
            [self loadMaxblockNumber];
        }
    });
}

- (void)loadMaxblockNumber {
    //当前当前块号  //轮询这个
    WEAKSELF
    [PPNetworkHelper POST:@"extend/blockNumber" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
        weakSelf.maxBlockNumber = [NSString stringWithFormat:@"%@",[NSString numberHexString:[[responseObject objectForKey:VALUE] substringFromIndex:2]]];
        [weakSelf getNeoTransferListIsLoadMore:NO];
        
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    }];
}

- (void)handleResponseObj:(id)responseObject {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        if ([NSObject isNulllWithObject:responseObject]) {
            return;
        }
        
        NSString *resultBalance = @"0.0000";
        NSString *resultAsset = @"0.0000";
        NSString *headImageUrl = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *list = responseObject[LIST];
            if ([self isEth]) { // ETH 及其代币
                for (NSDictionary *dict in list) {
                    @autoreleasepool {
                        YYWalletConversionListModel *listModel = [YYWalletConversionListModel mj_objectWithKeyValues:dict];
                        NSString *name = listModel.name;
                        if ([name isEqualToString:self.tokenModel.name]) {
                            NSString *price_cny = listModel.gnt_category.cap.priceCny;
                            NSString *price_usd = listModel.gnt_category.cap.priceUsd;
                            NSString *balance = listModel.balance;
                            
                            
                            if ([name isEqualToString:ETH]) {
                                resultBalance = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[balance substringFromIndex:2]] secend:@"1000000000000000000" value:4];
                            } else {
                                NSInteger decimals = listModel.decimals;
                                resultBalance = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[balance substringFromIndex:2]] secend:[NSString stringWithFormat:@"%lf", pow(10, decimals)] value:4];
                            }
                            resultAsset = [UserSignData share].user.walletUnitType == 1 ? price_cny : price_usd;
                        }
                    }
                }
            } else { // NEO
                NSDictionary *record = responseObject[RECORD];
                if (![NSObject isNulllWithObject:record]) {
                    DBHWalletManagerForNeoModelList *recordModel = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:record];
                    if ([self.flag isEqualToString:NEO]) {
                        self.tokenModel.balance = recordModel.balance;
                        
                        NSString *neoPriceForCny = recordModel.cap.priceCny;
                        NSString *neoPriceForUsd = recordModel.cap.priceUsd;
                        self.tokenModel.priceCny = neoPriceForCny;
                        self.tokenModel.priceUsd = neoPriceForUsd;
                    } else if([self.flag isEqualToString:GAS]) { // GAS
                        NSArray *gnt = recordModel.gnt;
                        
                        NSString *gasPriceForCny = @"0";
                        NSString *gasPriceForUsd = @"0";
                        if (![NSObject isNulllWithObject:gnt] && gnt.count > 0) {
                            YYWalletRecordGntModel *gasGntModel = gnt.firstObject;
                            gasPriceForCny = gasGntModel.cap.priceCny;
                            gasPriceForUsd = gasGntModel.cap.priceUsd;
                        }
                        
                        self.tokenModel.priceCny = gasPriceForCny;
                        self.tokenModel.priceUsd = gasPriceForUsd;
                    }
                    
                } else { // 代币
                    for (NSDictionary *dict in list) {
                        @autoreleasepool {
                            YYWalletConversionListModel *listModel = [YYWalletConversionListModel mj_objectWithKeyValues:dict];
                            NSString *name = listModel.name;
                            if ([name isEqualToString:self.flag]) {
                                NSData *data = [self convertHexStrToData:listModel.balance];
                                NSInteger decimals = listModel.decimals;
                                
                                self.tokenModel.decimals = [NSString stringWithFormat:@"%@", @(decimals)];
                                self.tokenModel.balance = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals)];
                                
                                NSString *price_cny = listModel.gnt_category.cap.priceCny;
                                NSString *price_usd = listModel.gnt_category.cap.priceUsd;
                                
                                self.tokenModel.priceCny = [NSString stringWithFormat:@"%@", price_cny];
                                self.tokenModel.priceUsd = [NSString stringWithFormat:@"%@", price_usd];
                            }
                        }
                    }
                }
                
                if (![self.flag isEqualToString:NEO] && ![self.flag isEqualToString:GAS]) { //代币
                    headImageUrl = self.tokenModel.icon;
                }
                
                if ([self.flag isEqualToString:NEO]) { // neo
                    resultBalance = [NSString stringWithFormat:@"%.0lf", self.tokenModel.balance.doubleValue];
                } else if ([self.flag isEqualToString:GAS]) { // gas
                    resultBalance = self.tokenModel.balance;
                } else { // dai'b
                    resultBalance = [NSString stringWithFormat:@"%.4lf", self.tokenModel.balance.doubleValue];
                }
                NSString *price = [UserSignData share].user.walletUnitType == 1 ? self.tokenModel.priceCny : self.tokenModel.priceUsd;
                resultAsset = [NSString DecimalFuncWithOperatorType:2 first:price secend:self.tokenModel.balance value:2];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.headerView.headImageUrl = headImageUrl;
            self.headerView.balance = resultBalance;
            self.headerView.asset = resultAsset;
        });
    });
}

/**
 获取余额
 */
- (void)getNeoBalance {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%ld", (NSInteger)self.neoWalletModel.listIdentifier] baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
        [weakSelf handleResponseObj:responseCache];
    } success:^(id responseObject) {
        [weakSelf handleResponseObj:responseObject];
    } failure:^(NSString *error) {
        //        [LCProgressHUD showFailure:error];
    } specialBlock:^{
        if (![UserSignData share].user.isLogin) {
            return ;
        }
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
    NSString *flag;
    if ([self isEth]) { // eth及其代币
        if ([self.flag isEqualToString:ETH]) { // eth
            flag = self.neoWalletModel.category.name;
            asset_id = @"0x0000000000000000000000000000000000000000";
        } else { //eth代币
            flag = self.tokenModel.name;
            asset_id = [self.tokenModel.address lowercaseString];
        }
    } else { // neo gas 及其代币
        flag = NEO;
        if ([self.flag isEqualToString:NEO]) {
            asset_id = @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b";
        } else if ([self.flag isEqualToString:GAS]) {
            asset_id = @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7";
        } else {
            asset_id = self.tokenModel.address;
        }
    }
    
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(self.neoWalletModel.listIdentifier) forKey:WALLET_ID];
    [parametersDic setObject:flag forKey:FLAG];
    [parametersDic setObject:@(self.page) forKey:PAGE];
    [parametersDic setObject:asset_id forKey:ASSET_ID];
    
    //包含事务块高  列表   （当前块高-订单里的块高）/最小块高
    //     NSString *urlStr = [NSString stringWithFormat:@"wallet-order?page=%d&wallet_id=%d&asset_id=%@&flag=%@", (int)self.page, (int)self.neoWalletModel.listIdentifier, asset_id, flag];
    [PPNetworkHelper GET:@"wallet-order" baseUrlType:1 parameters:parametersDic hudString:nil responseCache:^(id responseCache) {
        if (!isLoadMore) { //不是刷新
            [weakSelf.dataSource removeAllObjects];
        }
        
        NSArray *data = responseCache[LIST];
        if (data.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        NSLog(@"after flag = %@ ", weakSelf.flag);
        BOOL isHaveNoFinishOrder = NO;
        NSArray *list = responseCache[LIST];
        for (NSDictionary * dic in list) {
            DBHTransferListModelList *model = [DBHTransferListModelList modelObjectWithDictionary:dic];
            
            model.flag = weakSelf.flag;
            model.typeName = weakSelf.tokenModel.typeName;
            
            // 只有neo的代币才设置value   // 代币的话，value值应该要除以10的decimals次方
            if (!([weakSelf isEth] ||
                  [weakSelf.flag isEqualToString:NEO] ||
                  [weakSelf.flag isEqualToString:GAS])) {
                model.value = [NSString DecimalFuncWithOperatorType:3 first:model.value secend:[NSString stringWithFormat:@"%lf", pow(10, weakSelf.tokenModel.decimals.doubleValue)] value:8];
            }
            
            // eth及其代币的
            if ([weakSelf isEth]) {
                model.confirmTime = dic[CONFIRM_AT];
                model.createTime = dic[CREATED_AT];
                model.value = dic[FEE];
                model.handleFee = dic[HANDLE_FEE];
                model.from = dic[PAY_ADDRESS];
                model.to = dic[RECEIVE_ADDRESS];
                model.remark = dic[REMARK];
                model.tx = dic[TRADE_NO];
                
                if ([weakSelf isEth]) { //ETH及代币的
                    if ([model.value containsString:@"0x"]) {
                        model.value = [NSString numberHexString:[model.value substringFromIndex:2]];
                    }
                    
                    NSString *secondStr = @"1000000000000000000";
                    model.handleFee = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[model.handleFee substringFromIndex:2]] secend:secondStr value:8];
                    
                    if (![[weakSelf flag] isEqualToString:ETH]) { // eth代币
                        secondStr = [NSString stringWithFormat:@"%lf", pow(10, weakSelf.tokenModel.decimals.doubleValue)];
                    }
                    model.value = [NSString DecimalFuncWithOperatorType:3 first:model.value secend:secondStr value:8];
                    model.block_number = dic[BLOCK_NUMBER];
                    model.maxBlockNumber = weakSelf.maxBlockNumber;
                    model.minBlockNumber = weakSelf.minBlockNumber;
                }
            }
            
            if ([[model.from lowercaseString] isEqualToString:[model.to lowercaseString]]) {
                // 自转
                model.transferType = 0;
            } else {
                model.transferType = [[model.from lowercaseString] isEqualToString:[weakSelf.neoWalletModel.address lowercaseString]] ? 1 : 2;
            }
            
            // eth和代币的
            if ([weakSelf isEth]) {
                int number;
                if ([model.maxBlockNumber intValue] - [model.block_number intValue] + 1 < 0) {
                    //小于0 置为0
                    number = 0;
                } else {
                    number = ([model.maxBlockNumber intValue] - [model.block_number intValue] + 1);
                }
                if (number < model.minBlockNumber.doubleValue && [NSObject isNulllWithObject:model.createTime]) {
                    isHaveNoFinishOrder = YES;
                }
            } else {
                if ([NSObject isNulllWithObject:model.confirmTime]) {
                    isHaveNoFinishOrder = YES;
                }
            }
            
            [weakSelf.dataSource addObject:model];
        }
        weakSelf.isCanTransferAccounts = !isHaveNoFinishOrder;
        [weakSelf.tableView reloadData];
        
    } success:^(id responseObject) {
        weakSelf.isRequestSuccess = YES;
        [weakSelf endRefresh];
        
        if (!isLoadMore) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        NSArray *data = responseObject[LIST];
        if (data.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        NSLog(@"after flag = %@ ", weakSelf.flag);
        BOOL isHaveNoFinishOrder = NO;
        NSArray *list = responseObject[LIST];
        for (NSDictionary * dic in list) {
            DBHTransferListModelList *model = [DBHTransferListModelList modelObjectWithDictionary:dic];
            
            model.flag = weakSelf.flag;
            model.typeName = weakSelf.tokenModel.typeName;
            
            // 只有neo的代币才设置value   // 代币的话，value值应该要除以10的decimals次方
            if (!([weakSelf isEth] ||
                  [weakSelf.flag isEqualToString:NEO] ||
                  [weakSelf.flag isEqualToString:GAS])) {
                model.value = [NSString DecimalFuncWithOperatorType:3 first:model.value secend:[NSString stringWithFormat:@"%lf", pow(10, weakSelf.tokenModel.decimals.doubleValue)] value:8];
            }
            
            // eth及其代币的
            if ([weakSelf isEth]) {
                model.confirmTime = dic[CONFIRM_AT];
                model.createTime = dic[CREATED_AT];
                model.value = dic[FEE];
                model.handleFee = dic[HANDLE_FEE];
                model.from = dic[PAY_ADDRESS];
                model.to = dic[RECEIVE_ADDRESS];
                model.remark = dic[REMARK];
                model.tx = dic[TRADE_NO];
                
                if ([weakSelf isEth]) { //ETH及代币的
                    if ([model.value containsString:@"0x"]) {
                        model.value = [NSString numberHexString:[model.value substringFromIndex:2]];
                    }
                    
                    NSString *secondStr = @"1000000000000000000";
                    model.handleFee = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[model.handleFee substringFromIndex:2]] secend:secondStr value:8];
                    
                    if (![[weakSelf flag] isEqualToString:ETH]) { // eth代币
                        secondStr = [NSString stringWithFormat:@"%lf", pow(10, weakSelf.tokenModel.decimals.doubleValue)];
                    }
                    model.value = [NSString DecimalFuncWithOperatorType:3 first:model.value secend:secondStr value:8];
                    model.block_number = dic[BLOCK_NUMBER];
                    model.maxBlockNumber = weakSelf.maxBlockNumber;
                    model.minBlockNumber = weakSelf.minBlockNumber;
                }
            }
            
            if ([[model.from lowercaseString] isEqualToString:[model.to lowercaseString]]) {
                // 自转
                model.transferType = 0;
            } else {
                model.transferType = [[model.from lowercaseString] isEqualToString:[weakSelf.neoWalletModel.address lowercaseString]] ? 1 : 2;
            }
            
            // eth和代币的
            if ([weakSelf isEth]) {
                int number;
                if ([model.maxBlockNumber intValue] - [model.block_number intValue] + 1 < 0) {
                    //小于0 置为0
                    number = 0;
                } else {
                    number = ([model.maxBlockNumber intValue] - [model.block_number intValue] + 1);
                }
                if (number < model.minBlockNumber.doubleValue && [NSObject isNulllWithObject:model.createTime]) {
                    isHaveNoFinishOrder = YES;
                }
            } else {
                if ([NSObject isNulllWithObject:model.confirmTime]) {
                    isHaveNoFinishOrder = YES;
                }
            }
            
            [weakSelf.dataSource addObject:model];
        }
        
        NSLog(@"datasource = %ld", weakSelf.dataSource.count);
        weakSelf.isCanTransferAccounts = !isHaveNoFinishOrder;
        [weakSelf.tableView reloadData];
        
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    } specialBlock:^{
        if (![UserSignData share].user.isLogin) {
            return ;
        }
    }];
}

#pragma mark ------ Event Responds ------
/**
 转账
 */
- (void)respondsToTransferButton {
    if (self.neoWalletModel.isLookWallet) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Transferring from cold wallet is not supported at the moment. Please Change to hot wallet", nil)];
        
        return;
    }
    if (!self.isRequestSuccess) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Order list has not been loaded yet", nil)];
        
        return;
    }
    if (!self.isCanTransferAccounts) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"You still have unfinished orders! Please try again later!", nil)];
        
        return;
    }
    
    NSString *flag = self.flag;
    if ([flag isEqualToString:NEO] || [flag isEqualToString:GAS]) { // neo gas
        DBHTransferViewController *transferViewController = [[DBHTransferViewController alloc] init];
        transferViewController.neoWalletModel = self.neoWalletModel;
        transferViewController.tokenModel = self.tokenModel;
        [self.navigationController pushViewController:transferViewController animated:YES];
    } else if ([self isEth]) { // eth
        DBHTransferWithETHViewController *transferWithETHViewController = [[DBHTransferWithETHViewController alloc] init];
        transferWithETHViewController.neoWalletModel = self.neoWalletModel;
        transferWithETHViewController.tokenModel = self.tokenModel;
        [self.navigationController pushViewController:transferWithETHViewController animated:YES];
    } else { // neo代币
        DBHTncTransferViewController *tncTransferViewController = [[DBHTncTransferViewController alloc] init];
        tncTransferViewController.canUseGasBalance = self.canUseGasBalance;
        tncTransferViewController.neoWalletModel = self.neoWalletModel;
        tncTransferViewController.tokenModel = self.tokenModel;
        [self.navigationController pushViewController:tncTransferViewController animated:YES];
    }
}

#pragma mark ------ Private Methods ------
- (void)timerDown {
    if (self.isNeedInvalidateTimer) {
        [self removeTimer];
    } else {
        //开始计时
        self.timer = [NSTimer scheduledTimerWithTimeInterval:[self.blockPerSecond intValue] target:self selector:@selector(countDownTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}


/**
 每隔几秒需要执行一次 获取最大块高
 */
- (void)countDownTime {
    if (self.isNeedInvalidateTimer) {
        [self removeTimer];
    } else {
        NSLog(@"countDownTime --- %@", [NSDate date]);
        //10s 请求一次接口
        if ([self isEth]) {
            [self loadMaxblockNumber];
        } else {
            [self getNeoTransferListIsLoadMore:NO];
        }
        [self getNeoBalance];
    }
}

/**
 - (void)getOrderListCache {
 NSString *asset_id;
 if ([self.flag isEqualToString:NEO]) {
 asset_id = @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b";
 } else if ([self.flag isEqualToString:GAS]) {
 asset_id = @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7";
 } else {
 asset_id = self.tokenModel.address;
 }
 NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc] init];
 [parametersDic setObject:@(self.neoWalletModel.listIdentifier) forKey:WALLET_ID];
 [parametersDic setObject:NEO forKey:FLAG];
 [parametersDic setObject:@(self.page) forKey:PAGE];
 [parametersDic setObject:asset_id forKey:ASSET_ID];
 if (![NSString isNulllWithObject:[PPNetworkCache getResponseCacheForKey:[NSString stringWithFormat:@"%@/%@", @"wallet-order", [NSString dataTOjsonString:parametersDic]]]]) {
 NSDictionary *responseCache = [PPNetworkCache getResponseCacheForKey:[NSString stringWithFormat:@"%@/%@", @"wallet-order", [NSString dataTOjsonString:parametersDic]]];
 if (1) { //self.model.category_id == 2
 if (![NSString isNulllWithObject:[responseCache objectForKey:LIST]]) {
 [self.dataSource removeAllObjects];
 
 for (NSDictionary * dic in [responseCache objectForKey:LIST]) {
 DBHTransferListModelList *model = [DBHTransferListModelList modelObjectWithDictionary:dic];
 
 if ([self.tokenModel.flag isEqualToString:@"TNC"]  ||
 [self.tokenModel.flag isEqualToString:@"APH"] ||
 [self.tokenModel.flag isEqualToString:@"DBC"] ||
 [self.tokenModel.flag isEqualToString:@"ZPT"] ||
 [self.tokenModel.flag isEqualToString:@"RHT"] ||
 [self.tokenModel.flag isEqualToString:@"BCS"] ||
 [self.tokenModel.flag isEqualToString:@"TKY"] ||
 [self.tokenModel.flag isEqualToString:@"CPX"] ||
 [self.tokenModel.flag isEqualToString:@"NRV"] ||
 [self.tokenModel.flag isEqualToString:@"CGE"] ||
 [self.tokenModel.flag isEqualToString:@"IAM"] ||
 [self.tokenModel.flag isEqualToString:@"ACAT"] ||
 [self.tokenModel.flag isEqualToString:@"NRVE"] ||
 [self.tokenModel.flag isEqualToString:@"CPX"] ||
 [self.tokenModel.flag isEqualToString:@"QLC"] ||
 [self.tokenModel.flag isEqualToString:@"ONT"] ||
 [self.tokenModel.flag isEqualToString:@"CPX"]) {
 model.value = [NSString DecimalFuncWithOperatorType:3 first:model.value secend:[NSString stringWithFormat:@"%lf", pow(10, self.tokenModel.decimals.doubleValue)] value:8];
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
 if (![NSString isNulllWithObject:[responseCache objectForKey:LIST]])
 {
 [self.dataSource removeAllObjects];
 
 for (NSDictionary * dic in [responseCache objectForKey:LIST])
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
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataFromServer];
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
    
    if ([_tokenModel.flag isEqualToString:NEO]) {
        self.headerView.balance = _tokenModel.balance;
    } else {
        self.headerView.balance = [NSString stringWithFormat:@"%.4lf", _tokenModel.balance.doubleValue];
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
        _transferButton.backgroundColor = MAIN_ORANGE_COLOR;
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
