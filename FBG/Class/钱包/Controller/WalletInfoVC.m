//
//  ETHWalletInfoVC.m
//  FBG
//
//  Created by mac on 2017/7/17.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "WalletInfoVC.h"
#import "WalletInfoHeaderView.h"
#import "WalletHomeCell.h"
#import "TransferVC.h"
#import "ReceivablesVC.h"
#import "AddTokenVC.h"
#import "TransactionRecordVC.h"
#import "YCXMenu.h"
#import "PassWordView.h"
#import "WalletInfoGntModel.h"
#import <Social/Social.h>
#import "SystemConvert.h"
#import "TokenWalletInfoVC.h"
#import "AddOtherWalletVC.h"
#import "TransactionListVC.h"
#import "MJRefresh.h"
#import "PackupsWordsVC.h"

@interface WalletInfoVC () <UITableViewDelegate, UITableViewDataSource, PassWordViewDelegate, AlertViewDelegate, UIGestureRecognizerDelegate>
{
    BOOL _isMnemonic; //是不是助记词第一次弹窗,第二次不再继续调用
    int _isitemsType; //密码框对应类型 1 助记词 2 keyStore 3 删除
}

@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) WalletInfoHeaderView * headerView;

@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) NSMutableArray * lookWalletItems;
@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) PassWordView * password;
@property (nonatomic, strong) AlertView * alertView;
@property (nonatomic, copy) NSString * banlacePrice;

@property (nonatomic, strong) UnichainETHWallet * wallet;

// 下拉刷新视图
@property (nonatomic) MJRefreshHeader *headRefreshView;
/** 计时器 */
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation WalletInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Wallet Details", nil);
    self.view.backgroundColor = [UIColor backgroudColor];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(panduan:) name:@"SurePackupsWordNotfi" object:nil];
    
    if (self.model.isLookWallet)
    {
        //观察钱包
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_wallet"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    else
    {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_backup"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    
    self.coustromTableView.tableHeaderView = self.headerView;
    [self addpull2RefreshWithTableView:self.coustromTableView WithIsInset:NO];
    [self.view addSubview:self.coustromTableView];
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    // 获取系统自带滑动手势的target对象
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.headerView addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self panduan:nil];
}

- (void)panduan:(NSNotification *)notif
{
    if (notif != nil)
    {
        self.model.isNotBackupsWallet = NO;
    }
    
    if ([[UserSignData share].user.walletZhujiciIdsArray containsObject:@(self.model.id)])
    {
        //        [LCProgressHUD showMessage:@"该钱包已备份，不能重复备份"];
        [self.items removeObjectAtIndex:0];
    }
}

// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if(self.navigationController.childViewControllers.count == 1){
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}

-(void)handleNavigationTransition:(UIPanGestureRecognizer *)g
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.headerView.headImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-1",self.model.img]];
    self.headerView.titleLB.text = self.model.name;
    self.headerView.addressLB.text = self.model.address;
    self.headerView.priceLB.text = @"0.00";
    if ([UserSignData share].user.walletUnitType == 1)
    {
        self.headerView.infoLB.text = @"总资产（￥）";
    }
    else
    {
        self.headerView.infoLB.text = @"总资产（$）";
    }
    
    if (self.model.isLookWallet)
    {
        self.headerView.typeLB.text = @"观察";
        self.headerView.typeLB.backgroundColor = [UIColor colorWithHexString:@"66B7FB"];
    }
    else if (self.model.isNotBackupsWallet)
    {
        self.headerView.typeLB.text = @"未备份";
        self.headerView.typeLB.backgroundColor = [UIColor colorWithHexString:@"FB5A67"];
    }
    else
    {
        self.headerView.typeLB.hidden = YES;
    }
    
    [self loadData];
    [self timerDown];
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
    [self loadData];
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
    [self loadData];
}

