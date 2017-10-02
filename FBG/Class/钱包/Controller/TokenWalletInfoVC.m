//
//  LookWalletInfoVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "TokenWalletInfoVC.h"
#import "ReceivablesVC.h"
#import "TransactionRecordVC.h"
#import "TransferVC.h"
#import "AddOtherWalletVC.h"

@interface TokenWalletInfoVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *walletStatusLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *receivablesButton;
@property (weak, nonatomic) IBOutlet UIButton *transactionButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UILabel *addTiLB;
@property (weak, nonatomic) IBOutlet UILabel *scanTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *receiptTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *recordTitleLB;

@property (nonatomic, copy) NSString * banlacePrice;


@end

@implementation TokenWalletInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Wallet Details", nil);
    
    self.addTiLB.text = NSLocalizedString(@"Wallet Address", nil);
    self.scanTitleLB.text = NSLocalizedString(@"Scan", nil);
    self.receiptTitleLB.text = NSLocalizedString(@"Receivables", nil);
    self.recordTitleLB.text = NSLocalizedString(@"Transaction Record", nil);
    
    self.walletStatusLB.text = @"代币";
    self.deleteButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    
    //代币详情
    [self.headImage sdsetImageWithURL:self.tokenModel.icon placeholderImage:Default_General_Image];
    self.titleLB.text = self.tokenModel.name;
    self.addressLB.text = self.tokenModel.address;
//    double ether = (double)[[NSString numberHexString:[self.tokenModel.balance substringFromIndex:2]] longLongValue] / 1000000000000000000;
    self.priceLB.text = self.tokenModel.balance;
    if ([UserSignData share].user.walletUnitType == 1)
    {
        self.infoLB.text = [NSString stringWithFormat:@"￥%@",[NSString DecimalFuncWithOperatorType:2 first:self.tokenModel.balance secend:self.tokenModel.price_cny value:2]];
    }
    else
    {
        self.infoLB.text = [NSString stringWithFormat:@"$%@",[NSString DecimalFuncWithOperatorType:2 first:self.tokenModel.balance secend:self.tokenModel.price_usd value:2]];
    }
    
    
}

- (void)loadData
{
    //代币余额
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.model.address forKey:@"address"];
    [dic setObject:self.tokenModel.address forKey:@"contract"];
    
    [PPNetworkHelper POST:@"extend/balanceOf" parameters:dic hudString:@"加载中..." success:^(id responseObject)
     {
         NSString * price = [[responseObject objectForKey:@"value"] substringFromIndex:2];
         self.banlacePrice = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:price] secend:@"1000000000000000000" value:4];
         
         self.priceLB.text = [NSString stringWithFormat:@"%.2f",[self.banlacePrice floatValue]];
         if ([UserSignData share].user.walletUnitType == 1)
         {
             self.infoLB.text = [NSString stringWithFormat:@"≈￥%.2f",[[NSString DecimalFuncWithOperatorType:2 first:self.banlacePrice secend:self.tokenModel.price_cny value:2] floatValue]];
         }
         else
         {
             self.infoLB.text = [NSString stringWithFormat:@"≈$%.2f",[[NSString DecimalFuncWithOperatorType:2 first:self.banlacePrice secend:self.tokenModel.price_usd value:2] floatValue]];
         }
         

     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
    
}

- (IBAction)scanButtonCilick:(id)sender
{
    //转账

    TransferVC * vc = [[TransferVC alloc] init];
    vc.model = self.model;
    vc.tokenModel = self.tokenModel;
    vc.banlacePrice = _banlacePrice;
    vc.walletBanlacePrice = self.WalletbanlacePrice;
    vc.defaultGasNum = self.tokenModel.gas;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)receivalesButtonCilick:(id)sender
{
    //收款
    ReceivablesVC * vc = [[ReceivablesVC alloc] init];
    vc.tokenModel = self.tokenModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)transactionButtonCilick:(id)sender
{
    //交易记录
    TransactionRecordVC  * vc = [[TransactionRecordVC alloc] init];
    vc.model = self.model;
    vc.tokenModel = self.tokenModel;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
