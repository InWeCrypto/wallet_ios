//
//  ConfirmationTransferVC.m
//  FBG
//
//  Created by mac on 2017/7/19.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "ConfirmationTransferVC.h"
#import "SystemConvert.h"
#import "TransactionInfoVC.h"
#import "WalletOrderModel.h"
#import "LookWalletCodeView.h"
#import "CodeWalletCodeView.h"
#import <CoreImage/CoreImage.h>
#import "ScanVC.h"


@interface ConfirmationTransferVC () <PassWordViewDelegate, LookWalletCodeViewDelegate, ScanVCDelegate, CodeWalletCodeViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *priceNameTiLB;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressTiLB;
@property (weak, nonatomic) IBOutlet UILabel *remeaksTiLB;

@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *serviceChargeLB;
@property (weak, nonatomic) IBOutlet UIButton *transferButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UILabel *remarkLB;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;

@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) PassWordView * password;
@property (nonatomic, strong) LookWalletCodeView * lookWalletCodeView;
@property (nonatomic, strong) CodeWalletCodeView * codeWalletCodeView;
@property (nonatomic, assign) BOOL isCodeWalletSucess;      //观察钱包转账冷钱包扫描完成已完成
@property (nonatomic, copy) NSString * data;

@end

@implementation ConfirmationTransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Transfer Confirmation", nil);
    self.priceNameTiLB.text = NSLocalizedString(@"Transfer amount", nil);
    self.serviceChargeLB.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Additional service charge:", nil),self.totleGasPrice];
    self.walletAddressTiLB.text = NSLocalizedString(@"Transfer wallet address", nil);
    self.remeaksTiLB.text = NSLocalizedString(@"Remarks", nil);
    [self.transferButton setTitle:NSLocalizedString(@"Transfer Account", nil) forState:UIControlStateNormal];
    
    self.priceLB.text = [NSString stringWithFormat:@"%.4f",[self.price floatValue]];
    self.addressLB.text = self.address;
    self.remarkLB.text = self.remark;
    
    self.statusLB.hidden = !self.isCodeWalletSucess;
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
    //取消支付
    [self caneButtonClicked];
}

