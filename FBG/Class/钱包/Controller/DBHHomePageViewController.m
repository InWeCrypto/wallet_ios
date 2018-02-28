//
//  DBHHomePageViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHHomePageViewController.h"

#import "PPNetworkCache.h"

#import "DBHWalletManagerViewController.h"
//#import "DBHMyViewController.h"
#import "DBHWalletDetailViewController.h"
#import "DBHWalletDetailWithETHViewController.h"

#import "DBHWalletLookPromptView.h"
#import "DBHHomePageHeaderView.h"
#import "DBHHomePageView.h"
#import "DBHHomePageTableViewCell.h"

#import "DBHWalletManagerForNeoDataModels.h"
#import "DBHWalletDetailTokenInfomationDataModels.h"

static NSString *const kDBHHomePageTableViewCellIdentifier = @"kDBHHomePageTableViewCellIdentifier";

@interface DBHHomePageViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) DBHHomePageHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHHomePageView *homePageView;
@property (nonatomic, strong) DBHWalletLookPromptView *walletLookPromptView;

@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *neoModel;
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *gasModel;
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *ethModel;
@property (nonatomic, strong) NSMutableArray *walletListArray; // 钱包列表
@property (nonatomic, strong) NSMutableArray *neoWalletListArray; // NEO钱包列表
@property (nonatomic, strong) NSMutableArray *ethWalletListArray; // ETH钱包列表
@property (nonatomic, strong) NSMutableArray *cacheneoWalletListArray; // 缓存钱包列表
@property (nonatomic, strong) NSMutableArray *dataSource; // 代币列表

@end

@implementation DBHHomePageViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUI];
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self getWalletList];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.homePageView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.bottom.equalTo(weakSelf.view);
    }];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(385));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(0);
    }];
    [self.homePageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(77) + STATUSBARHEIGHT);
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(0);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHHomePageTableViewCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHWalletDetailTokenInfomationModelData *model = self.dataSource[indexPath.row];
    
    self.walletLookPromptView.tokenName = model.name;
    self.walletLookPromptView.dataSource = [model.flag isEqualToString:@"NEO"] || [model.flag isEqualToString:@"Gas"] || [model.flag isEqualToString:@"TNC"] ? [self.neoWalletListArray mutableCopy] : [self.ethWalletListArray mutableCopy];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.walletLookPromptView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.walletLookPromptView animationShow];
    });
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
    CGFloat velocity = [pan velocityInView:scrollView].y;
    
    WEAKSELF
    if (velocity <- 5) {
        //向上拖动，隐藏导航栏
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.view);
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.homePageView.mas_bottom);
            make.bottom.equalTo(weakSelf.view);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.homePageView.hidden = NO;
            weakSelf.headerView.hidden = YES;
            [weakSelf.view layoutIfNeeded];
        }];
    }else if (velocity > 5) {
        //向下拖动，显示导航栏
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.view);
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.headerView.mas_bottom);
            make.bottom.equalTo(weakSelf.view);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.homePageView.hidden = YES;
            weakSelf.headerView.hidden = NO;
            [weakSelf.view layoutIfNeeded];
        }];
    }else if(velocity == 0){
        //停止拖拽
    }
}

#pragma mark ------ Data ------
/**
 获取钱包列表
 */
- (void)getWalletList {
    WEAKSELF
    [PPNetworkHelper GET:@"wallet" baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
        [weakSelf.walletListArray removeAllObjects];
        for (NSDictionary *dic in responseCache[@"list"]) {
            DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList modelObjectWithDictionary:dic];
            
            model.isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:model.address]];
            model.isBackUpMnemonnic = [[UserSignData share].user.walletIdsArray containsObject:@(model.listIdentifier)];
            [weakSelf.walletListArray addObject:model];
        }
        
        [weakSelf dataStatistics];
    } success:^(id responseObject) {
        [weakSelf endRefresh];
        
        [weakSelf.cacheneoWalletListArray removeAllObjects];
        for (NSDictionary *dic in responseObject[@"list"]) {
            DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList modelObjectWithDictionary:dic];
            
            model.isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:model.address]];
            model.isBackUpMnemonnic = [[UserSignData share].user.walletIdsArray containsObject:@(model.listIdentifier)];
            [weakSelf.cacheneoWalletListArray addObject:model];
        }
        
        [weakSelf getTokenData];
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure: error];
    }];
}
/**
 获取代币数据
 */
