//
//  AddWalletInfoVC.m
//  FBG
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddWalletInfoVC.h"
#import "AddWalletSucessVC.h"
#import "WalletLeftListModel.h"

@interface AddWalletInfoVC () <AlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *passWordLB;
@property (weak, nonatomic) IBOutlet UILabel *repasWordLB;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pasWordTF;
@property (weak, nonatomic) IBOutlet UITextField *rePasWordTF;

@property (nonatomic, copy) NSString * mnemonicStr;
@property (nonatomic, strong) AlertView * alertView;

@end

@implementation AddWalletInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Add Wallet", nil);
    self.nameLB.text = NSLocalizedString(@"Wallet Name", nil);
    self.passWordLB.text = NSLocalizedString(@"Password Setting", nil);
    self.repasWordLB.text = NSLocalizedString(@"Repeat Password", nil);
    [self.sureButton setTitle:NSLocalizedString(@"Confirm Add", nil) forState:UIControlStateNormal];
    self.pasWordTF.placeholder = NSLocalizedString(@"Case letters and numbers of not less than 8 digits are required", nil);
    if (self.walletModel)
    {
        self.nameTF.text = self.walletModel.name;
        self.nameTF.userInteractionEnabled = NO;
    }
}

- (IBAction)sureAddButtonCilick:(id)sender
{
    //确认添加
    if (self.nameTF.text.length == 0)
    {
        [LCProgressHUD showMessage:@"请输入钱包名称"];
        return;
    }
    
    if (![NSString isPassword:self.pasWordTF.text] || ![self.pasWordTF.text isEqualToString:self.rePasWordTF.text])
    {
        [LCProgressHUD showMessage:@"请输入至少存在一个大写、小写字母、数字8位数以上的密码"];
        return;
    }
    
    if (self.ETHWallet)
    {
        //导入钱包
        if ([UserSignData share].user.isCode)
        {
            //冷钱包不上传
            WalletLeftListModel * model = [[WalletLeftListModel alloc] init];
            model.name = self.nameTF.text;
            model.category_name = @"ETH";
            model.isNotBackupsWallet = YES;
            model.address = [[[self.ETHWallet address] lowercaseString] lowercaseString];
            int y = 1 +  (arc4random() % 11);
            model.img = [NSString stringWithFormat:@"钱包头像%d",y];
            //本分本地
            NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
            [parametersDic setObject:[[[self.ETHWallet address] lowercaseString] lowercaseString] forKey:@"address"];
            [parametersDic setObject:self.nameTF.text forKey:@"name"];
            [parametersDic setObject:self.model.name forKey:@"category_name"];
            if ([NSString isNulllWithObject:[UserSignData share].user.codeWalletsArray])
            {
                [UserSignData share].user.codeWalletsArray = [[NSMutableArray alloc] init];
            }
            [[UserSignData share].user.codeWalletsArray addObject:parametersDic];
            [[UserSignData share] storageData:[UserSignData share].user];
            //完成创建跳转回钱包详情
            [self.navigationController popToRootViewControllerAnimated:NO];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"AddWalletSucessPushWalletInfoNotification" object:model userInfo:nil]];
        }
        else
        {
            //热钱包导入完成，上传数据
            if (self.walletModel)
            {
                //转化
                NSError * error;
                NSData * data = [self.ETHWallet encrypt:self.pasWordTF.text error:&error];
                
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                //异步返回主线程，根据获取的数据，更新UI
                dispatch_async(mainQueue, ^
                               {
                                   if (!error)
                                   {
                                       [LCProgressHUD hide];
                                       //4.获取钱包地址
                                       NSString * address = [[self.ETHWallet address] lowercaseString];
                                       //5.存入keyChain
                                       [PDKeyChain save:address data:data];
                                       [LCProgressHUD showMessage:@"转化成功"];
                                       self.walletModel.isLookWallet = NO;
                                       self.walletModel.isNotBackupsWallet = YES;
                                       [self.navigationController popToRootViewControllerAnimated:NO];
                                       [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"AddWalletSucessPushWalletInfoNotification" object:self.walletModel userInfo:nil]];
                                   }
                                   else
                                   {
                                       [LCProgressHUD hide];
                                       [LCProgressHUD showMessage:@"钱包加密失败，请稍后重试"];
                                   }
                                   
                               });
            }
            else
            {
                //导入
                NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
                [parametersDic setObject:@(self.model.id) forKey:@"category_id"];
                [parametersDic setObject:self.nameTF.text forKey:@"name"];
                [parametersDic setObject:[[self.ETHWallet address] lowercaseString] forKey:@"address"];
                
                [PPNetworkHelper POST:@"wallet" parameters:parametersDic hudString:@"创建中..." success:^(id responseObject)
                 {
                     WalletLeftListModel * model = [[WalletLeftListModel alloc] initWithDictionary:[responseObject objectForKey:@"record"]];
                     int y = 1 +  (arc4random() % 11);
                     model.img = [NSString stringWithFormat:@"钱包头像%d",y];
                     model.isLookWallet = NO;
                     model.isNotBackupsWallet = YES;
                     //完成创建跳转回钱包详情
                     [self.navigationController popToRootViewControllerAnimated:NO];
                     //发送消息
                     [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"AddWalletSucessPushWalletInfoNotification" object:model userInfo:nil]];
                     
                 } failure:^(NSString *error)
                 {
                     [LCProgressHUD showFailure:error];
                 }];
            }
        }
        
    }
    else
    {
        //生成新钱包
        [LCProgressHUD showLoading:@"创建中..."];
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue, ^
                       {
                           //子线程异步执行下载任务，防止主线程卡顿
                           //1.UnichainNewETHWallet 创建一个钱包，这个钱包现在是内存里面的钱包。
                           NSError * error;
                           self.ETHWallet = UnichainNewETHWallet(&error);
                           
                           dispatch_queue_t mainQueue = dispatch_get_main_queue();
                           //异步返回主线程，根据获取的数据，更新UI
                           dispatch_async(mainQueue, ^
                                          {
                                              //2.然后调用钱包上的方法 mnemonic 生成助记词。
                                              if (!error)
                                              {
                                                  [LCProgressHUD hide];
                                                  NSError * error;
                                                  self.mnemonicStr = [self.ETHWallet mnemonic:&error];
                                                  if (!error)
                                                  {
                                                      //提醒助记词
//                                                      [self showAlert];
                                                      [self sureButtonCilick];
                                                  }
                                                  else
                                                  {
                                                      [LCProgressHUD showMessage:@"助记词生成失败，请稍后重试"];
                                                  }
                                              }
                                              else
                                              {
                                                  [LCProgressHUD hide];
                                                  [LCProgressHUD showMessage:@"暂时无法创建钱包，请稍后重试"];
                                              }
                                              
                                          });
                           
                       });
    }
}

