//
//  AddWalletSucessVC.m
//  FBG
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddWalletSucessVC.h"

@interface AddWalletSucessVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *sucessLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation AddWalletSucessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Add Wallet", nil);
    
    if ([self.model.category_name isEqualToString:@"ETH"])
    {
        //ETH
        self.headImage.image = [UIImage imageNamed:@"ETH_pic_sucess"];
    }
    else if ([self.model.category_name isEqualToString:@"BTC"])
    {
        //BTC
        self.headImage.image = [UIImage imageNamed:@"BTC_pic_sucess"];
    }
    self.sucessLB.text = NSLocalizedString(@"Add Success", nil);
    self.infoLB.text = NSLocalizedString(@"Please enter the wallet in time and backup the seed to ensure the safety of the wallet. Once the seed is backed up, it will disappear on the APP. It should be kept in mind, otherwise the wallet can not be retrieved", nil);
    [self.sureButton setTitle:NSLocalizedString(@"Enter The Wallet And Start Backup", nil) forState:UIControlStateNormal];
}

- (IBAction)sureButtonCilick:(id)sender
{
    //完成创建跳转回钱包详情
    [self.navigationController popToRootViewControllerAnimated:NO];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"AddWalletSucessPushWalletInfoNotification" object:self.model userInfo:nil]];
}


@end