- (void)getTokenData {
    NSMutableArray *walletIdArray = [NSMutableArray array];
    for (DBHWalletManagerForNeoModelList *model in self.walletListArray) {
        [walletIdArray addObject:@(model.listIdentifier)];
    }
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:[walletIdArray toJSONStringForArray] forKey:@"wallet_ids"];
    
    WEAKSELF
    [PPNetworkHelper GET:@"conversion" baseUrlType:1 parameters:parametersDic hudString:nil responseCache:^(id responseCache)
     {
         NSArray *dataArray = responseCache[@"list"];
         if (dataArray.count > 0)
         {
             for (NSDictionary *dic in dataArray) {
                 
                 NSString *category_id = dic[@"category_id"];
                 if (category_id.integerValue == 1) {
                     // ETH
                     NSString *price_cny = dic[@"category"][@"cap"][@"price_cny"];
                     NSString *price_usd = dic[@"category"][@"cap"][@"price_usd"];
                     NSString * price_ether;
                     if (![NSString isNulllWithObject:[dic objectForKey:@"balance"]])
                     {
                         price_ether = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[dic objectForKey:@"balance"] substringFromIndex:2]] secend:@"1000000000000000000" value:4];
                     }
                     else
                     {
                         price_ether = [NSString DecimalFuncWithOperatorType:3 first:@"0" secend:@"1000000000000000000" value:4];
                     }
                     weakSelf.ethModel.balance = [NSString DecimalFuncWithOperatorType:0 first:weakSelf.ethModel.balance secend:price_ether value:4];
                     weakSelf.ethModel.priceCny = [NSString DecimalFuncWithOperatorType:2 first:price_ether secend:price_cny value:2];
                     weakSelf.ethModel.priceUsd = [NSString DecimalFuncWithOperatorType:2 first:price_ether secend:price_usd value:2];
                     
                     // 代币数量统计
                     for (DBHWalletManagerForNeoModelList *model in weakSelf.walletListArray) {
                         NSString *walletId = dic[@"id"];
                         if (model.listIdentifier == walletId.integerValue) {
                             [model.tokenStatistics setObject:price_ether forKey:@"ETH"];
                         }
                     }
                     for (DBHWalletManagerForNeoModelList *model in weakSelf.cacheneoWalletListArray) {
                         NSString *walletId = dic[@"id"];
                         if (model.listIdentifier == walletId.integerValue) {
                             [model.tokenStatistics setObject:price_ether forKey:@"ETH"];
                         }
                     }
                 }
             }
         }
         
         [weakSelf dataStatistics];
     } success:^(id responseObject)
     {
         weakSelf.ethModel.balance = @"0";
         NSArray *dataArray = responseObject[@"list"];
         if (dataArray.count > 0)
         {
             for (NSDictionary *dic in dataArray) {
                 
                 NSString *category_id = dic[@"category_id"];
                 if (category_id.integerValue == 1) {
                     // ETH
                     NSString *price_cny = dic[@"category"][@"cap"][@"price_cny"];
                     NSString *price_usd = dic[@"category"][@"cap"][@"price_usd"];
                     NSString * price_ether;
                     if (![NSString isNulllWithObject:[dic objectForKey:@"balance"]])
                     {
                         price_ether = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[dic objectForKey:@"balance"] substringFromIndex:2]] secend:@"1000000000000000000" value:4];
                     }
                     else
                     {
                         price_ether = [NSString DecimalFuncWithOperatorType:3 first:@"0" secend:@"1000000000000000000" value:4];
                     }
                     weakSelf.ethModel.balance = [NSString DecimalFuncWithOperatorType:0 first:weakSelf.ethModel.balance secend:price_ether value:4];
                     weakSelf.ethModel.priceCny = [NSString DecimalFuncWithOperatorType:2 first:price_ether secend:price_cny value:2];
                     weakSelf.ethModel.priceUsd = [NSString DecimalFuncWithOperatorType:2 first:price_ether secend:price_usd value:2];
                     
                     // 代币数量统计
                     for (DBHWalletManagerForNeoModelList *model in weakSelf.walletListArray) {
                         NSString *walletId = dic[@"id"];
                         if (model.listIdentifier == walletId.integerValue) {
                             [model.tokenStatistics setObject:price_ether forKey:@"ETH"];
                         }
                     }
                     for (DBHWalletManagerForNeoModelList *model in weakSelf.cacheneoWalletListArray) {
                         NSString *walletId = dic[@"id"];
                         if (model.listIdentifier == walletId.integerValue) {
                             [model.tokenStatistics setObject:price_ether forKey:@"ETH"];
                         }
                     }
                 }
            }
         }
         
         [weakSelf dataStatistics];
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t queue=dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    //获取代币余额列表
    for (DBHWalletManagerForNeoModelList *model in self.walletListArray)
    {
        dispatch_group_async(group, queue, ^
                             {
                                 //获取代币余额列表
                                 [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%ld", (NSInteger)model.listIdentifier] baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache)
                                  {
                                  } success:^(id responseObject)
                                  {
                                     
                                      dispatch_semaphore_signal(semaphore);
                                  } failure:^(NSString *error)
                                  {
                                      dispatch_semaphore_signal(semaphore);
                                  }];
                                 dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                             });
    }
    
    dispatch_group_notify(group, queue, ^{
        //所有请求返回数据后执行
        weakSelf.walletListArray = [weakSelf.cacheneoWalletListArray mutableCopy];
        [weakSelf dataStatistics];
    });
}