- (void)endRefreshing
{
    [self.coustromTableView.mj_header endRefreshing];
    [self.coustromTableView.mj_footer endRefreshing];
}

- (void)rightButton
{
    if (self.model.isLookWallet)
    {
        //观察钱包
        [YCXMenu setTintColor:[UIColor whiteColor]];
        [YCXMenu setSelectedColor:[UIColor whiteColor]];
        if ([YCXMenu isShow])
        {
            [YCXMenu dismissMenu];
        }
        else
        {
            [YCXMenu showMenuInView:self.view fromRect:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 0) menuItems:self.lookWalletItems selected:^(NSInteger index, YCXMenuItem *item)
             {
                 switch (index)
                 {
                     case 0:
                     {
                         //转换成热钱包
                         AddOtherWalletVC * vc = [[AddOtherWalletVC alloc] init];
                         vc.islookWallet = YES;
                         vc.walletModel = self.model;
                         [self.navigationController pushViewController:vc animated:YES];
                         break;
                     }
                     case 1:
                     {
                         //删除钱包
                         [PPNetworkHelper DELETE:[NSString stringWithFormat:@"wallet/%d",self.model.id] parameters:nil hudString:@"删除中..." success:^(id responseObject)
                          {
                              [LCProgressHUD showSuccess:@"删除成功"];
                              [self.navigationController popViewControllerAnimated:YES];
                              
                          } failure:^(NSString *error)
                          {
                              [LCProgressHUD showFailure:error];
                          }];
                         break;
                     }
                     default:
                         break;
                 }
             }];
        }
    }
    else
    {
        //保存
        [YCXMenu setTintColor:[UIColor whiteColor]];
        [YCXMenu setSelectedColor:[UIColor whiteColor]];
        if ([YCXMenu isShow])
        {
            [YCXMenu dismissMenu];
        }
        else
        {
            [YCXMenu showMenuInView:self.view fromRect:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item)
             {
                 switch (index)
                 {
                     case 0:
                     {
                         //备份助记词
                         if ([[UserSignData share].user.walletZhujiciIdsArray containsObject:@(self.model.id)])
                         {
                             _isitemsType = 2;
                         }
                         else
                         {
                             _isitemsType = 1;
                         }
                         break;
                     }
                     case 1:
                     {
                         //备份keystore
                         if ([[UserSignData share].user.walletZhujiciIdsArray containsObject:@(self.model.id)])
                         {
                             _isitemsType = 3;
                         }
                         else
                         {
                             _isitemsType = 2;
                         }
                         break;
                     }
                     case 2:
                     {
                         //删除钱包
                         if ([[UserSignData share].user.walletZhujiciIdsArray containsObject:@(self.model.id)])
                         {
                         }
                         else
                         {
                             _isitemsType = 3;
                         }
                         break;
                     }
                     default:
                         break;
                 }
                 self.password.titleLN.text = @"请输入密码";
                 self.password.infoLB.text = @"";
                 [self.maskView addToWindow];
                 [self.password addToWindow];
                 [self.password springingAnimation];
                 [self.password begainFirstResponder];
             }];
        }
    }
    
}

