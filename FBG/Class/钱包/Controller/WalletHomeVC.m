//
//  WalletHomeVC.m
//  FBG
//
//  Created by mac on 2017/7/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "WalletHomeVC.h"
#import "WalletHeaderView.h"
#import "WalletHomeCell.h"
#import "WalletLeiftView.h"
#import "WalletInfoVC.h"
#import "CodeWalletInfoVC.h"
#import "WalletLeiftCell.h"
#import "AddWalletChoseTypeVC.h"
#import "ScanVC.h"
#import "WalletLeftListModel.h"
#import "MessageVC.h"
#import "PPNetworkCache.h"
#import "ChoseWalletView.h"
#import "ConfirmationTransferVC.h"
#import "MJRefresh.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "CommitOrderVC.h"

@interface WalletHomeVC () <UITableViewDelegate, UITableViewDataSource, ScanVCDelegate, ChoseWalletViewDelegate, CommitOrderVCDelegate>
{
    CGFloat _LEFTWEIGHT;
}

@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) NSMutableArray * localDataSource;
@property (nonatomic, strong) NSMutableArray * lineDataSource;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) WalletHeaderView * headerView;
@property (nonatomic, strong) WalletLeiftView * leiftView;
@property (nonatomic, strong) UIView * maskView;

@property (nonatomic, strong) UITableView * leftTableView;
@property (nonatomic, strong) NSMutableArray * leftdataSource;

@property (nonatomic, strong) PassWordView * password;

@property (nonatomic, strong) ChoseWalletView * choseWalletView;
@property (nonatomic, strong) CommitOrderVC * commitOrderView;

//转账订单生产
@property (nonatomic, strong) WalletLeftListModel * walletModel;
@property (nonatomic, copy) NSString * gasPrice;   //手续费单价
@property (nonatomic, copy) NSString * totleGasPrice;       //总手续费
@property (nonatomic, copy) NSString * nonce;
@property (nonatomic, assign) int defaultGasNum;
@property (nonatomic, copy) NSString * banlacePrice;
@property (nonatomic, copy) NSString * transferAddress;