#pragma mark ------ Private Methods ------
/**
 数据统计
 */
- (void)dataStatistics {
    self.neoModel.balance = @"0";
    self.neoModel.priceCny = @"0";
    self.neoModel.priceUsd = @"0";
    self.gasModel.balance = @"0";
    self.gasModel.priceCny = @"0";
    self.gasModel.priceUsd = @"0";
    
    [self.dataSource removeObjectsInRange:NSMakeRange(3, self.dataSource.count - 3)];
    
    [self.neoWalletListArray removeAllObjects];
    [self.ethWalletListArray removeAllObjects];
    NSString *sum = @"0";
    for (DBHWalletManagerForNeoModelList *walletModel in self.walletListArray)
    {
        if (walletModel.category.categoryIdentifier == 1) {
            // ETH
            [self.ethWalletListArray addObject:walletModel];
        } else {
            // NEO
            [self.neoWalletListArray addObject:walletModel];
        }
        if (![NSString isNulllWithObject:[PPNetworkCache getResponseCacheForKey:[NSString stringWithFormat:@"conversion/%ld/", (NSInteger)walletModel.listIdentifier]]]) {
            NSDictionary *responseObject = [PPNetworkCache getResponseCacheForKey:[NSString stringWithFormat:@"conversion/%ld/", (NSInteger)walletModel.listIdentifier]];
            
            if (walletModel.category.categoryIdentifier == 1) {
                // ETH
                if ([[responseObject objectForKey:@"list"] count] > 0)
                {
                    for (NSDictionary *dic in [responseObject objectForKey:@"list"])
                    {
                        NSString *price_cny = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
                        NSString *price_usd = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
                        if ([NSObject isNulllWithObject:dic[@"gnt_category"][@"cap"]]) {
                            price_cny = @"0";
                            price_usd = @"0";
                        }
                        NSInteger index = [self foundNeoModelWithArray:[self.dataSource copy] name:dic[@"name"]];
                        if (index >= 0) {
                            // 找到
                            DBHWalletDetailTokenInfomationModelData *model = self.dataSource[index];
                            if (![NSString isNulllWithObject:[dic objectForKey:@"balance"]])
                            {
                                NSString *balance = [dic objectForKey:@"balance"];
                                NSString *ether = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[balance substringFromIndex:2]] secend:@"1000000000000000000" value:4];
                                model.balance = [NSString DecimalFuncWithOperatorType:0 first:model.balance secend:ether value:4];
                                model.priceCny = [NSString DecimalFuncWithOperatorType:0 first:model.priceCny secend:[NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_cny value:2] value:2];
                                model.priceUsd = [NSString DecimalFuncWithOperatorType:0 first:model.priceUsd secend:[NSString DecimalFuncWithOperatorType:2 first:model.balance secend:price_usd value:2] value:2];
                                
                                NSString *price = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:[UserSignData share].user.walletUnitType == 1 ? model.priceCny : model.priceUsd value:5];
                                sum = [NSString DecimalFuncWithOperatorType:0 first:sum secend:price value:5];
                                // 代币数量统计
                                [walletModel.tokenStatistics setObject:model.balance forKey:model.name];
                            }
                            
                            [self.dataSource replaceObjectAtIndex:index withObject:model];
                        } else {
                            // 没找到
                            DBHWalletDetailTokenInfomationModelData *model = [[DBHWalletDetailTokenInfomationModelData alloc] init];
                            model.address = dic[@"gnt_category"][@"address"];
                            model.name = dic[@"gnt_category"][@"name"];
                            model.icon = dic[@"gnt_category"][@"icon"];
                            
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
                            
                            // 代币数量统计
                            [walletModel.tokenStatistics setObject:model.balance forKey:model.name];
                            [self.dataSource addObject:model];
                        }
                    }
                }
            } else {
                // NEO
                NSDictionary *record = responseObject[@"record"];
                
                NSString *neoNumber = [NSString stringWithFormat:@"%@", record[@"balance"]];
                NSString *neoPriceForCny = record[@"cap"][@"price_cny"];
                NSString *neoPriceForUsd = record[@"cap"][@"price_usd"];
                self.neoModel.balance = [NSString stringWithFormat:@"%.4lf", self.neoModel.balance.floatValue + neoNumber.floatValue];
                self.neoModel.priceCny = neoPriceForCny;
                self.neoModel.priceUsd = neoPriceForUsd;
                
                NSArray *gny = record[@"gnt"];
                NSDictionary *gas = gny.firstObject;
                NSString *gasPriceForCny = gas[@"cap"][@"price_cny"];
                NSString *gasPriceForUsd = gas[@"cap"][@"price_usd"];
                NSString *gasNumber = [NSString stringWithFormat:@"%@", gas[@"balance"]];
                self.gasModel.balance = [NSString stringWithFormat:@"%.8lf", self.gasModel.balance.floatValue + gasNumber.floatValue];
                self.gasModel.priceCny = gasPriceForCny;
                self.gasModel.priceUsd = gasPriceForUsd;
                self.gasModel.flag = @"Gas";
                
                // 代币数量统计
                [walletModel.tokenStatistics setObject:neoNumber forKey:self.neoModel.name];
                [walletModel.tokenStatistics setObject:gasNumber forKey:self.gasModel.name];
                
                for (NSDictionary * dic in [responseObject objectForKey:@"list"])
                {
                    NSString *price_cny = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
                    NSString *price_usd = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
                    if ([NSObject isNulllWithObject:dic[@"gnt_category"][@"cap"]]) {
                        price_cny = @"0";
                        price_usd = @"0";
                    }
                    NSInteger index = [self foundNeoModelWithArray:[self.dataSource copy] name:dic[@"name"]];
                    if (index >= 0) {
                        // 找到
                        DBHWalletDetailTokenInfomationModelData *tokenModel = self.dataSource[index];
                        NSString *balance = @"0";
                        if (![NSString isNulllWithObject:[dic objectForKey:@"balance"]])
                        {
                            NSData *data = [self convertHexStrToData:dic[@"balance"]];
                            NSString *decimals = dic[@"decimals"];
                            tokenModel.decimals = decimals;
                            balance = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals.doubleValue)];
                            tokenModel.balance = [NSString stringWithFormat:@"%lf", tokenModel.balance.floatValue + balance.floatValue];
                        }
                        [self.dataSource replaceObjectAtIndex:index withObject:tokenModel];
                        
                        // 代币数量统计
                        [walletModel.tokenStatistics setObject:balance forKey:tokenModel.name];
                    } else {
                        // 没找到
                        DBHWalletDetailTokenInfomationModelData *tokenModel = [[DBHWalletDetailTokenInfomationModelData alloc] initWithDictionary:dic];
                        tokenModel.flag = tokenModel.name;
                        tokenModel.icon = [[dic objectForKey:@"gnt_category"] objectForKey:@"icon"];
                        if (![NSString isNulllWithObject:[dic objectForKey:@"balance"]]) {
                            NSData *data = [self convertHexStrToData:dic[@"balance"]];
                            NSString *decimals = dic[@"decimals"];
                            tokenModel.decimals = decimals;
                            tokenModel.balance = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals.doubleValue)];
                        }
                        else {
                            tokenModel.balance = @"0";
                        }
                        if ([NSObject isNulllWithObject:dic[@"gnt_category"][@"cap"]]) {
                            price_cny = @"0";
                            price_usd = @"0";
                        }
                        tokenModel.priceCny = price_cny;
                        tokenModel.priceUsd = price_usd;
                        
                        [self.dataSource addObject:tokenModel];
                        
                        // 代币数量统计
                        [walletModel.tokenStatistics setObject:tokenModel.balance forKey:tokenModel.name];
                    }
                }
            }
        }
    }
    
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *neoPrice = [NSString DecimalFuncWithOperatorType:2 first:weakSelf.neoModel.balance secend:[UserSignData share].user.walletUnitType == 1 ? weakSelf.neoModel.priceCny : weakSelf.neoModel.priceUsd value:2];
        NSString *gasPrice = [NSString DecimalFuncWithOperatorType:2 first:weakSelf.gasModel.balance secend:[UserSignData share].user.walletUnitType == 1 ? weakSelf.gasModel.priceCny : weakSelf.gasModel.priceUsd value:2];
        NSString *ethPrice = @"0";
        if (weakSelf.ethModel) {
            ethPrice = [UserSignData share].user.walletUnitType == 1 ? weakSelf.ethModel.priceCny : weakSelf.ethModel.priceUsd;
        }
        weakSelf.homePageView.totalAsset = [NSString stringWithFormat:@"%@ %@", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", [NSString DecimalFuncWithOperatorType:0 first:ethPrice secend:[NSString DecimalFuncWithOperatorType:0 first:neoPrice secend:gasPrice value:2] value:2]];
        weakSelf.headerView.totalAsset = [NSString stringWithFormat:@"%@ %@", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", [NSString DecimalFuncWithOperatorType:0 first:ethPrice secend:[NSString DecimalFuncWithOperatorType:0 first:neoPrice secend:gasPrice value:2] value:2]];
        [weakSelf.tableView reloadData];
    });
}
/**
 从数组中查找name
 
 @param array 数组
 @param name name
 */