- (void)loadData
{
    self.headerView.priceLB.text = @"0.00";
    //用户已添加代币类型列表
    [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%d",self.model.id] parameters:nil hudString:nil success:^(id responseObject)
     {
         if ([[responseObject objectForKey:@"list"] count] > 0)
         {
             [self.dataSource removeAllObjects];
             for (NSDictionary * dic in [responseObject objectForKey:@"list"])
             {
                 WalletInfoGntModel * model = [[WalletInfoGntModel alloc] initWithDictionary:dic];
                 model.icon = [[dic objectForKey:@"gnt_category"] objectForKey:@"icon"];
                 model.address = [[dic objectForKey:@"gnt_category"] objectForKey:@"address"];
                 model.symbol = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"symbol"];
                 model.price_cny = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_cny"];
                 model.price_usd = [[[dic objectForKey:@"gnt_category"] objectForKey:@"cap"] objectForKey:@"price_usd"];
                 model.flag = [dic objectForKey:@"name"];
                 if (![NSString isNulllWithObject:[dic objectForKey:@"balance"]])
                 {
                     model.balance = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[dic objectForKey:@"balance"] substringFromIndex:2]] secend:@"1000000000000000000" value:4];
                 }
                 else
                 {
                     model.balance = @"0.0000";
                 }
                 model.gas = [[[dic objectForKey:@"gnt_category"] objectForKey:@"gas"] intValue];
                 
                 if ([UserSignData share].user.walletUnitType == 1)
                 {
                     NSString * price = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:model.price_cny value:2];
                     self.headerView.priceLB.text = [NSString stringWithFormat:@"%.2f",[[NSString DecimalFuncWithOperatorType:0 first:self.headerView.priceLB.text secend:price value:2] floatValue]];
                 }
                 else
                 {
                     NSString * price = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:model.price_usd value:2];
                     self.headerView.priceLB.text = [NSString stringWithFormat:@"%.2f",[[NSString DecimalFuncWithOperatorType:0 first:self.headerView.priceLB.text secend:price value:2] floatValue]];
                 }
                 
                 [self.dataSource addObject:model];
             }
             [self.coustromTableView reloadData];
         }
         [self endRefreshing];
     }failure:^(NSString *error)
     {
         [self endRefreshing];
         [LCProgressHUD showFailure:error];
     }];
    
    //获取账户余额
//    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:self.model.address forKey:@"address"];
//    
//    [PPNetworkHelper POST:@"extend/getBalance" parameters:dic hudString:nil success:^(id responseObject)
//     {
//         self.banlacePrice = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[responseObject objectForKey:@"value"] substringFromIndex:2]] secend:@"1000000000000000000"];
//         self.headerView.priceLB.text = self.banlacePrice;
//         self.headerView.infoLB.text = [NSString stringWithFormat:@"≈￥0.00"];
//         
//     } failure:^(NSString *error)
//     {
//         [LCProgressHUD showFailure:error];
//     }];
    
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:[@[@(self.model.id)] toJSONStringForArray] forKey:@"wallet_ids"];
    
    [PPNetworkHelper GET:@"conversion" parameters:parametersDic hudString:nil success:^(id responseObject)
     {
         if ([[responseObject objectForKey:@"list"] count] > 0)
         {
             
             for (NSDictionary * dic in [responseObject objectForKey:@"list"])
             {
                 if (![NSString isNulllWithObject:[dic objectForKey:@"balance"]])
                 {
                     self.banlacePrice = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[dic objectForKey:@"balance"] substringFromIndex:2]] secend:@"1000000000000000000" value:4];
                 }
                 else
                 {
                     self.banlacePrice = [NSString DecimalFuncWithOperatorType:3 first:@"0" secend:@"1000000000000000000" value:4];
                 }
                 self.headerView.ETHpriceLB.text = [NSString stringWithFormat:@"%.4f",[self.banlacePrice floatValue]];
                 
                 if ([UserSignData share].user.walletUnitType == 1)
                 {
                     NSString * price_cny = [NSString DecimalFuncWithOperatorType:2 first:self.banlacePrice secend:[[[dic objectForKey:@"category"] objectForKey:@"cap"] objectForKey:@"price_cny"] value:4];
                     self.headerView.priceLB.text = [NSString stringWithFormat:@"%.2f",[[NSString DecimalFuncWithOperatorType:0 first:self.headerView.priceLB.text secend:price_cny value:2] floatValue]];
                     self.headerView.ETHcnyLB.text = [NSString stringWithFormat:@"≈￥%.2f",[price_cny floatValue]];
                 }
                 else
                 {
                     NSString * price_usd = [NSString DecimalFuncWithOperatorType:2 first:self.banlacePrice secend:[[[dic objectForKey:@"category"] objectForKey:@"cap"] objectForKey:@"price_usd"] value:4];
                     self.headerView.priceLB.text = [NSString stringWithFormat:@"%.2f",[[NSString DecimalFuncWithOperatorType:0 first:self.headerView.priceLB.text secend:price_usd value:2] floatValue]];
                     self.headerView.ETHcnyLB.text = [NSString stringWithFormat:@"≈$%.2f",[price_usd floatValue]];
                 }
             }
         }
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //    NSLog(@" scrollViewDidScroll");
    NSLog(@"ContentOffset  x is  %f,yis %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > 180)
    {
        if ([UserSignData share].user.walletUnitType == 1)
        {
            self.title = [NSString stringWithFormat:@"总资产(≈￥%@)",self.headerView.priceLB.text];
        }
        else
        {
            self.title = [NSString stringWithFormat:@"总资产(≈$%@)",self.headerView.priceLB.text];
        }
    }
    else
    {
        self.title = NSLocalizedString(@"Wallet Details", nil);
    }
}

