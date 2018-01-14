//
//  DBHTransferConfirmationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTransferConfirmationViewController.h"

#import "SystemConvert.h"

#import "DBHInputPasswordPromptView.h"

#import "DBHWalletDetailTokenInfomationModelData.h"
#import "DBHWalletManagerForNeoDataModels.h"

@interface DBHTransferConfirmationViewController ()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UILabel *poundageLabel;
@property (nonatomic, strong) UILabel *collectionAddressLabel;
@property (nonatomic, strong) UILabel *collectionAddressValueLabel;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) UILabel *remarkValueLabel;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;

@end

@implementation DBHTransferConfirmationViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Transfer Confirmation", nil);
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.numberLabel];
    [self.view addSubview:self.unitLabel];
    [self.view addSubview:self.poundageLabel];
    [self.view addSubview:self.collectionAddressLabel];
    [self.view addSubview:self.collectionAddressValueLabel];
    [self.view addSubview:self.grayLineView];
    [self.view addSubview:self.remarkLabel];
    [self.view addSubview:self.remarkValueLabel];
    [self.view addSubview:self.sureButton];
    
    WEAKSELF
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(47));
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.numberLabel.mas_right);
        make.bottom.equalTo(weakSelf.numberLabel).offset(- AUTOLAYOUTSIZE(5));
    }];
    [self.poundageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.numberLabel.mas_bottom).offset(AUTOLAYOUTSIZE(8));
    }];
    [self.collectionAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.bottom.equalTo(weakSelf.collectionAddressValueLabel.mas_top).offset(- AUTOLAYOUTSIZE(11.5));
    }];
    [self.collectionAddressValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.bottom.equalTo(weakSelf.grayLineView.mas_top).offset(- AUTOLAYOUTSIZE(10));
    }];
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(60));
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.numberLabel.mas_bottom).offset(AUTOLAYOUTSIZE(150));
    }];
    [self.remarkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.grayLineView.mas_bottom).offset(AUTOLAYOUTSIZE(40));
    }];
    [self.remarkValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.remarkLabel.mas_bottom).offset(AUTOLAYOUTSIZE(11.5));
    }];
    [self.sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(47.5));
    }];
}

#pragma mark ------ Data ------
/**
 NEO转账
 */