- (NSInteger)foundNeoModelWithArray:(NSArray *)array name:(NSString *)name {
    for (NSInteger i = 0; i < array.count; i++) {
        DBHWalletDetailTokenInfomationModelData *model = array[i];
        
        if ([model.name isEqualToString:name]) {
            return i;
        }
    }
    
    return -1;
}
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
- (DBHHomePageHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DBHHomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(385))];
        
        WEAKSELF
        [_headerView clickButtonBlock:^(NSInteger type) {
            switch (type) {
                case 0: {
                    // 资讯
                    
                    break;
                }
                case 1: {
                    // 个人中心
//                    DBHMyViewController *myViewController = [[DBHMyViewController alloc] init];
//                    [weakSelf.navigationController pushViewController:myViewController animated:YES];
                    
                    break;
                }
                case 2: {
                    // 资产
                    DBHWalletManagerViewController *walletManagerViewController = [[DBHWalletManagerViewController alloc] init];
                    [weakSelf.navigationController pushViewController:walletManagerViewController animated:YES];
                    
                    break;
                }
                case 3: {
                    [weakSelf.homePageView refreshAsset];
                    break;
                }
                    
                default: {
                    
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
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(60);
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.sectionHeaderHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHHomePageTableViewCell class] forCellReuseIdentifier:kDBHHomePageTableViewCellIdentifier];
    }
    return _tableView;
}
- (DBHHomePageView *)homePageView {
    if (!_homePageView) {
        _homePageView = [[DBHHomePageView alloc] init];
        _homePageView.hidden = YES;
        
        WEAKSELF
        [_homePageView clickButtonBlock:^(NSInteger type) {
            switch (type) {
                case 0: {
                    // 资讯
                    
                    break;
                }
                case 1: {
                    // 个人中心
//                    DBHMyViewController *myViewController = [[DBHMyViewController alloc] init];
//                    [weakSelf.navigationController pushViewController:myViewController animated:YES];
                    
                    break;
                }
                case 2: {
                    // 资产
                    DBHWalletManagerViewController *walletManagerViewController = [[DBHWalletManagerViewController alloc] init];
                    [weakSelf.navigationController pushViewController:walletManagerViewController animated:YES];
                    
                    break;
                }
                case 3: {
                    [weakSelf.headerView refreshAsset];
                    break;
                }
                    
                default: {
                    
                    break;
                }
            }
        }];
    }
    return _homePageView;
}
- (DBHWalletLookPromptView *)walletLookPromptView {
    if (!_walletLookPromptView) {
        _walletLookPromptView = [[DBHWalletLookPromptView alloc] init];
        
        WEAKSELF
        [_walletLookPromptView selectedBlock:^(DBHWalletManagerForNeoModelList *model) {
            // 钱包详情
            if (model.category.categoryIdentifier == 1) {
                // ETH
                DBHWalletDetailWithETHViewController *walletDetailWithETHViewController = [[DBHWalletDetailWithETHViewController alloc] init];
                walletDetailWithETHViewController.ethWalletModel = model;
                [weakSelf.navigationController pushViewController:walletDetailWithETHViewController animated:YES];
            } else {
                // NEO
                DBHWalletDetailViewController *walletDetailViewController = [[DBHWalletDetailViewController alloc] init];
                walletDetailViewController.neoWalletModel = model;
                [weakSelf.navigationController pushViewController:walletDetailViewController animated:YES];
            }
        }];
    }
    return _walletLookPromptView;
}

