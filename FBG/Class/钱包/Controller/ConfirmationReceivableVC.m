//
//  ConfirmationReceivableVC.m
//  FBG
//
//  Created by mac on 2017/7/19.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "ConfirmationReceivableVC.h"

@interface ConfirmationReceivableVC ()

@property (weak, nonatomic) IBOutlet UILabel *priceNameTiLB;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressTiLB;
@property (weak, nonatomic) IBOutlet UILabel *remarksTiLB;

@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *priceChangeLB;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UILabel *remarksLB;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLB;

@end

@implementation ConfirmationReceivableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Receipt Confirmation", nil);
    
    self.priceNameTiLB.text = NSLocalizedString(@"Transfer amount", nil);
    self.priceChangeLB.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Additional service charge:", nil),@"0.0000000"];
    self.walletAddressTiLB.text = NSLocalizedString(@"Transfer wallet address", nil);
    self.remarksTiLB.text = NSLocalizedString(@"Remarks", nil);
    self.orderNumLB.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Order number:", nil),@"THC987899"];
}



@end
