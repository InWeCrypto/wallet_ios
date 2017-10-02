//
//  WalletNameVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/10.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "WalletNameVC.h"
#import "WalletLeftListModel.h"

@interface WalletNameVC ()
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation WalletNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Add Wallet", nil);
    self.nameLB.text = NSLocalizedString(@"Wallet Name", nil);
}

- (IBAction)sureButtonCilick:(id)sender
{
    //确认添加
    if (self.nameTF.text.length == 0)
    {
        [LCProgressHUD showMessage:@"请输入钱包名称"];
        return;
    }
    
    if ([UserSignData share].user.isCode)
    {
        //冷钱包不上传
        WalletLeftListModel * model = [[WalletLeftListModel alloc] init];
        model.name = self.nameTF.text;
        model.address = [[self.wallet address] lowercaseString];
        model.category_name = @"ETH";
        model.isNotBackupsWallet = YES;
        int y = 1 +  (arc4random() % 11);
        model.img = [NSString stringWithFormat:@"钱包头像%d",y];
        //本分本地
        NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
        [parametersDic setObject:[[self.wallet address] lowercaseString] forKey:@"address"];
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
        //热钱包上传
        NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
        [parametersDic setObject:@(self.model.id) forKey:@"category_id"];
        [parametersDic setObject:self.nameTF.text forKey:@"name"];
        [parametersDic setObject:self.model.name forKey:@"category_name"];
        [parametersDic setObject:self.address ? self.address : [[self.wallet address] lowercaseString] forKey:@"address"];
        
        [PPNetworkHelper POST:@"wallet" parameters:parametersDic hudString:@"创建中..." success:^(id responseObject)
         {
             WalletLeftListModel * model = [[WalletLeftListModel alloc] initWithDictionary:[responseObject objectForKey:@"record"]];
             if (self.address)
             {
                 model.isLookWallet = YES;
             }
             else
             {
                 model.isNotBackupsWallet = YES;
             }
             int y = 1 +  (arc4random() % 11);
             model.img = [NSString stringWithFormat:@"钱包头像%d",y];
             model.category_name = @"ETH";
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

@end