// 下拉刷新视图
@property (nonatomic) MJRefreshHeader *headRefreshView;
/** 计时器 */
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation WalletHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_info"] style:UIBarButtonItemStyleDone target:self action:@selector(messageButtonCilick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu"] style:UIBarButtonItemStyleDone target:self action:@selector(moreButtonCilick)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    _LEFTWEIGHT = ( SCREEN_WIDTH * 150 / 320);
    self.view.backgroundColor = [UIColor backgroudColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.coustromTableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.coustromTableView];
    
    self.leftdataSource = [[NSMutableArray alloc] init];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(AddWalletSucessPushWalletInfoNotification:) name:@"AddWalletSucessPushWalletInfoNotification" object:nil];
    [center addObserver:self selector:@selector(choseInterNet) name:@"netNotification" object:nil];
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.localDataSource = [[NSMutableArray alloc] init];
    self.lineDataSource = [[NSMutableArray alloc] init];
    self.defaultGasNum = 90000;
    
    [self addpull2RefreshWithTableView:self.coustromTableView WithIsInset:NO];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (![UserSignData share].user.isCode)
    {
        //加载左抽屉数据 热钱包
        self.headerView.nameLB.text = [UserSignData share].user.nickname;
        [self.headerView.headerImage sdsetImageWithHeaderimg:[UserSignData share].user.img];
        [self upAssetsLB];
        [self.lineDataSource removeAllObjects];
        [self loadLeftData];
        [self timerDown];
    }
    else
    {
        //冷钱包加载数据
        [self choseInterNet];
        
        if ([NSString isNulllWithObject:[UserSignData share].user.codeWalletsArray])
        {
            //为空
            [UserSignData share].user.codeWalletsArray = [[NSMutableArray alloc] init];
        }
        else
        {
            int i = 1;
            [self.leftdataSource removeAllObjects];
            for (NSDictionary * dic in [UserSignData share].user.codeWalletsArray)
            {
                WalletLeftListModel * model = [[WalletLeftListModel alloc] initWithDictionary:dic];
                model.img = [NSString stringWithFormat:@"钱包头像%d",i];
                if (![[UserSignData share].user.walletIdsArray containsObject:@(model.id)])
                {
                    //正常钱包 未备份
                    model.isNotBackupsWallet = YES;
                }
                [self.leftdataSource addObject:model];
                i ++;
                if (i == 10)
                {
                    i = 1;
                }
            }
        }
        [self.leftTableView reloadData];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.timer invalidate];
    self.timer = nil;
    //别忘了删除监听
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)choseInterNet
{
    CTTelephonyNetworkInfo * networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    if ([NSString isNulllWithObject:networkInfo.currentRadioAccessTechnology])
    {
        //是飞行模式
    }
    else
    {
        //不是。提出警告
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机启用飞行模式后才可以使用冷钱包" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
            [self choseInterNet];
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(countDownTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    //    self.timer.fireDate = [NSDate distantPast];
}

- (void)countDownTime
{
    //10s 请求一次接口
    [self loadLeftData];
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

- (void)upAssetsLB
{
    if ([UserSignData share].user.walletUnitType == 1)
    {
        self.headerView.priceLB.text = [NSString stringWithFormat:@"￥%@",[UserSignData share].user.totalAssets];
        self.headerView.ETH_etherLB.text = [UserSignData share].user.ETHAssets_ether;
        self.headerView.ETH_cnyLB.text = [NSString stringWithFormat:@"≈￥%@",[UserSignData share].user.ETHAssets_cny];
        self.headerView.BTC_etherLB.text = [UserSignData share].user.BTCAssets_ether;
        self.headerView.BTC_cnyLB.text = [NSString stringWithFormat:@"≈￥%@",[UserSignData share].user.BTCAssets_cny];
    }
    else
    {
        self.headerView.priceLB.text = [NSString stringWithFormat:@"$%@",[UserSignData share].user.totalAssets];
        self.headerView.ETH_etherLB.text = [UserSignData share].user.ETHAssets_ether;
        self.headerView.ETH_cnyLB.text = [NSString stringWithFormat:@"≈$%@",[UserSignData share].user.ETHAssets_cny];
        self.headerView.BTC_etherLB.text = [UserSignData share].user.BTCAssets_ether;
        self.headerView.BTC_cnyLB.text = [NSString stringWithFormat:@"≈$%@",[UserSignData share].user.BTCAssets_cny];
    }
    
}

///    添加下拉刷新
- (void)addpull2RefreshWithTableView:(UIScrollView *)tableView WithIsInset:(BOOL)isInset
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pull2RefreshWithScrollerView:)];
    self.coustromTableView.mj_header = header;
    _headRefreshView = self.coustromTableView.mj_header;
    [self.coustromTableView.mj_header endRefreshing];
    // 外观设置
    // 设置文字
    [header setTitle:@"下拉刷新..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:13];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11];
    // 设置颜色
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
}

//下拉刷新
- (void)pull2RefreshWithScrollerView:(UIScrollView *)scrollerView
{
    [self loadLeftData];
}

- (void)endRefreshing
{
    [self.coustromTableView.mj_header endRefreshing];
    [self.coustromTableView.mj_footer endRefreshing];
}

- (void)AddWalletSucessPushWalletInfoNotification:(NSNotification * )notification
{
    WalletLeftListModel * model = notification.object;
    
    
    if (![UserSignData share].user.isCode)
    {
        //热钱包
        WalletInfoVC * vc = [[WalletInfoVC alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        //冷钱包
        CodeWalletInfoVC * vc = [[CodeWalletInfoVC alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)loadLeftData
{
    //加载左抽屉数据
    [PPNetworkHelper GET:@"wallet" parameters:nil hudString:nil responseCache:^(id responseCache)
     {
         if (![NSString isNulllWithObject:[responseCache objectForKey:@"list"]])
         {
             [self.leftdataSource removeAllObjects];
             NSMutableArray * idArray = [[NSMutableArray alloc] init];
             int i = 1;
             for (NSDictionary * leftDic in [responseCache objectForKey:@"list"])
             {
                 WalletLeftListModel * model = [[WalletLeftListModel alloc] initWithDictionary:leftDic];
                 model.category_name = [[leftDic objectForKey:@"category"] objectForKey:@"name"];
                 model.img = [NSString stringWithFormat:@"钱包头像%d",i];
                 if ([NSString isNulllWithObject:[PDKeyChain load:model.address]])
                 {
                     //观察钱包
                     model.isLookWallet = YES;
                 }
                 else if (![[UserSignData share].user.walletIdsArray containsObject:@(model.id)])
                 {
                     //正常钱包 未备份
                     model.isNotBackupsWallet = YES;
                 }
                 [self.leftdataSource addObject:model];
                 [idArray addObject:@(model.id)];
                 i ++;
                 if (i == 10)
                 {
                     i = 1;
                 }
             }
             [self.leftTableView reloadData];
             //获取首页钱包数据
             if ([UserSignData share].user.isRefeshAssets)
             {
                 [self loadHomeInfoWithWalletsId:idArray];
             }
         }
    } success:^(id responseObject)
    {
        if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]])
        {
            [self.leftdataSource removeAllObjects];
            NSMutableArray * idArray = [[NSMutableArray alloc] init];
            int i = 1;
            for (NSDictionary * leftDic in [responseObject objectForKey:@"list"])
            {
                WalletLeftListModel * model = [[WalletLeftListModel alloc] initWithDictionary:leftDic];
                model.category_name = [[leftDic objectForKey:@"category"] objectForKey:@"name"];
                model.img = [NSString stringWithFormat:@"钱包头像%d",i];
                if ([NSString isNulllWithObject:[PDKeyChain load:model.address]])
                {
                    //观察钱包
                    model.isLookWallet = YES;
                }
                else if (![[UserSignData share].user.walletIdsArray containsObject:@(model.id)])
                {
                    //正常钱包 未备份
                    model.isNotBackupsWallet = YES;
                }
                [self.leftdataSource addObject:model];
                [idArray addObject:@(model.id)];
                i ++;
                if (i == 10)
                {
                    i = 1;
                }
            }
            [self.leftTableView reloadData];
            [self endRefreshing];
            //获取首页钱包数据
            if ([UserSignData share].user.isRefeshAssets)
            {
                [self loadHomeInfoWithWalletsId:idArray];
            }
        }
    } failure:^(NSString *error)
    {
        [self endRefreshing];
        [LCProgressHUD showFailure: error];
    }];
}

- (void)loadHomeInfoWithWalletsId:(NSArray *)wallets
{
    //获取首页钱包数据
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:[wallets toJSONStringForArray] forKey:@"wallet_ids"];
    
    [PPNetworkHelper GET:@"conversion" parameters:parametersDic hudString:nil responseCache:^(id responseCache)
    {
        if ([[responseCache objectForKey:@"list"] count] > 0)
        {
            NSString * assets_ether = @"0.0000";
            NSString * assets_cny = @"0.00";
            for (NSDictionary * dic in [responseCache objectForKey:@"list"])
            {
                NSString * price_ether;
                if (![NSString isNulllWithObject:[dic objectForKey:@"balance"]])
                {
                    price_ether = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[dic objectForKey:@"balance"] substringFromIndex:2]] secend:@"1000000000000000000" value:4];
                }
                else
                {
                    price_ether = [NSString DecimalFuncWithOperatorType:3 first:@"0" secend:@"1000000000000000000" value:4];
                }
                
                assets_ether = [NSString DecimalFuncWithOperatorType:0 first:assets_ether secend:price_ether value:4];
                
                if ([UserSignData share].user.walletUnitType == 1)
                {
                    NSString * price_cny = [NSString DecimalFuncWithOperatorType:2 first:price_ether secend:[[[dic objectForKey:@"category"] objectForKey:@"cap"] objectForKey:@"price_cny" ] value:2];
                    assets_cny = [NSString DecimalFuncWithOperatorType:0 first:assets_cny secend:price_cny value:2];
                }
                else
                {
                    NSString * price_cny = [NSString DecimalFuncWithOperatorType:2 first:price_ether secend:[[[dic objectForKey:@"category"] objectForKey:@"cap"] objectForKey:@"price_usd"] value:2];
                    assets_cny = [NSString DecimalFuncWithOperatorType:0 first:assets_cny secend:price_cny value:2];
                }
                
            }
            [UserSignData share].user.ETHAssets_ether = [NSString stringWithFormat:@"%.4f",[assets_ether floatValue]];
            [UserSignData share].user.ETHAssets_cny = [NSString stringWithFormat:@"%.2f",[assets_cny floatValue]];
            [UserSignData share].user.BTCAssets_ether = @"0.0000";
            [UserSignData share].user.BTCAssets_cny = @"0.00";
            [UserSignData share].user.totalAssets = [NSString stringWithFormat:@"%.2f",[assets_cny floatValue]];
//            [UserSignData share].user.isRefeshAssets = NO;
            [[UserSignData share] storageData:[UserSignData share].user];
            [self upAssetsLB];
        }
    } success:^(id responseObject)
     {
         if ([[responseObject objectForKey:@"list"] count] > 0)
         {
             NSString * assets_ether = @"0.0000";
             NSString * assets_cny = @"0.00";
             for (NSDictionary * dic in [responseObject objectForKey:@"list"])
             {
                 NSString * price_ether;
                 if (![NSString isNulllWithObject:[dic objectForKey:@"balance"]])
                 {
                     price_ether = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[dic objectForKey:@"balance"] substringFromIndex:2]] secend:@"1000000000000000000" value:4];
                 }
                 else
                 {
                     price_ether = [NSString DecimalFuncWithOperatorType:3 first:@"0" secend:@"1000000000000000000" value:4];
                 }
                 assets_ether = [NSString DecimalFuncWithOperatorType:0 first:assets_ether secend:price_ether value:4];
                 
                 if ([UserSignData share].user.walletUnitType == 1)
                 {
                     NSString * price_cny = [NSString DecimalFuncWithOperatorType:2 first:price_ether secend:[[[dic objectForKey:@"category"] objectForKey:@"cap"] objectForKey:@"price_cny" ] value:4];
                     assets_cny = [NSString DecimalFuncWithOperatorType:0 first:assets_cny secend:price_cny value:4];
                 }
                 else
                 {
                     NSString * price_cny = [NSString DecimalFuncWithOperatorType:2 first:price_ether secend:[[[dic objectForKey:@"category"] objectForKey:@"cap"] objectForKey:@"price_usd"] value:4];
                     assets_cny = [NSString DecimalFuncWithOperatorType:0 first:assets_cny secend:price_cny value:4];
                 }
                 
             }
             [UserSignData share].user.ETHAssets_ether = [NSString stringWithFormat:@"%.4f",[assets_ether floatValue]];
             [UserSignData share].user.ETHAssets_cny = [NSString stringWithFormat:@"%.2f",[assets_cny floatValue]];
             [UserSignData share].user.BTCAssets_ether = @"0.0000";
             [UserSignData share].user.BTCAssets_cny = @"0.00";
             [UserSignData share].user.totalAssets = [NSString stringWithFormat:@"%.2f",[assets_cny floatValue]];
             //            [UserSignData share].user.isRefeshAssets = NO;
             [[UserSignData share] storageData:[UserSignData share].user];
