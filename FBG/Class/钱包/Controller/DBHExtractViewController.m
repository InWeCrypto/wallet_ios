//
//  DBHExtractViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHExtractViewController.h"

#import "DBHExtractTableViewCell.h"

#import "WalletInfoGntModel.h"

static NSString *const kDBHExtractTableViewCellIdentifier = @"kDBHExtractTableViewCellIdentifier";

@interface DBHExtractViewController ()<UITableViewDataSource, PassWordViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) PassWordView * password;

@property (nonatomic, assign) NSInteger type; // 1:解冻 2:提取

@end

@implementation DBHExtractViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Extract", nil);
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
    DBHExtractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHExtractTableViewCellIdentifier forIndexPath:indexPath];
    cell.model = self.model;
    
    WEAKSELF
    [cell unfreezeBlock:^{
        [weakSelf respondsToUnfreezeButton];
    }];
    
    return cell;
}

#pragma mark ------ PassWordViewDelegate ------
/**
 取消支付
 */
- (void)canel
{
    [self caneButtonClicked];
}
- (void)sureWithPassWord:(NSString *)passWord {
    //确认支付
    [LCProgressHUD showLoading:self.type == 1 ? @"gas提取中，请耐心等待" : @"验证中..."];
    
    WEAKSELF
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^
                   {
                       if (weakSelf.type == 1) {
                           // 解冻
                           [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoUtxo?address=%@&type=%@", self.model.address, @"neo-asset-id"] isOtherBaseUrl:NO parameters:nil hudString:@"" success:^(id responseObject) {
                               NSArray *result = responseObject[@"result"];
                               [self transferAccountsForNEOWithPassword:passWord unspent:[result toJSONStringForArray]];
                           } failure:^(NSString *error) {
                               [LCProgressHUD showFailure:error];
                           }];
                       } else {
                           // 提取
                           [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoClaimUtxo?address=%@", self.model.address] isOtherBaseUrl:NO parameters:nil hudString:@"" success:^(id responseObject) {
                               NSArray *result = responseObject[@"result"][@"Claims"];
                               [self transferAccountsForNEOWithPassword:passWord unspent:[result toJSONStringForArray]];
                           } failure:^(NSString *error) {
                               [LCProgressHUD showFailure:error];
                           }];
                       }
                   });
}

#pragma mark ------ Data ------
- (void)getData {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%@", self.wallectId] isOtherBaseUrl:NO parameters:nil hudString:nil success:^(id responseObject)
     {
         [weakSelf endRefresh];
         NSDictionary *record = responseObject[@"record"];
         NSString *neoNumber = [NSString stringWithFormat:@"%@", record[@"balance"]];
         NSString *neoPriceForCny = record[@"cap"][@"price_cny"];
         NSString *neoPriceForUsd = record[@"cap"][@"price_usd"];
         weakSelf.neoModel.address = record[@"address"];
         weakSelf.neoModel.name = @"NEO";
         weakSelf.neoModel.icon = @"NEO_add";
         weakSelf.neoModel.balance = neoNumber;
         weakSelf.neoModel.price_cny = neoPriceForCny;
         weakSelf.neoModel.price_usd = neoPriceForUsd;
         weakSelf.neoModel.flag = @"NEO";
         
         NSArray *gny = record[@"gnt"];
         NSDictionary *gas = gny.firstObject;
         NSString *gasPriceForCny = gas[@"cap"][@"price_cny"];
         NSString *gasPriceForUsd = gas[@"cap"][@"price_usd"];
         weakSelf.model.name = @"可提现Gas";
         weakSelf.model.icon = @"NEO_project_icon_Gas";
         weakSelf.model.balance = gas[@"available"];
         weakSelf.model.noExtractbalance = gas[@"unavailable"];
         weakSelf.model.price_cny = gasPriceForCny;
         weakSelf.model.price_usd = gasPriceForUsd;
         weakSelf.model.address = self.model.address;
         
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
    [dic setObject:@(self.model.id) forKey:@"wallet_id"];
    [dic setObject:data forKey:@"data"];
    [dic setObject:self.model.address forKey:@"pay_address"];
    [dic setObject:self.model.address forKey:@"receive_address"];
    [dic setObject:@"" forKey:@"remark"];
    [dic setObject:self.type == 1 ? self.neoModel.balance : self.model.balance forKey:@"fee"];
    [dic setObject:@"0" forKey:@"handle_fee"];
    [dic setObject:@"NEO" forKey:@"flag"];
    [dic setObject:[NSString stringWithFormat:@"0x%@", trade_no] forKey:@"trade_no"];
    [dic setObject:assert forKey:@"asset_id"];
    
    [PPNetworkHelper POST:@"wallet-order" parameters:dic hudString:self.type == 1 ? @"gas提取中，请耐心等待" : @"创建中..." success:^(id responseObject)
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
    if (self.model.noExtractbalance.floatValue <= 0) {
        [LCProgressHUD showFailure:@"暂未可解冻的Gas"];
        
        return;
    }
    if (self.neoModel.balance.floatValue <= 0) {
        [LCProgressHUD showFailure:@"NEO数量不够 解冻失败"];
        
        return;
    }
    
    self.type = 1;
    self.password.titleLN.text = @"请输入密码";
    self.password.infoLB.text = @"";
    [self.maskView addToWindow];
    [self.password addToWindow];
    [self.password springingAnimation];
    [self.password begainFirstResponder];
}
/**
 确定
 */
- (void)respondsToSureButton {
    if (self.model.balance.floatValue <= 0) {
        [LCProgressHUD showFailure:@"暂未可提取的Gas"];
        
        return;
    }
    
    self.type = 2;
    self.password.titleLN.text = @"请输入密码";
    self.password.infoLB.text = @"";
    [self.maskView addToWindow];
    [self.password addToWindow];
    [self.password springingAnimation];
    [self.password begainFirstResponder];
}
/**
 取消支付
 */
- (void)caneButtonClicked {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.password.alpha = 0;
    } completion:^(BOOL finished){
        [self.maskView removeFromSuperview];
        [self.password removeFromSuperview];
        self.maskView.alpha = 0.4;
        self.password.alpha = 1;
        [self.password clean];
    }];
    
}

