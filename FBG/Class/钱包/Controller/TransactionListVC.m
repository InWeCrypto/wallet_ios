//
//  TransactionListVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "TransactionListVC.h"
#import "TransactionListHeaderView.h"
#import "TransactionListCell.h"
#import "TransferVC.h"
#import "ReceivablesVC.h"
#import "ScanVC.h"
#import "ConfirmationTransferVC.h"
#import "WalletOrderModel.h"
#import "TransactionInfoVC.h"

@interface TransactionListVC () <UITableViewDelegate, UITableViewDataSource, ScanVCDelegate>

/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) TransactionListHeaderView * headerView;
@property (nonatomic, strong) UIButton * transferButton;    //转账
@property (nonatomic, strong) UIButton * receivablesButton;    //收款

@property (nonatomic, assign) NSString * maxBlockNumber;  //最大块号 当前
@property (nonatomic, copy) NSString * blockPerSecond;  //发生时间  5
@property (nonatomic, copy) NSString * minBlockNumber;  //最小块号 确认 12

/** 计时器 */
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation TransactionListVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.coustromTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 55 - 64);
    self.coustromTableView.rowHeight = 80;
    [self addpull2RefreshWithTableView:self.coustromTableView WithIsInset:NO];
    //    [self addPush2LoadMoreWithTableView:self.coustromTableView WithIsInset:NO];
    self.coustromTableView.tableHeaderView = self.headerView;
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.blockPerSecond = @"10";
    self.minBlockNumber = @"12";
    
    [self.view addSubview:self.coustromTableView];
    [self.view addSubview:self.transferButton];
    [self.view addSubview:self.receivablesButton];
    
    if (self.tokenModel)
    {
        
        [self.headerView.headImage sdsetImageWithURL:self.tokenModel.icon placeholderImage:Default_General_Image];
        [self loadBanlaceData];
    }
    else
    {
        self.headerView.headImage.image = [UIImage imageNamed:self.model.category_name];
        self.headerView.priceLB.text = [NSString stringWithFormat:@"%.4f",[self.banlacePrice floatValue]];
        self.headerView.cnyPriceLB.text = self.cnybanlacePrice;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![UserSignData share].user.isCode)
    {
        [self loadData];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
    //别忘了删除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)timerDown
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil]; //监听是否触发home键挂起程序.
    //开始计时
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[self.blockPerSecond intValue] target:self selector:@selector(countDownTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    //    self.timer.fireDate = [NSDate distantPast];
}

- (void)countDownTime
{
    //10s 请求一次接口
    [self loadMaxblockNumber];
//    [self loadBanlaceData];
}