#pragma mark - 右上角备份分享删除相关操作

- (void)sureButtonCilick
{
    //确认提醒
    if (_isMnemonic)
    {
        _isMnemonic = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //延时等待动画完成加载弹窗
            self.alertView.alertContInfoLB.text = NSLocalizedString(@"Repeat enter security code to verify the correctness of the wallet security code", nil);
            self.alertView.alertTextView.userInteractionEnabled = YES;
            [self.alertView.alertSureButton setTitle:NSLocalizedString(@"Backup security code and delete records", nil) forState:UIControlStateNormal];
            [self.alertView showWithView:self.view];
            self.alertView.alertTextView.text = @"";
            [self.alertView.alertTextView becomeFirstResponder];
        });
    }
    
}

- (void)caneButtonClicked
{
    //取消支付
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

- (void)canel
{
    //取消删除支付密码
    [self caneButtonClicked];
}

- (void)sureWithPassWord:(NSString *)passWord
{
    //确认删除支付密码
    switch (_isitemsType)
    {
        case 1:
        {
            //备份助记词
            
            NSData * data = [PDKeyChain load:self.model.address];
            [LCProgressHUD showLoading:@"验证中..."];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^
                           {
                               //子线程异步执行下载任务，防止主线程卡顿
                               NSError * error;
                               UnichainETHWallet * Wallet = UnichainOpenETHWallet(data,passWord,&error);
                               
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
                                                             [self caneButtonClicked];
                                                             
                                                             PackupsWordsVC * vc = [[PackupsWordsVC alloc] init];
                                                             vc.mnemonic = mnemonic;
                                                             vc.model = self.model;
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
                                                             [self caneButtonClicked];
                                                             [LCProgressHUD showMessage:@"获取助记词失败，请稍后重试"];
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
                               
                               
                           });
            break;
        }
        case 2:
        {
            //备份keyStore
            NSData * data = [PDKeyChain load:self.model.address];
            [LCProgressHUD showLoading:@"验证中..."];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^
                           {
                               //子线程异步执行下载任务，防止主线程卡顿
                               NSError * error;
                               UnichainOpenETHWallet(data,passWord,&error);
                               
                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                               //异步返回主线程，根据获取的数据，更新UI
                               dispatch_async(mainQueue, ^
                                              {
                                                  if (!error)
                                                  {
                                                      //要分享内容
                                                      [LCProgressHUD hide];
                                                      [self caneButtonClicked];
                                                      NSString *result =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
                                                              if (![[UserSignData share].user.walletIdsArray containsObject:@(self.model.id)])
                                                              {
                                                                  [[UserSignData share].user.walletIdsArray addObject:@(self.model.id)];
                                                                  [[UserSignData share] storageData:[UserSignData share].user];
                                                              }
                                                              self.headerView.typeLB.hidden = YES;
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
                                                      [self caneButtonClicked];
                                                      [LCProgressHUD showMessage:@"密码错误，请重新输入"];
                                                  }
                                              });
                               
                           });
            break;
        }
        case 3:
        {
            //删除
            NSData * data = [PDKeyChain load:self.model.address];
            [LCProgressHUD showLoading:@"验证中..."];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^
                           {
                               //子线程异步执行下载任务，防止主线程卡顿
                               NSError * error;
                               UnichainOpenETHWallet(data,passWord,&error);
                               
                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                               //异步返回主线程，根据获取的数据，更新UI
                               dispatch_async(mainQueue, ^
                                              {
                                                  if (!error)
                                                  {
                                                      [LCProgressHUD hide];
                                                      [self caneButtonClicked];
                                                      
                                                      [PPNetworkHelper DELETE:[NSString stringWithFormat:@"wallet/%d",self.model.id] parameters:nil hudString:@"删除中..." success:^(id responseObject)
                                                       {
                                                           [LCProgressHUD showSuccess:@"删除成功"];
                                                           [PDKeyChain delete:self.model.address];
                                                           [self caneButtonClicked];
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                           
                                                       } failure:^(NSString *error)
                                                       {
                                                           [LCProgressHUD showFailure:error];
                                                       }];
                                                       
                                                  }
                                                  else
                                                  {
                                                      [LCProgressHUD hide];
                                                      [self caneButtonClicked];
                                                      [LCProgressHUD showMessage:@"密码错误，请稍后重试"];
                                                  }
                                              });
                               
                           });
            break;
        }
        default:
            break;
    }
}

