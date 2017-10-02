//
//  KeyStoreVC.m
//  FBG
//
//  Created by mac on 2017/7/27.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddOtherWalletInfoVC.h"
#import "ScanVC.h"
#import "PassWordView.h"
#import "WalletNameVC.h"
#import "AddWalletInfoVC.h"

@interface AddOtherWalletInfoVC () <ScanVCDelegate,PassWordViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (nonatomic, strong) PassWordView * passwordview;
@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) UnichainETHWallet * wallet;

@end

@implementation AddOtherWalletInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.sureButton setTitle:NSLocalizedString(@"Begin Import", nil) forState:UIControlStateNormal];
    /*
     1  Keystore
     2  助记词
     3  私匙
     4  观察
     5  种子
     
     助记词    需要弹出一个输入密码框 跳名称设置 不要设置密码
     私匙     不弹出密码框  跳钱包上传
     观察     不弹出密码框  跳转到        跳名称设置 不要设置密码
     */
    NSArray * titleArray = @[NSLocalizedString(@"Add KeyStore", nil),
                              NSLocalizedString(@"Add Security Code", nil),
                              NSLocalizedString(@"Add Plaintext Private Key", nil),
                              NSLocalizedString(@"Add Observation Wallet", nil),
                              NSLocalizedString(@"Add Seed", nil)];
    self.title = titleArray[self.type - 1];
    NSArray * typeLBArray = @[NSLocalizedString(@"Copy and paste the contents of the keystore file, you can also scan the two-dimensional code through the upper right corner, enter the information", nil),
                              NSLocalizedString(@"Please enter a security code, separated by space", nil),
                              NSLocalizedString(@"Please enter the explicit private key", nil),
                              NSLocalizedString(@"Watch the wallet, you only need to import the wallet address, you can conduct day-to-day account management and transactions. Large assets suggest cold wallet or other means of management, to avoid leakage, stolen", nil),
                              NSLocalizedString(@"Please enter seeds, separated by spaces", nil)];
    self.typeLB.text = typeLBArray[self.type - 1];
    
    if (self.type != 5)
    {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_scan"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    
    
}

- (void)caneButtonClicked
{
    //取消支付
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.passwordview.alpha = 0;
    } completion:^(BOOL finished){
        [self.maskView removeFromSuperview];
        [self.passwordview removeFromSuperview];
        self.maskView.alpha = 0.4;
        self.passwordview.alpha = 1;
        [self.passwordview clean];
    }];
    
}

- (void)canel
{
    //取消支付密码
    [self caneButtonClicked];
}

- (void)sureWithPassWord:(NSString *)passWord
{
    //确认支付密码
    //keyStore
    NSData * data = [self.infoTextView.text dataUsingEncoding:NSUTF8StringEncoding];
    [LCProgressHUD showLoading:@"验证中..."];
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^
                   {
                       //子线程异步执行下载任务，防止主线程卡顿
                       NSError * error;
                       self.wallet = UnichainOpenETHWallet(data,passWord,&error);
                       
                       dispatch_queue_t mainQueue = dispatch_get_main_queue();
                       //异步返回主线程，根据获取的数据，更新UI
                       dispatch_async(mainQueue, ^
                                      {
                                          if (!error)
                                          {
                                              [LCProgressHUD hide];
                                              [self caneButtonClicked];
                                              //创建成功
                                              if (self.islookWallet)
                                              {
                                                  //观察钱包升级 keyStore
                                                  if ([[[self.walletModel address] lowercaseString] isEqualToString:self.walletModel.address])
                                                  {
                                                      [LCProgressHUD showMessage:@"转化成功"];
                                                      [PDKeyChain save:[[self.wallet address] lowercaseString] data:data];
                                                      [self.navigationController popToRootViewControllerAnimated:NO];
                                                      self.walletModel.isLookWallet = NO;
                                                      self.walletModel.isNotBackupsWallet = YES;
                                                      [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"AddWalletSucessPushWalletInfoNotification" object:self.walletModel userInfo:nil]];
                                                  }
                                                  else
                                                  {
                                                      [LCProgressHUD showMessage:@"该钱包的地址对比不正确,请确认后重试"];
                                                  }
                                              }
                                              else
                                              {
                                                  WalletNameVC * vc = [[WalletNameVC alloc] init];
                                                  vc.model = self.model;
                                                  vc.wallet = self.wallet;
                                                  [PDKeyChain save:[[self.wallet address] lowercaseString] data:data];
                                                  [self.navigationController pushViewController:vc animated:YES];
                                              }
                                          }
                                          else
                                          {
                                              [LCProgressHUD hide];
                                              [self caneButtonClicked];
                                              [LCProgressHUD showMessage:@"获取钱包失败，请稍后重试"];
                                          }
                                      });
                       
                   });
}

- (void)scanSucessWithObject:(id)object
{
    //扫一扫回调
    self.infoTextView.text = [NSString stringWithFormat:@"%@",object];
}