//             [self upAssetsLB];
         }
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
    
    // 后台轮询获取本地缓存
    [self.localDataSource removeAllObjects];
    for (id wallet_id in wallets)
    {
        if (![NSString isNulllWithObject:[PPNetworkCache getResponseCacheForKey:[NSString stringWithFormat:@"conversion/%@",wallet_id]]])
        {
            NSDictionary * data = [PPNetworkCache getResponseCacheForKey:[NSString stringWithFormat:@"conversion/%@",wallet_id]];
            for (NSDictionary * dic in [data objectForKey:@"list"])
            {
                WalletInfoGntModel * model = [[WalletInfoGntModel alloc] initWithDictionary:dic];
                model.icon = [[dic objectForKey:@"gnt_category"] objectForKey:@"icon"];
                model.price_cny = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
                model.price_usd = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_usd"];
                if (![NSString isNulllWithObject:[dic objectForKey:@"balance"]])
                {
                    model.balance = [dic objectForKey:@"balance"];
                }
                else
                {
                    model.balance = @"0";
                }
                
                [self.localDataSource addObject:model];
            }
        }
    }
    
    //数据统计 本地
    NSMutableArray * totleArray = [[NSMutableArray alloc] init];
    NSMutableDictionary * typedic = [[NSMutableDictionary alloc]initWithCapacity:0];
    for(WalletInfoGntModel * model in self.localDataSource)
    {
        [typedic setValue:model.name forKey:model.name];
    }
    NSArray * alltypeArray = [[NSArray alloc] initWithArray:[typedic allKeys]];
    NSString * totalAssets = [UserSignData share].user.totalAssets;
    
    for (NSString * typeName in alltypeArray)
    {
        WalletInfoGntModel * typeModel = [[WalletInfoGntModel alloc] init];
        NSString * totleBalance = @"0.0000";
        NSString * totleBalancecny = @"0.00";
        for (WalletInfoGntModel * model in self.localDataSource)
        {
            if ([model.name isEqualToString:typeName])
            {
                typeModel = model;
                NSString * ether = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[model.balance substringFromIndex:2]] secend:@"1000000000000000000" value:4];
                totleBalance = [NSString DecimalFuncWithOperatorType:0 first:totleBalance secend:ether value:4];
                
            }
        }
        
        if ([UserSignData share].user.walletUnitType == 1)
        {
            NSString * price_cny = [NSString DecimalFuncWithOperatorType:2 first:totleBalance secend:typeModel.price_cny value:4];
            totleBalancecny = [NSString DecimalFuncWithOperatorType:0 first:totleBalancecny secend:price_cny value:4];
        }
        else
        {
            NSString * price_cny = [NSString DecimalFuncWithOperatorType:2 first:totleBalance secend:typeModel.price_usd value:4];
            totleBalancecny = [NSString DecimalFuncWithOperatorType:0 first:totleBalancecny secend:price_cny value:4];
        }
        
        typeModel.balance = totleBalance;
        [totleArray addObject:typeModel];
        totalAssets = [NSString DecimalFuncWithOperatorType:0 first:totalAssets secend:totleBalancecny value:2];
    }
    [UserSignData share].user.totalAssets = [NSString stringWithFormat:@"%.2f",[totalAssets floatValue]];
    [[UserSignData share] storageData:[UserSignData share].user];
    [self upAssetsLB];
    self.dataSource = totleArray;
    [self.coustromTableView reloadData];
    
    //在线获取
    [self.lineDataSource removeAllObjects];
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t queue=dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    //获取代币余额列表
    for (id wallet_id in wallets)
    {
        dispatch_group_async(group, queue, ^
        {
            //获取代币余额列表
            [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%@",wallet_id] parameters:nil hudString:nil responseCache:^(id responseCache)
             {
             } success:^(id responseObject)
             {
                 if ([[responseObject objectForKey:@"list"] count] > 0)
                 {
                     for (NSDictionary * dic in [responseObject objectForKey:@"list"])
                     {
                         WalletInfoGntModel * model = [[WalletInfoGntModel alloc] initWithDictionary:dic];
                         model.icon = [[dic objectForKey:@"gnt_category"] objectForKey:@"icon"];
                         model.price_cny = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
                         model.price_usd = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_usd"];
                         if (![NSString isNulllWithObject:[dic objectForKey:@"balance"]])
                         {
                             model.balance = [dic objectForKey:@"balance"];
                         }
                         else
                         {
                             model.balance = @"0";
                         }
                         [self.lineDataSource addObject:model];
                     }
                 }
                 dispatch_semaphore_signal(semaphore);
             }failure:^(NSString *error)
             {
//                 [LCProgressHUD showFailure:error];
                 dispatch_semaphore_signal(semaphore);
             }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
    }
    dispatch_group_notify(group, queue, ^{
        //所有请求返回数据后执行
        //数据统计
        /*
        NSMutableArray * totleLineArray = [[NSMutableArray alloc] init];
        NSMutableDictionary * typeLinedic = [[NSMutableDictionary alloc]initWithCapacity:0];
        for(WalletInfoGntModel * model in self.lineDataSource)
        {
            [typeLinedic setValue:model.name forKey:model.name];
        }
        NSArray * alltypeLineArray = [[NSArray alloc] initWithArray:[typeLinedic allKeys]];
        
        for (NSString * typeName in alltypeLineArray)
        {
            WalletInfoGntModel * typeModel = [[WalletInfoGntModel alloc] init];
            NSString * totleBalance = @"0.00";
            
            for (WalletInfoGntModel * model in self.lineDataSource)
            {
                if ([model.name isEqualToString:typeName])
                {
                    typeModel = model;
                    NSString * ether = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[model.balance substringFromIndex:2]] secend:@"1000000000000000000"];
                    totleBalance = [NSString DecimalFuncWithOperatorType:0 first:totleBalance secend:ether];
                }
            }
            typeModel.balance = totleBalance;
            [totleLineArray addObject:typeModel];
        }
        self.dataSource = totleLineArray;
        [self.coustromTableView reloadData];
     */
    });
}

- (void)moreButtonCilick
{
    //左抽屉
    [self.maskView addToWindow];
    [self.leiftView addToWindow];
    [UIView animateWithDuration:0.5 animations:^{
        self.leiftView.frame = CGRectMake(0, 0, _LEFTWEIGHT, SCREEN_HEIGHT);
    } completion:^(BOOL finished){
         
    }];
}

- (void)canelLeiftButtonClicked
{
    //取消
    [UIView animateWithDuration:0.5 animations:^{
        self.leiftView.frame = CGRectMake(- _LEFTWEIGHT, 0, 150, SCREEN_HEIGHT);
    } completion:^(BOOL finished){
        [self.maskView removeFromSuperview];
        [self.leiftView removeFromSuperview];
    }];
    
}

- (void)messageButtonCilick
{
    //消息
    if (![UserSignData share].user.isCode)
    {
        MessageVC * vc = [[MessageVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [LCProgressHUD showMessage:@"冷钱包"];
    }
}

- (void)leftButtonCilick
{
    //ETH (首页)
}

- (void)rightButtonCilick
{
    //BTC (首页)
}

- (void)addWalletButtonCilick
{
    //添加钱包
    [self canelLeiftButtonClicked];
    AddWalletChoseTypeVC * vc = [[AddWalletChoseTypeVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)importWalletButtonCilick
{
    //导入钱包
    [self canelLeiftButtonClicked];
    AddWalletChoseTypeVC * vc = [[AddWalletChoseTypeVC alloc] init];
    vc.isimport = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scanButtonCilick
{
    //扫一扫
    [self canelLeiftButtonClicked];
    ScanVC * vc = [[ScanVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scanSucessWithObject:(id)object
{
    //扫描结果
    self.transferAddress = object;
    [self.choseWalletView showWithView:nil];
}

//选择钱包回调
- (void)sureButtonCilickWithData:(id)data
{
    self.walletModel = data;
    self.commitOrderView = [[CommitOrderVC alloc] init];
    self.commitOrderView.delegate = self;
    
    [LCProgressHUD showLoading:@"加载中..."];
    //获取账户余额
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.walletModel.address forKey:@"address"];
    
    [PPNetworkHelper POST:@"extend/getBalance" parameters:dic hudString:nil success:^(id responseObject)
     {
         self.banlacePrice = [NSString stringWithFormat:@"%.4f",[[NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[responseObject objectForKey:@"value"] substringFromIndex:2]] secend:@"1000000000000000000" value:4] floatValue]];
         self.commitOrderView.banalce = self.banlacePrice;
         
         //获取gas手续费单价
         [PPNetworkHelper POST:@"extend/getGasPrice" parameters:nil hudString:@"获取中..." success:^(id responseObject)
          {
              //获取单价
              NSString * per = @"0";
              if (![NSString isNulllWithObject:responseObject])
              {
                  //获取单价
                  per = [[responseObject objectForKey:@"gasPrice"] substringFromIndex:2];
              }
              self.gasPrice = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:per] secend:@"1000000000000000000" value:8];
              self.totleGasPrice = [NSString DecimalFuncWithOperatorType:2 first:self.gasPrice secend:[NSString stringWithFormat:@"%d",self.defaultGasNum] value:8];
              
              self.commitOrderView.gas = self.gasPrice;
              self.commitOrderView.changesPrice = self.totleGasPrice;
              self.commitOrderView.defaultGasNum = self.defaultGasNum;
              
              //获取交易次数
              NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
              [dic setObject:self.walletModel.address forKey:@"address"];
              
              [PPNetworkHelper POST:@"extend/getTransactionCount" parameters:dic hudString:nil success:^(id responseObject)
               {
                   // nonce 参数
                   if (![NSString isNulllWithObject:[responseObject objectForKey:@"count"]])
                   {
                       self.nonce = [responseObject objectForKey:@"count"];
                   }
                   
                   dispatch_queue_t mainQueue = dispatch_get_main_queue();
                   //异步返回主线程，根据获取的数据，更新UI
                   dispatch_async(mainQueue, ^
                                  {
                                      [LCProgressHUD hide];
                                  });
                   //初始化钱包订单页面
                   self.commitOrderView.orderTitle = @"扫描转账";
                   self.commitOrderView.transferAddress = self.transferAddress;
                   self.commitOrderView.address = self.walletModel.address;
                   if (self.walletModel.isLookWallet)
                   {
                       //观察钱包、关键语句，必须有
                       self.commitOrderView.modalPresentationStyle = UIModalPresentationOverFullScreen;
                       [self presentViewController:self.commitOrderView animated:YES completion:nil];
                   }
                   else
                   {
                       //普通钱包
                       self.commitOrderView.modalPresentationStyle = UIModalPresentationOverFullScreen;
                       [self presentViewController:self.commitOrderView animated:YES completion:nil];
                       
                   }
               } failure:^(NSString *error)
               {
                   [LCProgressHUD showFailure:error];
                   dispatch_queue_t mainQueue = dispatch_get_main_queue();
                   //异步返回主线程，根据获取的数据，更新UI
                   dispatch_async(mainQueue, ^
                                  {
                                      [LCProgressHUD hide];
                                  });
               }];
              
          } failure:^(NSString *error)
          {
              [LCProgressHUD showFailure:error];
              dispatch_queue_t mainQueue = dispatch_get_main_queue();
              //异步返回主线程，根据获取的数据，更新UI
              dispatch_async(mainQueue, ^
                             {
                                 [LCProgressHUD hide];
                             });
          }];
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
         dispatch_queue_t mainQueue = dispatch_get_main_queue();
         //异步返回主线程，根据获取的数据，更新UI
         dispatch_async(mainQueue, ^
                        {
                            [LCProgressHUD hide];
                        });
     }];
    
}

- (void)comiitButtonCilickWithchangesPrice:(NSString *)changesPrice gasprice:(NSString *)gasprice
{
    //确定
    
    if (self.nonce.length == 0)
    {
        [LCProgressHUD showMessage:@"暂未获取到交易次数。请稍后再试"];
        return;
    }
    //钱包余额判断   手续费 + 转账金额 <= ether钱包余额
    if (self.commitOrderView.priceTF.text.length == 0)
    {
        [LCProgressHUD showMessage:@"请输入正确价格"];
        return;
    }
    
    NSComparisonResult result = [NSString DecimalFuncComparefirst:self.commitOrderView.priceTF.text secend:self.banlacePrice];
    if (result == NSOrderedDescending)
    {
        [LCProgressHUD showMessage:@"钱包余额不足"];
        return;
    }
    
    ConfirmationTransferVC * vc = [[ConfirmationTransferVC alloc] init];
    vc.totleGasPrice = changesPrice;
    vc.gasprice = gasprice;
    vc.nonce = self.nonce;
    vc.price = self.commitOrderView.priceTF.text;
    vc.address = self.commitOrderView.transferAddressLB.text;
    vc.remark = @"";
    vc.model = self.walletModel;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
//{
//    //    NSLog(@" scrollViewDidScroll");
//    NSLog(@"ContentOffset  x is  %f,yis %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y > 180)
//    {
//
//        self.title = [NSString stringWithFormat:@"总资产(%@)",[UserSignData share].user.totalAssets];
//    }
//    else
//    {
//        self.title = @"我的资产";
//    }
//}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.coustromTableView)
    {
        return self.dataSource.count;
    }
    else
    {
        return self.leftdataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.coustromTableView)
    {
        WalletHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletHomeCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"WalletHomeCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    else
    {
        WalletLeiftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletLeiftCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"WalletLeiftCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.model = self.leftdataSource[indexPath.row];
        return cell;
    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.coustromTableView)
    {
        
    }
    else
    {
        [self canelLeiftButtonClicked];
        WalletLeftListModel * model = self.leftdataSource[indexPath.row];
        if (![UserSignData share].user.isCode)
        {
            //普通热钱包
            WalletInfoVC * vc = [[WalletInfoVC alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            //冷钱包
            [self canelLeiftButtonClicked];
            CodeWalletInfoVC * vc = [[CodeWalletInfoVC alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark Gettsr

- (UITableView *)coustromTableView
{
    if (!_coustromTableView) {
        _coustromTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 46 - 64) style:UITableViewStylePlain];
        _coustromTableView.delegate = self;
        _coustromTableView.dataSource = self;
        _coustromTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableView.showsVerticalScrollIndicator = NO;
        _coustromTableView.showsHorizontalScrollIndicator = NO;
        _coustromTableView.rowHeight = 100;
    }
    return _coustromTableView;
}

- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _LEFTWEIGHT, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        _leftTableView.rowHeight = 80;
    }
    return _leftTableView;
}

- (WalletHeaderView *)headerView
{
    if (!_headerView)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WalletHeaderView" owner:self options:nil];
        _headerView = [nib objectAtIndex:0];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 306);
//        [_headerView.moreButton addTarget:self action:@selector(moreButtonCilick) forControlEvents:UIControlEventTouchUpInside];
//        [_headerView.messageButton addTarget:self action:@selector(messageButtonCilick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.leftButton addTarget:self action:@selector(leftButtonCilick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.rightButton addTarget:self action:@selector(rightButtonCilick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (WalletLeiftView *)leiftView
{
    if (!_leiftView)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WalletLeiftView" owner:self options:nil];
        _leiftView = [nib objectAtIndex:0];
        
        _leiftView.frame = CGRectMake(- _LEFTWEIGHT, 0, _LEFTWEIGHT, SCREEN_HEIGHT);
        [_leiftView.addWalletButton addTarget:self action:@selector(addWalletButtonCilick) forControlEvents:UIControlEventTouchUpInside];
        [_leiftView.importWalletButton addTarget:self action:@selector(importWalletButtonCilick) forControlEvents:UIControlEventTouchUpInside];
        [_leiftView.scanButton addTarget:self action:@selector(scanButtonCilick) forControlEvents:UIControlEventTouchUpInside];
        
        [_leiftView insertSubview:self.leftTableView atIndex:0];
        
        if ([UserSignData share].user.isCode)
        {
            _leiftView.scanButton.hidden = YES;
            _leiftView.scanView.hidden = YES;
            _leiftView.hotLineView.hidden = YES;
            _leiftView.scanLineView.hidden = NO;
            [self.leftTableView setContentInset:UIEdgeInsetsMake(170, 0, 0, 0)];
        }
        else
        {
            _leiftView.scanButton.hidden = NO;
            _leiftView.scanView.hidden = NO;
            _leiftView.hotLineView.hidden = NO;
            _leiftView.scanLineView.hidden = YES;
            [self.leftTableView setContentInset:UIEdgeInsetsMake(250, 0, 0, 0)];
        }
    }
    return _leiftView;
}

- (UIView *)maskView
{
    if (!_maskView)
    {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.4;
        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canelLeiftButtonClicked)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_maskView addGestureRecognizer:singleRecognizer];
    }
    return _maskView;
}

- (ChoseWalletView *)choseWalletView
{
    if (!_choseWalletView)
    {
        _choseWalletView = [[ChoseWalletView alloc] initWithFrame:[AppDelegate delegate].window.bounds];
        _choseWalletView.delegate = self;
    }
    return _choseWalletView;
}

@end
