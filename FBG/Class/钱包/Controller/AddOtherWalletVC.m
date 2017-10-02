//
//  AddOtherWalletVC.m
//  FBG
//
//  Created by mac on 2017/7/27.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddOtherWalletVC.h"
#import "AddOtherWalletInfoVC.h"

@interface AddOtherWalletVC ()

@property (weak, nonatomic) IBOutlet UILabel *securityLB;
@property (weak, nonatomic) IBOutlet UILabel *privateKeyLB;
@property (weak, nonatomic) IBOutlet UILabel *observationLB;
@property (weak, nonatomic) IBOutlet UILabel *seedLB;

@end

@implementation AddOtherWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Import Wallet", nil);
    self.securityLB.text = NSLocalizedString(@"Safety Code", nil);
    self.privateKeyLB.text = NSLocalizedString(@"Private Key", nil);
    self.observationLB.text = NSLocalizedString(@"Observation", nil);
    self.seedLB.text = NSLocalizedString(@"Seed", nil);
}

- (IBAction)KeystoreButtonCilick:(id)sender
{
    //Keystore
    [self pushVCwithType:1];
}

- (IBAction)securityButtonCilick:(id)sender
{
    //安全
    [self pushVCwithType:2];
}

- (IBAction)privateKeyButtonCilick:(id)sender
{
    //私匙
    [self pushVCwithType:3];
}

- (IBAction)observationButtonCilick:(id)sender
{
    //观察
    if ([UserSignData share].user.isCode)
    {
        [LCProgressHUD showMessage:@"冷钱包不能导入"];
        return;
    }
    if (self.islookWallet)
    {
        [LCProgressHUD showMessage:@"已经是观察钱包了"];
        return;
    }
    [self pushVCwithType:4];
}

- (IBAction)seedButtonCilick:(id)sender
{
    //种子
    [self pushVCwithType:5];
}

- (void)pushVCwithType:(int)type
{
    AddOtherWalletInfoVC * vc = [[AddOtherWalletInfoVC alloc] init];
    vc.type = type;
    vc.model = self.model;
    vc.walletModel = self.walletModel;
    vc.islookWallet = self.islookWallet;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
