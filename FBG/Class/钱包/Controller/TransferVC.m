//
//  TransferVC.m
//  FBG
//
//  Created by mac on 2017/7/19.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "TransferVC.h"
#import "ConfirmationTransferVC.h"
#import "SystemConvert.h"
#import "MailListVC.h"
#import "MailMdel.h"
#import "ScanVC.h"

@interface TransferVC () <MailListDelegate, ScanVCDelegate>

@property (weak, nonatomic) IBOutlet UILabel *addressTiLB;
@property (weak, nonatomic) IBOutlet UILabel *priceTiLB;
@property (weak, nonatomic) IBOutlet UILabel *GASTiLB;
@property (weak, nonatomic) IBOutlet UILabel *slowLB;
@property (weak, nonatomic) IBOutlet UILabel *fastLB;
@property (weak, nonatomic) IBOutlet UILabel *remarksLB;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *banlaceLB;

@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UITextField *remarksTF;
@property (weak, nonatomic) IBOutlet UISlider *gasSlider;

//转账订单生产
@property (nonatomic, copy) NSString * gasPrice;   //手续费单价
@property (nonatomic, copy) NSString * totleGasPrice;       //总手续费
@property (nonatomic, copy) NSString * nonce;       

@end

@implementation TransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Transfer Accounts", nil);
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_scan"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.addressTiLB.text = NSLocalizedString(@"Transfer wallet address", nil);
    self.addressTF.placeholder = NSLocalizedString(@"Please enter a transfer address", nil);
    self.priceTiLB.text = NSLocalizedString(@"Transfer amount", nil);
    self.GASTiLB.text = NSLocalizedString(@"GASCost", nil);
    self.slowLB.text = NSLocalizedString(@"Slow", nil);
    self.fastLB.text = NSLocalizedString(@"Fast", nil);
    self.remarksLB.text = NSLocalizedString(@"Remarks", nil);
    self.remarksTF.placeholder = NSLocalizedString(@"Please input remarks", nil);
    [self.sureButton setTitle:NSLocalizedString(@"Determine", nil) forState:UIControlStateNormal];
    
    self.banlaceLB.text = [NSString stringWithFormat:@"(当前余额:%@)",self.banlacePrice];
    
    
    NSString * min = [NSString DecimalFuncWithOperatorType:2
                                                    first:[NSString DecimalFuncWithOperatorType:3
                                                                                          first:[NSString DecimalFuncWithOperatorType:2 first:@"0.00002520" secend:@"1000000000000000000" value:8]
                                                                                         secend:@"21000"
                                                                                          value:8]
                                                   secend:@"90000"
                                                    value:8];
    NSString * max = [NSString DecimalFuncWithOperatorType:2
                                                     first:[NSString DecimalFuncWithOperatorType:3
                                                                                           first:[NSString DecimalFuncWithOperatorType:2 first:@"0.00252012" secend:@"1000000000000000000" value:8]
                                                                                          secend:@"21000"
                                                                                           value:8]
                                                    secend:@"90000"
                                                     value:8];
    self.gasSlider.minimumValue = [[NSString DecimalFuncWithOperatorType:3 first:[NSString stringWithFormat:@"%@",min] secend:@"1000000000000000000" value:8] floatValue];
    self.gasSlider.maximumValue = [[NSString DecimalFuncWithOperatorType:3 first:[NSString stringWithFormat:@"%@",max] secend:@"1000000000000000000" value:8] floatValue];
    self.gasSlider.continuous = YES;// 设置可连续变化
    
    if (!self.defaultGasNum)
    {
        self.defaultGasNum = 90000;
    }
    [self loadWalletData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadWalletData
{
    //获取gas单价价格
    [PPNetworkHelper POST:@"extend/getGasPrice" parameters:nil hudString:@"获取中..." success:^(id responseObject)
     {
         NSString * per = @"0";
         if (![NSString isNulllWithObject:responseObject])
         {
             //获取单价
             per = [[responseObject objectForKey:@"gasPrice"] substringFromIndex:2];
         }

         self.gasPrice = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:per] secend:@"1000000000000000000" value:8];
         self.totleGasPrice = [NSString DecimalFuncWithOperatorType:2 first:self.gasPrice secend:[NSString stringWithFormat:@"%d",self.defaultGasNum] value:8];
         self.priceLB.text = self.totleGasPrice;
         
         [self.gasSlider setValue:[self.totleGasPrice floatValue]];
         
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
    
    //获取交易次数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.model.address forKey:@"address"];
    
    [PPNetworkHelper POST:@"extend/getTransactionCount" parameters:dic hudString:@"获取中..." success:^(id responseObject)
     {
         // nonce 参数
         if (![NSString isNulllWithObject:[responseObject objectForKey:@"count"]])
         {
             self.nonce = [responseObject objectForKey:@"count"];
         }
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
}

// 地址填
- (void)scanSucessWithObject:(id)object
{
    //扫一扫成功代理
    self.addressTF.text = object;
}

- (void)choasePersonWithData:(id)data
{
    //通讯录获取代理
    MailMdel * model = data;
    self.addressTF.text = model.address;
}

- (void)rightButton
{
    //扫一扫 获得地址
    ScanVC * vc = [[ScanVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)mailListButtonCilick:(id)sender
{
    //通讯录  选取好友地址
    MailListVC * vc = [[MailListVC alloc] init];
    vc.delegate = self;
    vc.isChose = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)slider:(id)sender
{
    //滑块  0.00002520   ~  0.00252012    * 21000 单位
    if ((long)(self.gasSlider.value * 100000000) % 5 == 0)
    {
        self.gasPrice = [NSString DecimalFuncWithOperatorType:3 first:[NSString stringWithFormat:@"%f",self.gasSlider.value] secend:[NSString stringWithFormat:@"%d",self.defaultGasNum] value:0];
        self.totleGasPrice = [NSString stringWithFormat:@"%f",self.gasSlider.value];
        self.priceLB.text = self.totleGasPrice;
    }
}

- (IBAction)sureButtonCilick:(id)sender
{
    //确定
    
    if (![NSString isAdress:[self.addressTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]])
    {
        [LCProgressHUD showMessage:@"请输入正确的钱包地址"];
        return;
    }
    if (self.nonce.length == 0)
    {
        [LCProgressHUD showMessage:@"暂未获取到交易次数。请稍后再试"];
        return;
    }
    if (self.priceTF.text.length == 0)
    {
        [LCProgressHUD showMessage:@"请输入价格"];
        return;
    }
    NSString * priceWeiValue = [NSString DecimalFuncWithOperatorType:2 first:self.priceTF.text secend:@"1000000000000000000" value:8];
    NSString * gasPriceWeiValue = [NSString DecimalFuncWithOperatorType:2 first:self.gasPrice secend:@"1000000000000000000" value:8];
    NSString * totleGasPriceWeiValue = [NSString DecimalFuncWithOperatorType:2 first:gasPriceWeiValue secend:@"90000" value:8];
    
    NSString * duibiPriceWeiValue = [NSString DecimalFuncWithOperatorType:0 first:priceWeiValue secend:totleGasPriceWeiValue value:8];
    NSString * banlacePriceWeiValue = [NSString DecimalFuncWithOperatorType:2 first:self.banlacePrice secend:@"1000000000000000000" value:8];
    if (self.tokenModel)
    {
        //代币判断余额   手续费 <= ether钱包余额    转账金额 <= 代币余额
        if (self.priceTF.text.length == 0)
        {
            [LCProgressHUD showMessage:@"请输入正确价格"];
            return;
        }
        
        NSComparisonResult result = [NSString DecimalFuncComparefirst:priceWeiValue secend:[NSString DecimalFuncWithOperatorType:2 first:self.banlacePrice secend:@"1000000000000000000" value:8]];
        if (result ==NSOrderedDescending)
        {
            [LCProgressHUD showMessage:@"代币余额不足"];
            return;
        }
        
        NSComparisonResult result1 = [NSString DecimalFuncComparefirst:totleGasPriceWeiValue secend:[NSString DecimalFuncWithOperatorType:2 first:self.walletBanlacePrice secend:@"1000000000000000000" value:8]];
        if (result1 ==NSOrderedDescending)
        {
            [LCProgressHUD showMessage:@"钱包余额不足"];
            return;
        }
    }
    else
    {
        //钱包余额判断   手续费 + 转账金额 <= ether钱包余额
        if (self.priceTF.text.length == 0)
        {
            [LCProgressHUD showMessage:@"请输入正确价格"];
            return;
        }
        
        NSComparisonResult result = [NSString DecimalFuncComparefirst:duibiPriceWeiValue secend:banlacePriceWeiValue];
        if (result == NSOrderedDescending)
        {
            [LCProgressHUD showMessage:@"钱包余额不足"];
            return;
        }
    }
    
    ConfirmationTransferVC * vc = [[ConfirmationTransferVC alloc] init];
    vc.totleGasPrice = self.totleGasPrice;
    vc.gasprice = self.gasPrice;
    vc.nonce = self.nonce;
    vc.price = self.priceTF.text;
    vc.address = [self.addressTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    vc.remark = self.remarksTF.text;
    vc.model = self.model;
    vc.tokenModel = self.tokenModel;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
