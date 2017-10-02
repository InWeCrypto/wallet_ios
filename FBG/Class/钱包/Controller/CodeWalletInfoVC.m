//
//  CodeWalletInfoVC.m
//  FBG
//
//  Created by mac on 2017/7/19.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "CodeWalletInfoVC.h"
#import "ScanVC.h"
#import "ReceivablesVC.h"
#import "TransactionRecordVC.h"
#import "ConfirmationTransferVC.h"
#import "WalletLeftListModel.h"
#import "TransactionListVC.h"
#import "YCXMenu.h"
#import "PackupsWordsVC.h"

@interface CodeWalletInfoVC () <ScanVCDelegate>
{
    int _isitemsType; //密码框对应类型 1 助记词 2 keyStore 3 删除
}

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *walletStatusLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (weak, nonatomic) IBOutlet UILabel *ETHpriceLB;
@property (weak, nonatomic) IBOutlet UILabel *ETHcnyLB;

@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) PassWordView * password;

@end

@implementation CodeWalletInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Wallet Details", nil);
    
//    self.walletStatusLB.text = NSLocalizedString(@"Cold Purse", nil);
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(panduan:) name:@"SurePackupsWordNotfi" object:nil];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_backup"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.headImage.image = [UIImage imageNamed:self.model.img];
    self.titleLB.text = self.model.name;
    self.addressLB.text = self.model.address;
    self.priceLB.text = @"0.00";
    self.ETHpriceLB.text = @"0.0000";
    UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receivalesButtonCilick:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.addressLB addGestureRecognizer:singleRecognizer];
    
    [self.codeButton addTarget:self action:@selector(receivalesButtonCilick:) forControlEvents:UIControlEventTouchUpInside];
    if ([UserSignData share].user.walletUnitType == 1)
    {
        self.infoLB.text = @"总资产（￥）";
        self.ETHcnyLB.text = @"≈￥0.00";
    }
    else
    {
        self.infoLB.text = @"总资产（$）";
        self.ETHcnyLB.text = @"≈$0.00";
    }
    
    if (self.model.isNotBackupsWallet)
    {
        self.walletStatusLB.text = @"未备份";
        self.walletStatusLB.backgroundColor = [UIColor colorWithHexString:@"FB5A67"];
    }
    else
    {
        self.walletStatusLB.backgroundColor = [UIColor colorWithHexString:@"66B7FB"];
        self.walletStatusLB.text = @"冷钱包";
    }
    [self panduan:nil];
}

- (void)panduan:(NSNotification *)notif
{
    if (notif != nil)
    {
        self.model.isNotBackupsWallet = NO;
    }
    
    if ([[UserSignData share].user.walletIdsArray containsObject:@(self.model.id)] && ([[UserSignData share].user.walletZhujiciIdsArray containsObject:@(self.model.id)]))
    {
        //        [LCProgressHUD showMessage:@"该钱包已备份，不能重复备份"];
        
        [self.items removeObjectAtIndex:0];
    }
}

- (void)rightButton
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

- (IBAction)ETHButtonCilick:(id)sender
{
    //选择ETH代币
    TransactionListVC * vc = [[TransactionListVC alloc] init];
    vc.model = self.model;
    vc.banlacePrice = @"0.00";
    vc.title = @"ETH";
    vc.cnybanlacePrice = @"≈￥0.00";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scanSucessWithObject:(id)object
{
    //扫一扫回调  获取到json 转字典传给确认转账页面
    NSDictionary * dic = [NSDictionary dictionaryWithJsonString:object];
    
    if (![self.model.address isEqualToString:[dic objectForKey:@"wallet_address"]])
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
    if ([[dic objectForKey:@"type"] isEqualToString:@"2"])
    {
        WalletInfoGntModel * model = [[WalletInfoGntModel alloc] init];
        vc.tokenModel = model;
    }
    vc.isCodeWallet = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
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
                                                              self.walletStatusLB.hidden = @"冷钱包";
                                                              self.walletStatusLB.backgroundColor = [UIColor colorWithHexString:@"66B7FB"];
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
                                                      for (NSDictionary * dic in [UserSignData share].user.codeWalletsArray)
                                                      {
                                                          if ([[dic objectForKey:@"address"] isEqualToString:self.model.address])
                                                          {
                                                              [LCProgressHUD hide];
                                                              [self caneButtonClicked];
                                                              
                                                              [PDKeyChain delete:self.model.address];
                                                              [[UserSignData share].user.codeWalletsArray removeObject:dic];
                                                              [[UserSignData share] storageData:[UserSignData share].user];
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }
                                                      }
                                                      
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

- (IBAction)scanButtonCilick:(id)sender
{
    //扫描签名
    ScanVC * vc = [[ScanVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)receivalesButtonCilick:(id)sender
{
    //收款
    ReceivablesVC * vc = [[ReceivablesVC alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)deleteButtonCilick:(id)sender
{
    //删除
    for (NSDictionary * dic in [UserSignData share].user.codeWalletsArray)
    {
        if ([[dic objectForKey:@"address"] isEqualToString:self.model.address])
        {
            [[UserSignData share].user.codeWalletsArray removeObject:dic];
            [self.navigationController popViewControllerAnimated:YES];
            [[UserSignData share] storageData:[UserSignData share].user];
        }
    }
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

@end
