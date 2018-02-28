//
//  DBHExtractGasViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHExtractGasViewController.h"

#import "DBHInputPasswordPromptView.h"
#import "DBHExtractGasTableViewCell.h"

#import "DBHWalletDetailTokenInfomationModelData.h"

static NSString *const kDBHExtractGasTableViewCellIdentifier = @"kDBHExtractTableViewCellIdentifier";

@interface DBHExtractGasViewController ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;

@property (nonatomic, assign) NSInteger type; // 1:解冻 2:提取

@end

@implementation DBHExtractGasViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Claim", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
    [self addRefresh];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.sureButton];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.sureButton.mas_top);
    }];
    [self.sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(88));
        make.height.offset(AUTOLAYOUTSIZE(42));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(36.5));
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHExtractGasTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHExtractGasTableViewCellIdentifier forIndexPath:indexPath];
    cell.gasTokenModel = self.gasTokenModel;
    
    WEAKSELF
    [cell unfreezeBlock:^{
        [weakSelf respondsToUnfreezeButton];
    }];
    
    return cell;
}

#pragma mark ------ Data ------
- (void)getData {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%@", self.wallectId] baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject)
     {
         [weakSelf endRefresh];
         NSDictionary *record = responseObject[@"record"];
         NSString *neoNumber = [NSString stringWithFormat:@"%@", record[@"balance"]];
         NSString *neoPriceForCny = record[@"cap"][@"price_cny"];
         NSString *neoPriceForUsd = record[@"cap"][@"price_usd"];
         weakSelf.neoTokenModel.address = record[@"address"];
         weakSelf.neoTokenModel.name = @"NEO";
         weakSelf.neoTokenModel.icon = @"NEO_add";
         weakSelf.neoTokenModel.balance = neoNumber;
         weakSelf.neoTokenModel.priceCny = neoPriceForCny;
         weakSelf.neoTokenModel.priceUsd = neoPriceForUsd;
         weakSelf.neoTokenModel.flag = @"NEO";

         NSArray *gny = record[@"gnt"];
         NSDictionary *gas = gny.firstObject;
         NSString *gasPriceForCny = gas[@"cap"][@"price_cny"];
         NSString *gasPriceForUsd = gas[@"cap"][@"price_usd"];
         weakSelf.gasTokenModel.name = @"可提现Gas";
         weakSelf.gasTokenModel.icon = @"NEO_project_icon_Gas";
         weakSelf.gasTokenModel.balance = gas[@"available"];
         weakSelf.gasTokenModel.noExtractbalance = gas[@"unavailable"];
         weakSelf.gasTokenModel.priceCny = gasPriceForCny;
         weakSelf.gasTokenModel.priceUsd = gasPriceForUsd;
         weakSelf.gasTokenModel.dataIdentifier = gas[@"cap"][@"id"];

         [weakSelf.tableView reloadData];
     }failure:^(NSString *error)
     {
         [weakSelf endRefresh];
         [LCProgressHUD showFailure:error];
     }];
}
// 上传后台提交NEO订单
- (void)creatNeoOrderWithData:(NSString *)data trade_no:(NSString *)trade_no
{
    //创建钱包订单
    NSString *assert = self.type == 1 ? @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b" : @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7";
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:/*self.wallectId*/@(0) forKey:@"wallet_id"];
    [dic setObject:data forKey:@"data"];
    [dic setObject:self.gasTokenModel.address forKey:@"pay_address"];
    [dic setObject:self.gasTokenModel.address forKey:@"receive_address"];
    [dic setObject:@"" forKey:@"remark"];
    [dic setObject:self.type == 1 ? self.neoTokenModel.balance : self.gasTokenModel.canExtractbalance forKey:@"fee"];
    [dic setObject:@"0" forKey:@"handle_fee"];
    [dic setObject:@"NEO" forKey:@"flag"];
    [dic setObject:[NSString stringWithFormat:@"0x%@", trade_no] forKey:@"trade_no"];
    [dic setObject:assert forKey:@"asset_id"];

    [PPNetworkHelper POST:@"wallet-order" baseUrlType:1 parameters:dic hudString:self.type == 1 ? @"gas解冻中，请耐心等待" : @"创建中..." success:^(id responseObject)
     {
         [LCProgressHUD showMessage:@"订单创建成功"];
         [self.navigationController popViewControllerAnimated:YES];

     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:self.type == 1 ? @"解冻失败" : @"提取失败"];
     }];
}

#pragma mark ------ Event Responds ------
/**
 解冻
 */
- (void)respondsToUnfreezeButton {
    if (self.gasTokenModel.noExtractbalance.floatValue <= 0) {
        [LCProgressHUD showFailure:@"暂未可解冻的Gas"];

        return;
    }
    if (self.neoTokenModel.balance.floatValue <= 0) {
        [LCProgressHUD showFailure:@"NEO数量不够 解冻失败"];

        return;
    }

    self.type = 1;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordPromptView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.inputPasswordPromptView animationShow];
    });
}
/**
 确定
 */