#pragma mark -- 相关功能操作

- (void)transferButtonCilick
{
    //转账
    TransferVC * vc = [[TransferVC alloc] init];
    vc.model = self.model;
    vc.banlacePrice = self.banlacePrice;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)receivablesButtonCilick
{
    //收款
    ReceivablesVC * vc = [[ReceivablesVC alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)transactionButtonCilick
{
    //交易记录
    TransactionRecordVC  * vc = [[TransactionRecordVC alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editButtonCilick
{
    //添加代币
    AddTokenVC * vc = [[AddTokenVC alloc] init];
    vc.walletModel = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //进入代币详情
    WalletInfoGntModel * model = self.dataSource[indexPath.row];
    TransactionListVC * vc = [[TransactionListVC alloc] init];
    vc.tokenModel = model;
    vc.model = self.model;
    vc.banlacePrice = self.banlacePrice;
    vc.WalletbanlacePrice = self.headerView.ETHpriceLB.text;
    vc.title = model.name;
    if ([UserSignData share].user.walletUnitType == 1)
    {
        vc.cnybanlacePrice = [NSString stringWithFormat:@"≈￥%.2f",[[NSString DecimalFuncWithOperatorType:2 first:model.balance secend:model.price_cny value:2] floatValue]];
    }
    else
    {
        vc.cnybanlacePrice = [NSString stringWithFormat:@"≈$%.2f",[[NSString DecimalFuncWithOperatorType:2 first:model.balance secend:model.price_usd value:2] floatValue]];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

//选择eth钱包
- (void)ETHButtonCilick
{
    TransactionListVC * vc = [[TransactionListVC alloc] init];
    vc.model = self.model;
    vc.banlacePrice = self.banlacePrice;
    vc.title = @"ETH";
    vc.cnybanlacePrice = self.headerView.ETHcnyLB.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletInfoGntModel * model = self.dataSource[indexPath.row];
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        [PPNetworkHelper DELETE:[NSString stringWithFormat:@"user-gnt/%d",model.id] parameters:nil hudString:@"删除中..." success:^(id responseObject)
        {
            //1.更新数据
            [self.dataSource removeObjectAtIndex:indexPath.row];
            //2.更新UI
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            
        } failure:^(NSString *error)
         {
            [LCProgressHUD showFailure:error];
        }];
        tableView.editing = NO;
    }];
    //删除按钮颜色
    
    deleteAction.backgroundColor = [UIColor colorWithHexString:@"fdd930"];
    //添加一个置顶按钮
    UITableViewRowAction *topRowAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:NSLocalizedString(@"Top", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        [PPNetworkHelper PUT:[NSString stringWithFormat:@"user-gnt/%d",model.id] parameters:nil hudString:@"置顶中..." success:^(id responseObject)
        {
            //1.更新数据
            [self.dataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
            //2.更新UI
            NSIndexPath *firstIndexPath =[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
            
        } failure:^(NSString *error)
        {
            [LCProgressHUD showFailure:error];
        }];
        tableView.editing = NO;
    }];
    //置顶按钮颜色
    topRowAction.backgroundColor = [UIColor colorWithHexString:@"BABABB"];
//    topRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)];
    
    //将设置好的按钮方到数组中返回
    return @[topRowAction,deleteAction];
}

#pragma mark Gettsr

- (UITableView *)coustromTableView
{
    if (!_coustromTableView) {
        _coustromTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _coustromTableView.delegate = self;
        _coustromTableView.dataSource = self;
        _coustromTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableView.showsVerticalScrollIndicator = NO;
        _coustromTableView.showsHorizontalScrollIndicator = NO;
        _coustromTableView.rowHeight = 100;
    }
    return _coustromTableView;
}

- (WalletInfoHeaderView *)headerView
{
    if (!_headerView)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WalletInfoHeaderView" owner:self options:nil];
        _headerView = [nib objectAtIndex:0];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 330);
        _headerView.addressLB.userInteractionEnabled = YES;
        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receivablesButtonCilick)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_headerView.addressLB addGestureRecognizer:singleRecognizer];
        
        [_headerView.codeButton addTarget:self action:@selector(receivablesButtonCilick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.ETHButton addTarget:self action:@selector(ETHButtonCilick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.addTokenButton addTarget:self action:@selector(editButtonCilick) forControlEvents:UIControlEventTouchUpInside];
        if ([self.model.name isEqualToString:@"ETH"])
        {
            //ETH
            _headerView.titleLB.text = @"ETH";
        }
        else
        {
            //BTC
            _headerView.titleLB.text = @"BTC";
        }
    }
    return _headerView;
}

- (NSMutableArray *)items
{
    if (!_items)
    {
        _items = [@[
                    [YCXMenuItem menuItem:NSLocalizedString(@"Backup Mnemonic", nil)
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:NSLocalizedString(@"Backup Keystore", nil)
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:NSLocalizedString(@"Delete Wallet", nil)
                                    image:nil
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}]
                    ] mutableCopy];
    }
    return _items;
}

- (NSMutableArray *)lookWalletItems
{
    if (!_lookWalletItems)
    {
        _lookWalletItems = [@[
                    [YCXMenuItem menuItem:@"转化钱包"
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"删除钱包"
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}]
                    ] mutableCopy];
    }
    return _lookWalletItems;
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
        _password.frame = CGRectMake(0, 0, SCREEN_WIDTH - 60, (SCREEN_WIDTH - 60) * 216 / 307 + 40);
        _password.center = CGPointMake(SCREEN_WIDTH / 2, (SCREEN_HEIGHT - 216) / 2);
        _password.delegate = self;
//        _password.titleLN.text = NSLocalizedString(@"Please input a password", nil);
//        _password.infoLB.text = NSLocalizedString(@"You can't retrieve your wallet after you delete it. Please be careful", nil);
    }
    return _password;
}

- (AlertView *)alertView
{
    if (!_alertView)
    {
        _alertView = [[AlertView alloc] initWithFrame:[AppDelegate delegate].window.bounds];
        _alertView.delegate = self;
    }
    return _alertView;
}

@end