- (void)transferAccountsForNEOWithPassword:(NSString *)password unspent:(NSString *)unspent {
    id data = [PDKeyChain load:self.neoWalletModel.address];
    NSString *assert = [self.tokenModel.flag isEqualToString:@"NEO"] ? @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b" : @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7";
    // NEO钱包转账
    //子线程异步执行下载任务，防止主线程卡顿
    NSError * error;
    NeomobileWallet *Wallet = NeomobileFromKeyStore(data, password, &error);
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //异步返回主线程，根据获取的数据，更新UI
    dispatch_async(mainQueue, ^
                   {
                       if (!error)
                       {
                           //代币钱包转账
//                           if (self.isCodeWallet)
//                           {
//                               //冷钱包进入 转账后生成二维码转给观察钱包
//                               //生成data
//                               NSError * error;
//
//                               [Wallet createAssertTx:assert from:Wallet.address to:self.address amount:self.price.doubleValue unspent:unspent error:&error];
//
//                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
//                               //异步返回主线程，根据获取的数据，更新UI
//                               dispatch_async(mainQueue, ^
//                                              {
//                                                  if (!error)
//                                                  {
//                                                      [LCProgressHUD hide];
//                                                      [self caneButtonClicked];
//                                                      [LCProgressHUD showMessage:@"转账成功"];
//
//                                                      //冷钱包
//                                                      [self creatCIQRCodeImageWithString:[NSString stringWithFormat:@"0x%@",[NSString convertDataToHexStr:data]]];
//                                                      [self.codeWalletCodeView showWithView:nil];
//                                                  }
//                                                  else
//                                                  {
//                                                      [LCProgressHUD hide];
//                                                      [self caneButtonClicked];
//                                                      [LCProgressHUD showMessage:@"转账失败，请稍后重试"];
//                                                  }
//                                              });
//
//
//                           }
//                           else
//                           {
                               //热钱包代币转账
                               NSString * price = [NSString stringWithFormat:@"0x%@",[SystemConvert decimalToHex:[[NSString stringWithFormat:@"%.0f000000000000",[self.transferNumber floatValue] * 1000000] longLongValue]]];
                               NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
                               [parametersDic setObject:self.neoWalletModel.address forKey:@"contract"];
                               [parametersDic setObject:self.address forKey:@"to"];
                               [parametersDic setObject:price forKey:@"value"];
                               
                               //生成data
                               NSError * error;
                               NeomobileTx *tx = [Wallet createAssertTx:assert from:Wallet.address to:self.address amount:self.transferNumber.doubleValue unspent:unspent error:&error];
                               
                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                               //异步返回主线程，根据获取的数据，更新UI
                               dispatch_async(mainQueue, ^
                                              {
                                                  if (!error)
                                                  {
                                                      [LCProgressHUD hide];
                                                      [LCProgressHUD showMessage:@"转账成功"];
                                                      
                                                      //热钱包生成订单
                                                      [self creatNeoOrderWithData:tx.data trade_no:tx.id_];
                                                  }
                                                  else
                                                  {
                                                      [LCProgressHUD hide];
                                                      [LCProgressHUD showMessage:@"转账失败，请稍后重试"];
                                                  }
                                              });
//                           }
                       }
                       else
                       {
                           [LCProgressHUD hide];
                           [LCProgressHUD showMessage:@"密码错误，请稍后重试"];
                       }
                   });
}
/**
 TNC转账
 */
- (void)transferAccountsForTNCWithPassword:(NSString *)password unspent:(NSString *)unspent {
    id data = [PDKeyChain load:self.neoWalletModel.address];
    // NEO钱包转账
    //子线程异步执行下载任务，防止主线程卡顿
    NSError * error;
    NeomobileWallet *Wallet = NeomobileFromKeyStore(data, password, &error);
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //异步返回主线程，根据获取的数据，更新UI
    dispatch_async(mainQueue, ^
                   {
                       if (!error)
                       {
                           //代币钱包转账
                           //                           if (self.isCodeWallet)
                           //                           {
                           //                               //冷钱包进入 转账后生成二维码转给观察钱包
                           //                               //生成data
                           //                               NSError * error;
                           //
                           //                               [Wallet createAssertTx:assert from:Wallet.address to:self.address amount:self.price.doubleValue unspent:unspent error:&error];
                           //
                           //                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                           //                               //异步返回主线程，根据获取的数据，更新UI
                           //                               dispatch_async(mainQueue, ^
                           //                                              {
                           //                                                  if (!error)
                           //                                                  {
                           //                                                      [LCProgressHUD hide];
                           //                                                      [self caneButtonClicked];
                           //                                                      [LCProgressHUD showMessage:@"转账成功"];
                           //
                           //                                                      //冷钱包
                           //                                                      [self creatCIQRCodeImageWithString:[NSString stringWithFormat:@"0x%@",[NSString convertDataToHexStr:data]]];
                           //                                                      [self.codeWalletCodeView showWithView:nil];
                           //                                                  }
                           //                                                  else
                           //                                                  {
                           //                                                      [LCProgressHUD hide];
                           //                                                      [self caneButtonClicked];
                           //                                                      [LCProgressHUD showMessage:@"转账失败，请稍后重试"];
                           //                                                  }
                           //                                              });
                           //
                           //
                           //                           }
                           //                           else
                           //                           {
                           //热钱包代币转账
                           NSString * price = [NSString stringWithFormat:@"0x%@",[SystemConvert decimalToHex:[[NSString stringWithFormat:@"%.0f000000000000",[self.transferNumber floatValue] * 1000000] longLongValue]]];
                           NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
                           [parametersDic setObject:self.neoWalletModel.address forKey:@"contract"];
                           [parametersDic setObject:self.address forKey:@"to"];
                           [parametersDic setObject:price forKey:@"value"];
                           
                           //生成data
                           NSError * error;
                           NeomobileTx *tx = [Wallet createNep5Tx:self.tokenModel.address from:NeomobileDecodeAddress(self.neoWalletModel.address, nil) to:NeomobileDecodeAddress(self.address, nil) gas:0.0 amount:(NSInteger)(self.transferNumber.floatValue * pow(10, self.tokenModel.decimals.floatValue)) unspent:unspent error:&error];
                           
                           dispatch_queue_t mainQueue = dispatch_get_main_queue();
                           //异步返回主线程，根据获取的数据，更新UI
                           dispatch_async(mainQueue, ^
                                          {
                                              if (!error)
                                              {
                                                  [LCProgressHUD hide];
                                                  [LCProgressHUD showMessage:@"转账成功"];
                                                  
                                                  //热钱包生成订单
                                                  [self creatNeoOrderWithData:tx.data trade_no:tx.id_];
                                              }
                                              else
                                              {
                                                  [LCProgressHUD hide];
                                                  [LCProgressHUD showMessage:@"转账失败，请稍后重试"];
                                              }
                                          });
                           //                           }
                       }
                       else
                       {
                           [LCProgressHUD hide];
                           [LCProgressHUD showMessage:@"密码错误，请稍后重试"];
                       }
                   });
}
/**
 上传后台提交NEO订单
 */