#pragma mark ------ Private Methods ------
/**
 NEO转账
 */
- (void)transferAccountsForNEOWithPassword:(NSString *)password unspent:(NSString *)unspent {
    id data = [PDKeyChain load:self.model.address];
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
                               tx = [Wallet createAssertTx:@"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b" from:self.neoModel.address to:self.neoModel.address amount:self.neoModel.balance.doubleValue unspent:unspent error:&error];
                           } else {
                               // 提取
                               tx = [Wallet createClaimTx:self.model.balance.doubleValue address:self.model.address unspent:unspent error:&error];
                           }
                           
                           dispatch_queue_t mainQueue = dispatch_get_main_queue();
                           //异步返回主线程，根据获取的数据，更新UI
                           dispatch_async(mainQueue, ^
                                          {
                                              if (!error)
                                              {
                                                  [LCProgressHUD hide];
                                                  [self caneButtonClicked];
                                                  [LCProgressHUD showMessage:self.type == 1 ? @"解冻成功" : @"提取成功"];
                                                  
                                                  //热钱包生成订单
                                                  [self creatNeoOrderWithData:tx.data trade_no:tx.id_];
                                              }
                                              else
                                              {
                                                  [LCProgressHUD hide];
                                                  [self caneButtonClicked];
                                                  [LCProgressHUD showMessage:self.type == 1 ? @"解冻失败，请稍后重试" : @"提取失败，请稍后重试"];
                                              }
                                          });
                       }
                       else
                       {
                           [LCProgressHUD hide];
                           [self caneButtonClicked];
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
        
        [_tableView registerClass:[DBHExtractTableViewCell class] forCellReuseIdentifier:kDBHExtractTableViewCellIdentifier];
    }
    return _tableView;
}
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = COLORFROM16(0x158A1B, 1);
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(respondsToSureButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
- (UIView *)maskView
{
    if (!_maskView)
    {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.4;
        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(caneButtonClicked)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_maskView addGestureRecognizer:singleRecognizer];
    }
    return _maskView;
}
- (PassWordView *)password
{
    if (!_password)
    {
        _password = [PassWordView loadViewFromXIB];
        _password.frame = CGRectMake(0, 0, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40) * 216 / 307);
        _password.center = CGPointMake(SCREEN_WIDTH / 2, (SCREEN_HEIGHT - 216) / 2);
        _password.delegate = self;
        _password.titleLN.text = NSLocalizedString(@"Please input a password", nil);
        _password.infoLB.text = @"";
    }
    return _password;
}

@end