- (void)showAlert
{
    self.alertView.alertContInfoLB.text = NSLocalizedString(@"Please keep in mind the following account security code, which is the effective way to retrieve the wallet, the wallet is once forgot to be able to retrieve account failure, please remember the security code and copied down, no longer appear this operation is not reversible and backup", nil);
    [self.alertView.alertSureButton setTitle:NSLocalizedString(@"I remember", nil) forState:UIControlStateNormal];
    self.alertView.alertTextView.text = self.mnemonicStr;
    self.alertView.alertTextView.userInteractionEnabled = NO;
    [self.alertView showWithView:nil];
}

- (void)sureButtonCilick
{
    //记好了
    [LCProgressHUD showLoading:@"创建中..."];
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^
                   {
                       //子线程异步执行下载任务，防止主线程卡顿
                       //3.然后调用 encrypt 方法生成json数据，这个你要保持在keychain里面。
                       NSError * error;
                       NSData * data = [self.ETHWallet encrypt:self.pasWordTF.text error:&error];
                       
                       dispatch_queue_t mainQueue = dispatch_get_main_queue();
                       //异步返回主线程，根据获取的数据，更新UI
                       dispatch_async(mainQueue, ^
                                      {
                                          if (!error)
                                          {
                                              [LCProgressHUD hide];
                                              //4.获取钱包地址
                                              NSString * address = [[self.ETHWallet address] lowercaseString];
                                              //5.存入keyChain
                                              [PDKeyChain save:address data:data];
                                              
                                              if ([UserSignData share].user.isCode)
                                              {
                                                  //冷钱包不上传
                                                  WalletLeftListModel * model = [[WalletLeftListModel alloc] init];
                                                  model.name = self.nameTF.text;
                                                  model.category_name = @"ETH";
                                                  model.address = [[self.ETHWallet address] lowercaseString];
                                                  model.isNotBackupsWallet = YES;
                                                  int y = 1 +  (arc4random() % 11);
                                                  model.img = [NSString stringWithFormat:@"钱包头像%d",y];
                                                  //本分本地
                                                  NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
                                                  [parametersDic setObject:[[self.ETHWallet address] lowercaseString] forKey:@"address"];
                                                  [parametersDic setObject:self.nameTF.text forKey:@"name"];
                                                  [parametersDic setObject:self.model.name forKey:@"category_name"];
                                                  if ([NSString isNulllWithObject:[UserSignData share].user.codeWalletsArray])
                                                  {
                                                      [UserSignData share].user.codeWalletsArray = [[NSMutableArray alloc] init];
                                                  }
                                                  [[UserSignData share].user.codeWalletsArray addObject:parametersDic];
                                                  [[UserSignData share] storageData:[UserSignData share].user];
                                                  //完成创建跳转回钱包详情
                                                  [self.navigationController popToRootViewControllerAnimated:NO];
                                                  //发送消息
                                                  [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"AddWalletSucessPushWalletInfoNotification" object:model userInfo:nil]];
                                              }
                                              else
                                              {
                                                  //钱包创建完成，上传数据
                                                  NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
                                                  [parametersDic setObject:@(self.model.id) forKey:@"category_id"];
                                                  [parametersDic setObject:self.nameTF.text forKey:@"name"];
                                                  [parametersDic setObject:address forKey:@"address"];
                                                  
                                                  [PPNetworkHelper POST:@"wallet" parameters:parametersDic hudString:@"创建中..." success:^(id responseObject)
                                                   {
                                                       WalletLeftListModel * model = [[WalletLeftListModel alloc] initWithDictionary:[responseObject objectForKey:@"record"]];
                                                       AddWalletSucessVC * vc = [[AddWalletSucessVC alloc] init];
                                                       model.category_name = @"ETH";
                                                       int y = 1 +  (arc4random() % 11);
                                                       model.isNotBackupsWallet = YES;
                                                       model.img = [NSString stringWithFormat:@"钱包头像%d",y];
                                                       vc.model = model;
                                                       //完成创建跳转回钱包详情
                                                       [self.navigationController popToRootViewControllerAnimated:NO];
                                                       //发送消息
                                                       [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"AddWalletSucessPushWalletInfoNotification" object:model userInfo:nil]];
                                                       
                                                   } failure:^(NSString *error)
                                                   {
                                                       [LCProgressHUD showFailure:error];
                                                   }];
                                              }
                                          }
                                          else
                                          {
                                              [LCProgressHUD hide];
                                              [LCProgressHUD showMessage:@"钱包加密失败，请稍后重试"];
                                          }
                                          
                                      });
                       
                   });
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