- (void)appHasGoneInForeground:(NSNotification *)notification
{
    //从后台唤醒
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    //切换到后台
    [self.timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - Custom Accessors (控件响应方法)

- (void)transferButtonClicked
{
    //转账
    if ([UserSignData share].user.isCode)
    {
        //冷钱包扫描
        ScanVC * vc = [[ScanVC alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if (self.tokenModel)
        {
            //代币
            TransferVC * vc = [[TransferVC alloc] init];
            vc.model = self.model;
            vc.tokenModel = self.tokenModel;
            vc.banlacePrice = _banlacePrice;
            vc.walletBanlacePrice = self.WalletbanlacePrice;
            vc.defaultGasNum = self.tokenModel.gas;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            //ETH
            TransferVC * vc = [[TransferVC alloc] init];
            vc.model = self.model;
            vc.banlacePrice = self.banlacePrice;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
}

- (void)receivablesButtonClicked
{
    //收款
    if ([UserSignData share].user.isCode)
    {
        //冷钱包
        ReceivablesVC * vc = [[ReceivablesVC alloc] init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if (self.tokenModel)
        {
            //代币
            ReceivablesVC * vc = [[ReceivablesVC alloc] init];
            vc.tokenModel = self.tokenModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            //ETH
            ReceivablesVC * vc = [[ReceivablesVC alloc] init];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)

- (void)loadBanlaceData
{
    //代币余额
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.model.address forKey:@"address"];
    [dic setObject:self.tokenModel.address forKey:@"contract"];
    
    [PPNetworkHelper POST:@"extend/balanceOf" parameters:dic hudString:@"加载中..." success:^(id responseObject)
     {
         NSString * price = [[responseObject objectForKey:@"value"] substringFromIndex:2];
         self.banlacePrice = [NSString stringWithFormat:@"%.4f",[[NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:price] secend:@"1000000000000000000" value:4] floatValue]];
         
         self.headerView.priceLB.text = [NSString stringWithFormat:@"%.4f",[self.banlacePrice floatValue]];
         if ([UserSignData share].user.walletUnitType == 1)
         {
             self.headerView.cnyPriceLB.text = [NSString stringWithFormat:@"≈￥%.2f",[[NSString DecimalFuncWithOperatorType:2 first:self.banlacePrice secend:self.tokenModel.price_cny value:2] floatValue]];
         }
         else
         {
             self.headerView.cnyPriceLB.text = [NSString stringWithFormat:@"≈$%.2f",[[NSString DecimalFuncWithOperatorType:2 first:self.banlacePrice secend:self.tokenModel.price_usd value:2] floatValue]];
         }
         
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
    
}

- (void)loadData
{
    //获取最小块高  默认12
    [PPNetworkHelper GET:@"min-block" parameters:nil hudString:@"加载中..." success:^(id responseObject)
     {
         self.minBlockNumber = [responseObject objectForKey:@"min_block_num"];
         
         //获取轮询时间 当前块发生速度  最小5秒
         [PPNetworkHelper POST:@"extend/blockPerSecond" parameters:nil hudString:nil success:^(id responseObject)
          {
              self.blockPerSecond = [NSString stringWithFormat:@"%f",1 / [[responseObject objectForKey:@"bps"] floatValue]];
              [self timerDown];
              [self loadMaxblockNumber];
              
          } failure:^(NSString *error)
          {
          }];
         
    } failure:^(NSString *error)
    {
    }];
}

- (void)loadMaxblockNumber
{
    //当前最大块号  //轮询这个
    [PPNetworkHelper POST:@"extend/blockNumber" parameters:nil hudString:nil success:^(id responseObject)
     {
         self.maxBlockNumber = [NSString stringWithFormat:@"%@",[NSString numberHexString:[responseObject objectForKey:@"value"]]];
         
         NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
         [parametersDic setObject:@(self.model.id) forKey:@"wallet_id"];
         [parametersDic setObject:self.tokenModel ? self.tokenModel.name : self.model.category_name forKey:@"flag"];
         
         //包含事务块高  列表   （当前块高-订单里的块高）/最小块高
         [PPNetworkHelper GET:@"wallet-order" parameters:parametersDic hudString:nil success:^(id responseObject)
          {
              if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]])
              {
                  [self.dataSource removeAllObjects];
                  for (NSDictionary * dic in [responseObject objectForKey:@"list"])
                  {
                      WalletOrderModel * model = [[WalletOrderModel alloc] initWithDictionary:dic];
                      model.maxBlockNumber = self.maxBlockNumber;
                      model.minBlockNumber = self.minBlockNumber;
                      if ([model.pay_address isEqualToString:self.model.address])
                      {
                          //热钱包 eth
                          //转账
                          model.isReceivables = NO;
                      }
                      else
                      {
                          //收款
                          model.isReceivables = YES;
                      }
                      [self.dataSource addObject:model];
                  }
                  [self.coustromTableView reloadData];
              }
              [self endRefreshing];
          } failure:^(NSString *error)
          {
              [self endRefreshing];
              [LCProgressHUD showFailure:error];
          }];
         
     } failure:^(NSString *error)
     {
     }];
}


#pragma mark - Deletate/DataSource (相关代理)

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //    NSLog(@" scrollViewDidScroll");
    NSLog(@"ContentOffset  x is  %f,yis %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > 180)
    {
        self.title = [NSString stringWithFormat:@"总资产(%@)",self.headerView.cnyPriceLB.text];
    }
    else
    {
        self.title = self.tokenModel ? self.tokenModel.name : self.model.category_name;
    }
}

//扫描代理
- (void)scanSucessWithObject:(id)object
{
    //扫一扫回调  获取到json 转字典传给确认转账页面
    NSDictionary * dic = [NSDictionary dictionaryWithJsonString:object];
    
    if ([self.model.address compare:[dic objectForKey:@"wallet_address"]
                            options:NSCaseInsensitiveSearch |NSNumericSearch] != NSOrderedSame)
    {
        [LCProgressHUD showMessage:@"请使用正确的钱包"];
        return;
    }
    
    ConfirmationTransferVC * vc = [[ConfirmationTransferVC alloc] init];
    vc.model = self.model;
    
    vc.totleGasPrice = [dic objectForKey:@"show_gas"];
    vc.nonce = [dic objectForKey:@"nonce"];
    vc.price = [dic objectForKey:@"show_price"];
    vc.address = [dic objectForKey:@"transfer_address"];   //代币  合约地址
    vc.remark = [dic objectForKey:@"hit"];
    vc.ox_gas = [[dic objectForKey:@"ox_gas"] lowercaseString];
    vc.ox_Price = [[dic objectForKey:@"ox_price"] lowercaseString];   //代币  data
    vc.gas_limit = [[dic objectForKey:@"gas_limit"] lowercaseString];
    if ([[dic objectForKey:@"type"] intValue] == 2)
    {
        //代币转账
        WalletInfoGntModel * model = [[WalletInfoGntModel alloc] init];
        vc.tokenModel = model;
    }
    vc.isCodeWallet = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//下拉刷新回调
- (void)pull2RefreshWithScrollerView:(UIScrollView *)scrollerView
{
    [self loadData];
}

//此外，你还可以调整内容视图的垂直对齐（即：有用的时候，有tableheaderview可见）：
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -40.0 + 150;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransactionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionListCellident"];
    cell = nil;
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"TransactionListCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //记录详情
    WalletOrderModel * model = self.dataSource[indexPath.row];
    TransactionInfoVC * vc = [[TransactionInfoVC alloc] init];
    vc.isTransfer = !model.isReceivables;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Setter/Getter

- (TransactionListHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [TransactionListHeaderView loadViewFromXIB];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 230);
    }
    return _headerView;
}

- (UIButton *)transferButton
{
    if (!_transferButton)
    {
        _transferButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _transferButton.frame = CGRectMake(0, SCREEN_HEIGHT - 64 - 55, SCREEN_WIDTH/2, 55);
        [_transferButton setTitle:@"   转账" forState: UIControlStateNormal];
        [_transferButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_transferButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _transferButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_transferButton setImage:[UIImage imageNamed:@"转账"] forState:UIControlStateNormal];
        _transferButton.backgroundColor = [UIColor colorWithHexString:@"fdd930"];
        [_transferButton addTarget:self action:@selector(transferButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferButton;
}

- (UIButton *)receivablesButton
{
    if (!_receivablesButton)
    {
        _receivablesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _receivablesButton.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 64 - 55, SCREEN_WIDTH/2, 55);
        [_receivablesButton setTitle:@"   收款" forState: UIControlStateNormal];
        [_receivablesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_receivablesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _receivablesButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_receivablesButton setImage:[UIImage imageNamed:@"收款"] forState:UIControlStateNormal];
        _receivablesButton.backgroundColor = [UIColor colorWithHexString:@"232772"];
        [_receivablesButton addTarget:self action:@selector(receivablesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receivablesButton;
}

@end