- (void)rightButton
{
    //扫一扫
    ScanVC * vc = [[ScanVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)begeainButtonCilick:(id)sender
{
    //开始导入
    /*
     1  Keystore
     2  助记词
     3  私匙
     4  观察
     5  种子
     */
    
    if (self.infoTextView.text.length == 0)
    {
        [LCProgressHUD showMessage:@"请确认信息是否完善"];
        return;
    }
    switch (self.type)
    {
        case 1:
        {
            self.passwordview.titleLN.text = @"请输入密码";
            self.passwordview.infoLB.text = @"";
            [self.maskView addToWindow];
            [self.passwordview addToWindow];
            [self.passwordview springingAnimation];
            [self.passwordview begainFirstResponder];
            break;
        }
        case 2:
        {
            [LCProgressHUD showLoading:@"验证中..."];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^
                           {
                               //子线程异步执行下载任务，防止主线程卡顿
                               NSError * error;
                               self.wallet = UnichainETHWalletFromMnemonic(self.infoTextView.text,&error);
                               
                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                               //异步返回主线程，根据获取的数据，更新UI
                               dispatch_async(mainQueue, ^
                                              {
                                                  if (!error)
                                                  {
                                                      [LCProgressHUD hide];
                                                      [self caneButtonClicked];
                                                      
                                                      //创建成功
                                                      if (self.islookWallet)
                                                      {
                                                          //观察钱包升级 助记词
                                                          if ([[[self.walletModel address] lowercaseString] isEqualToString:self.walletModel.address])
                                                          {
                                                              AddWalletInfoVC * vc = [[AddWalletInfoVC alloc] init];
                                                              vc.model = self.model;
                                                              vc.ETHWallet = self.wallet;
                                                              vc.walletModel = self.walletModel;
                                                              [self.navigationController pushViewController:vc animated:YES];
                                                          }
                                                          else
                                                          {
                                                              [LCProgressHUD showMessage:@"该钱包的地址对比不正确,请确认后重试"];
                                                          }
                                                      }
                                                      else
                                                      {
                                                          AddWalletInfoVC * vc = [[AddWalletInfoVC alloc] init];
                                                          vc.model = self.model;
                                                          vc.ETHWallet = self.wallet;
                                                          [self.navigationController pushViewController:vc animated:YES];
                                                      }
                                                  }
                                                  else
                                                  {
                                                      [LCProgressHUD hide];
                                                      [self caneButtonClicked];
                                                      [LCProgressHUD showMessage:@"获取钱包失败，请稍后重试"];
                                                  }
                                              });
                               
                           });
            break;
        }
        case 3:
        {
            [LCProgressHUD showLoading:@"验证中..."];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^
                           {
                               //子线程异步执行下载任务，防止主线程卡顿
                               NSError * error;
                               self.wallet = UnichainETHWalletFromPrivateKey(self.infoTextView.text,&error);
                               
                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                               //异步返回主线程，根据获取的数据，更新UI
                               dispatch_async(mainQueue, ^
                                              {
                                                  if (!error)
                                                  {
                                                      [LCProgressHUD hide];
                                                      [self caneButtonClicked];
                                                      //创建成功
                                                      if (self.islookWallet)
                                                      {
                                                          //观察钱包升级 私匙
                                                          if ([[[self.walletModel address] lowercaseString] isEqualToString:self.walletModel.address])
                                                          {
                                                              AddWalletInfoVC * vc = [[AddWalletInfoVC alloc] init];
                                                              vc.model = self.model;
                                                              vc.ETHWallet = self.wallet;
                                                              vc.walletModel = self.walletModel;
                                                              [self.navigationController pushViewController:vc animated:YES];
                                                          }
                                                          else
                                                          {
                                                              [LCProgressHUD showMessage:@"该钱包的地址对比不正确,请确认后重试"];
                                                          }
                                                      }
                                                      else
                                                      {
                                                          AddWalletInfoVC * vc = [[AddWalletInfoVC alloc] init];
                                                          vc.model = self.model;
                                                          vc.ETHWallet = self.wallet;
                                                          [self.navigationController pushViewController:vc animated:YES];
                                                      }
                                                  }
                                                  else
                                                  {
                                                      [LCProgressHUD hide];
                                                      [self caneButtonClicked];
                                                      [LCProgressHUD showMessage:@"获取钱包失败，请稍后重试"];
                                                  }
                                              });
                               
                           });
            break;
        }
        case 4:
        {
            if ([NSString isAdress:[self.infoTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]])
            {
                //创建成功
                WalletNameVC * vc = [[WalletNameVC alloc] init];
                vc.model = self.model;
                vc.address = [self.infoTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [LCProgressHUD showMessage:@"请输入正确的钱包地址"];
            }
            
            break;
        }
        default:
            break;
    }
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

- (PassWordView *)passwordview
{
    if (!_passwordview)
    {
        _passwordview = [PassWordView loadViewFromXIB];
        _passwordview.frame = CGRectMake(0, 0, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40) * 216 / 307 + 40);
        _passwordview.center = CGPointMake(SCREEN_WIDTH / 2, (SCREEN_HEIGHT - 216) / 2);
        _passwordview.delegate = self;
    }
    return _passwordview;
}
@end