- (DBHWalletDetailTokenInfomationModelData *)neoModel {
    if (!_neoModel) {
        _neoModel = [[DBHWalletDetailTokenInfomationModelData alloc] init];
        _neoModel.name = @"NEO";
        _neoModel.icon = @"NEO_add";
        _neoModel.balance = @"0";
        _neoModel.priceCny = @"0";
        _neoModel.priceUsd = @"0";
        _neoModel.flag = @"NEO";
    }
    return _neoModel;
}
- (DBHWalletDetailTokenInfomationModelData *)gasModel {
    if (!_gasModel) {
        _gasModel = [[DBHWalletDetailTokenInfomationModelData alloc] init];
        _gasModel.name = @"Gas";
        _gasModel.icon = @"NEO_add";//@"NEO_project_icon_Gas";
        _gasModel.balance = @"0";
        _gasModel.priceCny = @"0";
        _gasModel.priceUsd = @"0";
        _gasModel.flag = @"Gas";
    }
    return _gasModel;
}
- (DBHWalletDetailTokenInfomationModelData *)ethModel {
    if (!_ethModel) {
        _ethModel = [[DBHWalletDetailTokenInfomationModelData alloc] init];
        _ethModel.name = @"ETH";
        _ethModel.icon = @"ETH_add";
        _ethModel.balance = @"0";
        _ethModel.priceCny = @"0";
        _ethModel.priceUsd = @"0";
        _ethModel.flag = @"ETH";
    }
    return _ethModel;
}
- (NSMutableArray *)cacheneoWalletListArray {
    if (!_cacheneoWalletListArray) {
        _cacheneoWalletListArray = [NSMutableArray array];
    }
    return _cacheneoWalletListArray;
}
- (NSMutableArray *)walletListArray {
    if (!_walletListArray) {
        _walletListArray = [NSMutableArray array];
    }
    return _walletListArray;
}
- (NSMutableArray *)neoWalletListArray {
    if (!_neoWalletListArray) {
        _neoWalletListArray = [NSMutableArray array];
    }
    return _neoWalletListArray;
}
- (NSMutableArray *)ethWalletListArray {
    if (!_ethWalletListArray) {
        _ethWalletListArray = [NSMutableArray array];
    }
    return _ethWalletListArray;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        [_dataSource addObject:self.neoModel];
        [_dataSource addObject:self.gasModel];
        [_dataSource addObject:self.ethModel];
    }
    return _dataSource;
}

@end