- (void)sureWithPassWord:(NSString *)passWord
{
    //确认支付
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
                                              if (self.tokenModel)
                                              {
                                                  //代币钱包转账
                                                  if (self.isCodeWallet)
                                                  {
                                                      //冷钱包进入 转账后生成二维码转给观察钱包
                                                      //生成data
                                                      NSError * error;
                                                      
                                                      NSData * data = [Wallet transferToken:self.nonce
                                                                             gasPriceString:self.ox_gas
                                                                             gasLimitString:self.gas_limit
                                                                                   contract:self.address
                                                                                       data:[self.ox_Price dataUsingEncoding:NSUTF8StringEncoding]
                                                                                      error:&error];
                                                      
                                                      dispatch_queue_t mainQueue = dispatch_get_main_queue();
                                                      //异步返回主线程，根据获取的数据，更新UI
                                                      dispatch_async(mainQueue, ^
                                                                     {
                                                                         if (!error)
                                                                         {
                                                                             [LCProgressHUD hide];
                                                                             [self caneButtonClicked];
                                                                             [LCProgressHUD showMessage:@"转账成功"];
                                                                             
                                                                             //冷钱包
                                                                             [self creatCIQRCodeImageWithString:[NSString stringWithFormat:@"0x%@",[NSString convertDataToHexStr:data]]];
                                                                             [self.codeWalletCodeView showWithView:nil];
                                                                         }
                                                                         else
                                                                         {
                                                                             [LCProgressHUD hide];
                                                                             [self caneButtonClicked];
                                                                             [LCProgressHUD showMessage:@"转账失败，请稍后重试"];
                                                                         }
                                                                     });
                                                      
                                                      
                                                  }
                                                  else
                                                  {
                                                      //热钱包代币转账
                                                      NSString * price = [NSString stringWithFormat:@"0x%@",[SystemConvert decimalToHex:[[NSString stringWithFormat:@"%.0f000000000000",[self.price floatValue] * 1000000] longLongValue]]];
                                                      NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
                                                      [parametersDic setObject:self.tokenModel.address forKey:@"contract"];
                                                      [parametersDic setObject:self.address forKey:@"to"];
                                                      [parametersDic setObject:price forKey:@"value"];
                                                      
                                                      [PPNetworkHelper POST:@"extend/transferABI" parameters:parametersDic hudString:@"加载中..." success:^(id responseObject)
                                                       {
                                                           //生成data
                                                           NSError * error;
                                                           NSString * gas = [SystemConvert decimalToHex:[SystemConvert decimalToHex:[NSString stringWithFormat:@"%ld",(long)[[NSString DecimalFuncWithOperatorType:2 first:self.gasprice secend:@"1000000000000000000" value:0] integerValue]]]];
                                                           
                                                           NSData * data = [Wallet transferToken:self.nonce
                                                                                  gasPriceString:[NSString stringWithFormat:@"0x%@",gas]
                                                                                  gasLimitString:[NSString stringWithFormat:@"0x%@",[NSString getHexByDecimal:self.tokenModel.gas]]
                                                                                        contract:self.tokenModel.address
                                                                                            data:[[responseObject objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                                           error:&error];
                                                           
                                                           dispatch_queue_t mainQueue = dispatch_get_main_queue();
                                                           //异步返回主线程，根据获取的数据，更新UI
                                                           dispatch_async(mainQueue, ^
                                                                          {
                                                                              if (!error)
                                                                              {
                                                                                  [LCProgressHUD hide];
                                                                                  [self caneButtonClicked];
                                                                                  [LCProgressHUD showMessage:@"转账成功"];
                                                                                  
                                                                                  //热钱包生成订单
                                                                                  [self creatOrderWithData:[NSString stringWithFormat:@"0x%@",[NSString hexStringFromData:data]]];
                                                                              }
                                                                              else
                                                                              {
                                                                                  [LCProgressHUD hide];
                                                                                  [self caneButtonClicked];
                                                                                  [LCProgressHUD showMessage:@"转账失败，请稍后重试"];
                                                                              }
                                                                          });
                                                           
                                                       } failure:^(NSString *error)
                                                       {
                                                           [LCProgressHUD hide];
                                                           [self caneButtonClicked];
                                                           [LCProgressHUD showFailure:error];
                                                       }];
                                                  }
                                              }
                                              else
                                              {
                                                  //普通钱包转账
                                                  //子线程异步执行下载任务，防止主线程卡顿
                                                  NSError * error;
                                                  NSString * price = [SystemConvert decimalToHex:[[NSString stringWithFormat:@"%.0f000000000000",[self.price floatValue] * 1000000] longLongValue]];
                                                  NSString * gas = [SystemConvert decimalToHex:[NSString stringWithFormat:@"%ld",(long)[[NSString DecimalFuncWithOperatorType:2 first:self.gasprice secend:@"1000000000000000000" value:0] integerValue]]];
                                                  
                                                  NSData * data = [Wallet transferCurrency:self.nonce
                                                                            gasPriceString:self.isCodeWallet ? self.ox_gas : [NSString stringWithFormat:@"0x%@",[gas lowercaseString]]
                                                                            gasLimitString:@"0x66c81"
                                                                                        to:self.address
                                                                              amountString:self.isCodeWallet ? self.ox_Price : [NSString stringWithFormat:@"0x%@",price]
                                                                                     error:&error];
                                                  
                                                  dispatch_queue_t mainQueue = dispatch_get_main_queue();
                                                  //异步返回主线程，根据获取的数据，更新UI
                                                  dispatch_async(mainQueue, ^
                                                                 {
                                                                     if (!error)
                                                                     {
                                                                         [LCProgressHUD hide];
                                                                         [self caneButtonClicked];
                                                                         [LCProgressHUD showMessage:@"转账成功"];
                                                                         
                                                                         if (self.isCodeWallet)
                                                                         {
                                                                             //冷钱包进入 转账后生成二维码转给观察钱包
                                                                             [self creatCIQRCodeImageWithString:[NSString stringWithFormat:@"0x%@",[NSString convertDataToHexStr:data]]];
                                                                             [self.codeWalletCodeView showWithView:nil];
                                                                         }
                                                                         else
                                                                         {
                                                                             //热钱包生成订单
                                                                             [self creatOrderWithData:[NSString stringWithFormat:@"0x%@",[NSString hexStringFromData:data]]];
                                                                         }
                                                                     }
                                                                     else
                                                                     {
                                                                         [LCProgressHUD hide];
                                                                         [self caneButtonClicked];
                                                                         [LCProgressHUD showMessage:@"转账失败，请稍后重试"];
                                                                     }
                                                                 });
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
    
}

// 上传后台提交订单
- (void)creatOrderWithData:(NSString *)data
{
    //创建钱包订单
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(self.model.id) forKey:@"wallet_id"];
    [dic setObject:data forKey:@"data"];
    [dic setObject:self.model.address forKey:@"pay_address"];
    [dic setObject:self.address forKey:@"receive_address"];
    [dic setObject:self.remark forKey:@"remark"];
    [dic setObject:[NSString DecimalFuncWithOperatorType:2 first:self.price secend:@"1000000000000000000" value:0] forKey:@"fee"];
    [dic setObject:[NSString DecimalFuncWithOperatorType:2 first:self.totleGasPrice secend:@"1000000000000000000" value:0] forKey:@"handle_fee"];
    [dic setObject:self.tokenModel ? self.tokenModel.flag : self.model.category_name forKey:@"flag"];
    
    [PPNetworkHelper POST:@"wallet-order" parameters:dic hudString:@"创建中..." success:^(id responseObject)
     {
         //进入订单详情
         /*
          WalletOrderModel * model = [[WalletOrderModel alloc] initWithDictionary:dic];
          model.fee = self.price;
          model.handle_fee = self.totleGasPrice;
          model.created_at = [NSString nowDate];
          TransactionInfoVC * vc = [[TransactionInfoVC alloc] init];
          vc.isTransfer = YES;˜
          vc.model = model;
          vc.isNotPushWithList = YES;
          [self.navigationController pushViewController:vc animated:YES];
          */
         //返回转账列表
         [LCProgressHUD showMessage:@"订单创建成功"];
         [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
         
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:@"服务器内部错误"];
         [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
     }];
    /*
    //发送签名后的交易[post] extend/sendRawTransaction
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:data forKey:@"data"];
    
    [PPNetworkHelper POST:@"extend/sendRawTransaction" parameters:parametersDic hudString:@"转账中..." success:^(id responseObject)
     {
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
     */
}

- (void)scanSucessWithObject:(id)object
{
    //扫一扫成功回调 当前页面 添加转账成功标签
    self.isCodeWalletSucess = YES;
    self.statusLB.hidden = !self.isCodeWalletSucess;
    self.data = object;
}

- (void)LookWalletCodeViewsureButtonCilick
{
    //扫描二维码回调
    if (self.isCodeWallet)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        //下一步唤起扫一扫
        [self.lookWalletCodeView canel];
        ScanVC * vc = [[ScanVC alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)CodeWalletCodeViewsureButtonCilick
{
    //冷钱包二维码确认按钮
}

- (IBAction)transferButtonCilick:(id)sender
{
    //转账 唤起二维码弹窗
    if (self.isCodeWalletSucess)
    {
        //观察钱包扫描冷钱包成功
        [self creatOrderWithData:self.data];
        return;
    }

    if (self.model.isLookWallet)
    {
        //观察钱包转账
        NSString * price = [NSString stringWithFormat:@"0x%@",[SystemConvert decimalToHex:[[NSString stringWithFormat:@"%.0f000000000000",[self.price floatValue] * 1000000] longLongValue]]];
        NSString * gas = [NSString stringWithFormat:@"0x%@",[SystemConvert decimalToHex:[NSString stringWithFormat:@"%ld",(long)[[NSString DecimalFuncWithOperatorType:2 first:self.gasprice secend:@"1000000000000000000" value:0] integerValue]]]];
        if (self.tokenModel)
        {
            //钱包代币转账
            NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
            [parametersDic setObject:self.tokenModel.address forKey:@"contract"];
            [parametersDic setObject:self.address forKey:@"to"];
            [parametersDic setObject:price forKey:@"value"];
            
            [PPNetworkHelper POST:@"extend/transferABI" parameters:parametersDic hudString:@"加载中..." success:^(id responseObject)
            {
                //观察钱包生成二维码   钱包地址，nonce,十六进制的GAS单价，收款地址，十六进制的转账金额 备注
                NSDictionary * dic = @{
                                       @"wallet_address":self.model.address,
                                       @"nonce":self.nonce,
                                       @"ox_gas":gas,
                                       @"ox_price":[responseObject objectForKey:@"data"],
                                       @"transfer_address":self.tokenModel.address,
                                       @"show_price":self.price,
                                       @"show_gas":self.totleGasPrice,
                                       @"hit":self.remark,
                                       @"type":@"2",
                                       @"gas_limit":[NSString stringWithFormat:@"0x%@",[NSString getHexByDecimal:self.tokenModel.gas]]
                                       };
                [self creatCIQRCodeImageWithString:[dic toJSONStringForDictionary]];
                [self.lookWalletCodeView showWithView:nil];
                
            } failure:^(NSString *error)
            {
                [LCProgressHUD showFailure:error];
            }];
        }
        else
        {
            //观察钱包生成二维码   钱包地址，nonce,十六进制的GAS 单价，收款地址，十六进制的转账金额 备注
            NSDictionary * dic = @{
                                   @"wallet_address":self.model.address,
                                   @"nonce":self.nonce,
                                   @"ox_gas":gas,
                                   @"ox_price":price,
                                   @"transfer_address":self.address,
                                   @"show_price":self.price,
                                   @"show_gas":self.totleGasPrice,
                                   @"hit":self.remark,
                                   @"type":@"1",
                                   @"gas_limit":@""
                                   };
            [self creatCIQRCodeImageWithString:[dic toJSONStringForDictionary]];
            [self.lookWalletCodeView showWithView:nil];
        }
    }
    else
    {
        //普通钱包转账
        self.password.titleLN.text = @"请输入密码";
        self.password.infoLB.text = @"";
        [self.maskView addToWindow];
        [self.password addToWindow];
        [self.password springingAnimation];
        [self.password begainFirstResponder];
    }
    
}

- (void)creatCIQRCodeImageWithString:(NSString *)string
{
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3. 给过滤器添加数据
    NSString *dataString = string;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5. 显示二维码
    if (self.isCodeWallet)
    {
        self.codeWalletCodeView.codeImageView.image = [self creatNonInterpolatedUIImageFormCIImage:outputImage withSize:SCREEN_WIDTH];
    }
    else
    {
        self.lookWalletCodeView.codeImageView.image = [self creatNonInterpolatedUIImageFormCIImage:outputImage withSize:SCREEN_WIDTH];
    }
}

- (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark -- get

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
        _password.frame = CGRectMake(0, 0, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40) * 216 / 307);
        _password.center = CGPointMake(SCREEN_WIDTH / 2, (SCREEN_HEIGHT - 216) / 2);
        _password.delegate = self;
        _password.titleLN.text = NSLocalizedString(@"Please input a password", nil);
        _password.infoLB.text = @"";
    }
    return _password;
}

- (LookWalletCodeView *)lookWalletCodeView
{
    if (!_lookWalletCodeView)
    {
        _lookWalletCodeView = [[LookWalletCodeView alloc] initWithFrame:[AppDelegate delegate].window.bounds];
        _lookWalletCodeView.delegate = self;
    }
    return _lookWalletCodeView;
}

- (CodeWalletCodeView *)codeWalletCodeView
{
    if (!_codeWalletCodeView)
    {
        _codeWalletCodeView = [[CodeWalletCodeView alloc] initWithFrame:[AppDelegate delegate].window.bounds];
        _codeWalletCodeView.delegate = self;
    }
    return _codeWalletCodeView;
}

@end
