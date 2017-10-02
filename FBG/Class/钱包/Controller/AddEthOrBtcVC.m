//
//  AddEthOrBtcVC.m
//  FBG
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddEthOrBtcVC.h"
#import "AddWalletInfoVC.h"

@interface AddEthOrBtcVC ()

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation AddEthOrBtcVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.model.name isEqualToString:@"ETH"])
    {
        //ETH
        self.typeImage.image = [UIImage imageNamed:@"ETH_pic_add"];
    }
    else if ([self.model.name isEqualToString:@"BTC"])
    {
        //BTC
        self.typeImage.image = [UIImage imageNamed:@"BTC_pic_add"];
    }
    self.title = NSLocalizedString(@"Add Wallet", nil);
    [self.sureButton setTitle:NSLocalizedString(@"Add New Wallet", nil) forState:UIControlStateNormal];
}

- (IBAction)addButtonCilick:(id)sender
{
    //添加新钱包
    AddWalletInfoVC * vc = [[AddWalletInfoVC alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