- (void)respondsToSureButton {
    if (self.gasTokenModel.canExtractbalance.floatValue <= 0) {
        [LCProgressHUD showFailure:@"暂未可提取的Gas"];

        return;
    }

    self.type = 2;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordPromptView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.inputPasswordPromptView animationShow];
    });
}

#pragma mark ------ Private Methods ------
/**
 NEO转账
 */
- (void)transferAccountsForNEOWithPassword:(NSString *)password unspent:(NSString *)unspent {
    id data = [PDKeyChain load:self.gasTokenModel.address];
    // NEO钱包转账
    //子线程异步执行下载任务，防止主线程卡顿
    NSError * error;
    NeomobileWallet *Wallet = NeomobileFromKeyStore(data, password, &error);

    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //异步返回主线程，根据获取的数据，更新UI
    dispatch_async(mainQueue, ^
                   {
                       if (!error)
                       {
                           //热钱包代币转账
                           //生成data
                           NSError * error;
                           NeomobileTx *tx;
                           if (self.type == 1) {
                               // 解冻
                               tx = [Wallet createAssertTx:@"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b" from:self.neoTokenModel.address to:self.neoTokenModel.address amount:self.neoTokenModel.balance.doubleValue unspent:unspent error:&error];
                           } else {
                               // 提取
                               tx = [Wallet createClaimTx:self.gasTokenModel.canExtractbalance.doubleValue address:self.gasTokenModel.address unspent:unspent error:&error];
                           }

                           dispatch_queue_t mainQueue = dispatch_get_main_queue();
                           //异步返回主线程，根据获取的数据，更新UI
                           dispatch_async(mainQueue, ^
                                          {
                                              if (!error)
                                              {
                                                  [LCProgressHUD hide];
                                                  [LCProgressHUD showMessage:self.type == 1 ? @"解冻成功" : @"提取成功"];

                                                  //热钱包生成订单
                                                  [self creatNeoOrderWithData:tx.data trade_no:tx.id_];
                                              }
                                              else
                                              {
                                                  [LCProgressHUD hide];
                                                  [LCProgressHUD showMessage:self.type == 1 ? @"解冻失败，请稍后重试" : @"提取失败，请稍后重试"];
                                              }
                                          });
                       }
                       else
                       {
                           [LCProgressHUD hide];
                           [LCProgressHUD showMessage:@"密码错误，请稍后重试"];
                       }
                   });
}
/**
 添加下拉刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
}
/**
 结束下拉刷新
 */
- (void)endRefresh {
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = AUTOLAYOUTSIZE(300);
        
        _tableView.dataSource = self;
        
        [_tableView registerClass:[DBHExtractGasTableViewCell class] forCellReuseIdentifier:kDBHExtractGasTableViewCellIdentifier];
    }
    return _tableView;
}
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = COLORFROM16(0xFF841C, 1);
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        [_sureButton setTitle:DBHGetStringWithKeyFromTable(@"Claim", nil) forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(respondsToSureButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
- (DBHInputPasswordPromptView *)inputPasswordPromptView {
    if (!_inputPasswordPromptView) {
        _inputPasswordPromptView = [[DBHInputPasswordPromptView alloc] init];
        
        WEAKSELF
        [_inputPasswordPromptView commitBlock:^(NSString *password) {
            [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(weakSelf.type == 1 ? @"In gas extraction, Please be patient" : @"In the validation...", nil)];
            
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^
                           {
                               if (weakSelf.type == 1) {
                                   // 解冻
                                   [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoUtxo?address=%@&type=%@", weakSelf.gasTokenModel.address, @"neo-asset-id"] baseUrlType:1 parameters:nil hudString:@"" success:^(id responseObject) {
                                       NSArray *result = responseObject[@"result"];
                                       [weakSelf transferAccountsForNEOWithPassword:password unspent:[result toJSONStringForArray]];
                                   } failure:^(NSString *error) {
                                       [LCProgressHUD showFailure:error];
                                   }];
                               } else {
                                   // 提取
                                   [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoClaimUtxo?address=%@", weakSelf.gasTokenModel.address] baseUrlType:1 parameters:nil hudString:@"" success:^(id responseObject) {
                                       NSArray *result = responseObject[@"result"][@"Claims"];
                                       [weakSelf transferAccountsForNEOWithPassword:password unspent:[result toJSONStringForArray]];
                                   } failure:^(NSString *error) {
                                       [LCProgressHUD showFailure:error];
                                   }];
                               }
                           });
        }];
    }
    return _inputPasswordPromptView;
}

@end