- (void)creatNeoOrderWithData:(NSString *)data trade_no:(NSString *)trade_no
{
    //创建钱包订单
    NSString *assert;
    if ([self.tokenModel.flag isEqualToString:@"NEO"]) {
        assert = @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b";
    } else if ([self.tokenModel.flag isEqualToString:@"Gas"]) {
        assert = @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7";
    } else {
        assert = self.tokenModel.address;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(self.neoWalletModel.listIdentifier) forKey:@"wallet_id"];
    [dic setObject:data forKey:@"data"];
    [dic setObject:self.neoWalletModel.address forKey:@"pay_address"];
    [dic setObject:self.address forKey:@"receive_address"];
    [dic setObject:self.remark forKey:@"remark"];
    [dic setObject:self.transferNumber forKey:@"fee"];
    [dic setObject:@"0" forKey:@"handle_fee"];
    [dic setObject:@"NEO" forKey:@"flag"];
    [dic setObject:[NSString stringWithFormat:@"0x%@", trade_no] forKey:@"trade_no"];
    [dic setObject:assert forKey:@"asset_id"];
    
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
         [LCProgressHUD showFailure:@"转账失败"];
         //         [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
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
- (void)getUnspentWithPassword:(NSString *)password {
    WEAKSELF
    if ([self.tokenModel.flag isEqualToString:@"Gas"]) {
        [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoUtxo?address=%@&type=%@", weakSelf.neoWalletModel.address, @"neo-gas-asset-id"] isOtherBaseUrl:NO parameters:nil hudString:@"" success:^(id responseObject) {
            NSArray *result = responseObject[@"result"];
            [weakSelf transferAccountsForNEOWithPassword:password unspent:[result toJSONStringForArray]];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    } else if ([self.tokenModel.flag isEqualToString:@"NEO"]) {
        [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoUtxo?address=%@&type=%@", weakSelf.neoWalletModel.address, @"neo-asset-id"] isOtherBaseUrl:NO parameters:nil hudString:@"" success:^(id responseObject) {
            NSArray *result = responseObject[@"result"];
            [weakSelf transferAccountsForNEOWithPassword:password unspent:[result toJSONStringForArray]];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    } else {
        NSMutableArray *result = [NSMutableArray array];
        [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoUtxo?address=%@&type=%@", self.neoWalletModel.address, @"neo-asset-id"] isOtherBaseUrl:NO parameters:nil hudString:@"" success:^(id responseObject) {
            [result addObjectsFromArray:responseObject[@"result"]];
            [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoUtxo?address=%@&type=%@", weakSelf.neoWalletModel.address, @"neo-gas-asset-id"] isOtherBaseUrl:NO parameters:nil hudString:@"" success:^(id responseObject) {
                [result addObjectsFromArray:responseObject[@"result"]];
                [weakSelf transferAccountsForTNCWithPassword:password unspent:[result toJSONStringForArray]];
            } failure:^(NSString *error) {
                [LCProgressHUD showFailure:error];
            }];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    }
}

#pragma mark ------ Event Responds ------
/**
 确定
 */
- (void)respondsToSureButton {
    [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordPromptView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.inputPasswordPromptView animationShow];
    });
}

#pragma mark ------ Getters And Setters ------
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = FONT(30);
        _numberLabel.text = [NSString stringWithFormat:@"%.8lf", self.transferNumber.floatValue];
        _numberLabel.textColor = COLORFROM16(0x008D55, 1);
    }
    return _numberLabel;
}
- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = FONT(8);
        _unitLabel.text = [NSString stringWithFormat:@"（%@）", self.tokenModel.flag];
        _unitLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _unitLabel;
}
- (UILabel *)poundageLabel {
    if (!_poundageLabel) {
        _poundageLabel = [[UILabel alloc] init];
        _poundageLabel.font = FONT(11);
        _poundageLabel.text = [NSString stringWithFormat:@"%@：%.8lf", NSLocalizedString(@"Poundage", nil), self.poundage.floatValue];
        _poundageLabel.textColor = COLORFROM16(0xF85803, 1);
    }
    return _poundageLabel;
}
- (UILabel *)collectionAddressLabel {
    if (!_collectionAddressLabel) {
        _collectionAddressLabel = [[UILabel alloc] init];
        _collectionAddressLabel.font = FONT(13);
        _collectionAddressLabel.text = NSLocalizedString(@"Collection Wallet Address", nil);
        _collectionAddressLabel.textColor = COLORFROM16(0x8A8A8A, 1);
    }
    return _collectionAddressLabel;
}
- (UILabel *)collectionAddressValueLabel {
    if (!_collectionAddressValueLabel) {
        _collectionAddressValueLabel = [[UILabel alloc] init];
        _collectionAddressValueLabel.font = FONT(13);
        _collectionAddressValueLabel.text = self.address;
        _collectionAddressValueLabel.textColor = COLORFROM16(0x3D3D3D, 1);
    }
    return _collectionAddressValueLabel;
}
- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xEAEAEA, 1);
    }
    return _grayLineView;
}
- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.font = FONT(13);
        _remarkLabel.text = NSLocalizedString(@"Remarks", nil);
        _remarkLabel.textColor = COLORFROM16(0x8A8A8A, 1);
    }
    return _remarkLabel;
}
- (UILabel *)remarkValueLabel {
    if (!_remarkValueLabel) {
        _remarkValueLabel = [[UILabel alloc] init];
        _remarkValueLabel.font = FONT(13);
        _remarkValueLabel.text = self.remark;
        _remarkValueLabel.textColor = COLORFROM16(0x3D3D3D, 1);
        _remarkValueLabel.numberOfLines = 0;
    }
    return _remarkValueLabel;
}
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = COLORFROM16(0xFF841C, 1);
        _sureButton.titleLabel.font = FONT(14);
        [_sureButton setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(respondsToSureButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
- (DBHInputPasswordPromptView *)inputPasswordPromptView {
    if (!_inputPasswordPromptView) {
        _inputPasswordPromptView = [[DBHInputPasswordPromptView alloc] init];
        
        WEAKSELF
        [_inputPasswordPromptView commitBlock:^(NSString *password) {
            [LCProgressHUD showLoading:@"验证中..."];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^
                           {
                               [weakSelf getUnspentWithPassword:password];
                           });
        }];
    }
    return _inputPasswordPromptView;
}

@end
