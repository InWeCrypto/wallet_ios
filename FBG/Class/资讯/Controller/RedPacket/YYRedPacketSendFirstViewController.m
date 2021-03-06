//
//  YYRedPacketSendFirstViewController.m
//  FBG
//
//  Created by yy on 2018/4/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSendFirstViewController.h"
#import "DBHInputPasswordPromptView.h"
#import "DBHShowAddWalletViewController.h"
#import "MyNavigationController.h"
#import "YYRedPacketChoosePayStyleView.h"
#import "DBHWalletLookPromptView.h"
#import "YYRedPacketPackagingViewController.h"
#import "YYRedPacketChooseCashViewController.h"
#import "IQKeyboardManager.h"
#import "YYWalletConversionListModel.h"
#import "SystemConvert.h"

#define MAX_SEND_COUNT(count) [NSString stringWithFormat:@"%d%@", count, DBHGetStringWithKeyFromTable(@" Packet ", nil)]

#define MAX_SEND 100

@interface YYRedPacketSendFirstViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *pullMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseETHBtn;

@property (weak, nonatomic) IBOutlet UILabel *sendSumTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *sendSumValueTextField;
@property (weak, nonatomic) IBOutlet UILabel *sendUnitLabel;

@property (weak, nonatomic) IBOutlet UILabel *sendCountTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *sendCountValueTextField;
@property (weak, nonatomic) IBOutlet UILabel *maxSendTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxSendValueLabel;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UIButton *chooseWalletBtn;

@property (weak, nonatomic) IBOutlet UILabel *walletAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletMaxUseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletMaxUseValueLabel;
@property (weak, nonatomic) IBOutlet UIView *walletInfoView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) IBOutlet UIView *noWalletView;
@property (weak, nonatomic) IBOutlet UILabel *noWalletTip1Label;
@property (weak, nonatomic) IBOutlet UILabel *noWalletTip2Label;
@property (weak, nonatomic) IBOutlet UIButton *addWalletBtn;
@property (weak, nonatomic) IBOutlet UILabel *noWalletTip3Label;

@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *slowLabel;
@property (weak, nonatomic) IBOutlet UILabel *fastLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *feeValueLabel;

@property (nonatomic, copy) NSString *maxSentCount;

@property (nonatomic, strong) YYRedPacketChoosePayStyleView *choosePayStyleView;
@property (nonatomic, strong) YYRedPacketEthTokenModel *tokenModel; // 作为礼金的代币
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *maxBalanceWalletModel;
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *currentWalletModel; // 当前选中的钱包
@property (nonatomic, strong) NSMutableArray *currentTokenWalletsArray; // 当前选中代币所在的所有钱包

@end

@implementation YYRedPacketSendFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backIndex = 2;
    
    [self setUI];
    [self getMaxSentCount];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self redPacketNavigationBar];
}

- (void)dealloc {
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

/**
 父类方法
 */
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(18)}];
}

- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Send Red Packet", nil);
    
    self.firstLabel.text = DBHGetStringWithKeyFromTable(@"First:", nil);
    self.pullMoneyLabel.text = DBHGetStringWithKeyFromTable(@"Packing Assets", nil);
    [self.slider addTarget:self action:@selector(respondsToGasSlider) forControlEvents:UIControlEventValueChanged];
    self.sendSumTitleLabel.text = DBHGetStringWithKeyFromTable(@" Amount ", nil);
    self.sendCountTitleLabel.text = DBHGetStringWithKeyFromTable(@"Package Number", nil);
    
    self.maxSendTipLabel.text = DBHGetStringWithKeyFromTable(@"(Max:", nil);
   
    self.slowLabel.text = DBHGetStringWithKeyFromTable(@"Slow", nil);
    self.fastLabel.text = DBHGetStringWithKeyFromTable(@"Fast", nil);
    self.feeLabel.text = DBHGetStringWithKeyFromTable(@"Pitman Cost", nil);
    
    [self.payBtn setTitle:DBHGetStringWithKeyFromTable(@" Payment ", nil) forState:UIControlStateNormal];
    [self.payBtn setCorner:2];
    
    [self.payBtn setBackgroundColor:COLORFROM16(0xEA6204, 1) forState:UIControlStateNormal];
    [self.payBtn setBackgroundColor:COLORFROM16(0xD5D5D5, 1) forState:UIControlStateDisabled];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.25, 4);
    layer.backgroundColor = COLORFROM16(0x029857, 1).CGColor;
    [self.progressView.layer addSublayer:layer];
    
    self.noWalletTip1Label.text = DBHGetStringWithKeyFromTable(@"Your wallet do not have this asset,", nil);
    self.noWalletTip2Label.text = DBHGetStringWithKeyFromTable(@"Please ", nil);
    [self.addWalletBtn setTitle:DBHGetStringWithKeyFromTable(@"Add Wallet", nil) forState:UIControlStateNormal];
    self.noWalletTip3Label.text = DBHGetStringWithKeyFromTable(@" Deposit assets before sending Red Packet", nil);
    
    self.walletMaxUseTitleLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Max Amount", nil)];
    self.maxSentCount = [NSString stringWithFormat:@"%@", @(MAX_SEND)];
    self.maxSendValueLabel.text = MAX_SEND_COUNT(MAX_SEND);
    
    self.payBtn.enabled = NO;
    [self setReAuthStatusUI];
}

- (void)setReAuthStatusUI {
    if (!self.model) { // 为空
        [self.chooseETHBtn setTitle:DBHGetStringWithKeyFromTable(@"Pack ETH tokens", nil) forState:UIControlStateNormal];
        self.slider.value = 0;
        self.sendUnitLabel.text = @"";
        
        self.walletInfoView.hidden = YES;
        self.noWalletView.hidden = YES;
        self.chooseETHBtn.enabled = YES;
        self.chooseWalletBtn.enabled = YES;
    } else {
        NSString *number = [NSString notRounding:self.model.auth_gas afterPoint:8];
        self.feeValueLabel.text = [NSString stringWithFormat:@"%.8lf", number.doubleValue];
        
        self.slider.value = 0;
        self.sendSumValueTextField.text = self.model.redbag;
        self.sendCountValueTextField.text = [NSString stringWithFormat:@"%ld", self.model.redbag_number];
        
        self.walletInfoView.hidden = NO;
        self.noWalletView.hidden = YES;
        self.chooseWalletBtn.enabled = NO;
        self.chooseETHBtn.enabled = NO;
        
        NSString *addr = self.model.redbag_addr;
        self.walletAddressLabel.text = addr;
        
        DBHWalletManagerForNeoModelList *walletModel = [self walletModelByAddress:addr];
        _currentWalletModel = walletModel;
        _tokenModel = self.model.gnt_category;
        
        [self getMinFees];
        
        NSString *balance = @"0";
        NSString *tokenName = self.model.redbag_symbol;
        [self.chooseETHBtn setTitle:tokenName forState:UIControlStateNormal];
        self.sendUnitLabel.text = tokenName;
        if (![NSObject isNulllWithObject:tokenName]) {
            balance = [walletModel.tokenStatistics objectForKey:tokenName];
        }
        
        number = [NSString notRounding:balance afterPoint:4];
        number = [NSString stringWithFormat:@"%.4lf", number.doubleValue];
        self.walletMaxUseValueLabel.text = [NSString stringWithFormat:@"%@%@", number, tokenName];
    }
}

#pragma mark ------- PrivateMethod ---------
- (DBHWalletManagerForNeoModelList *)walletModelByAddress:(NSString *)address {
    if (self.ethWalletsArr.count == 0 || [NSObject isNulllWithObject:address]) {
        return nil;
    }
    
    DBHWalletManagerForNeoModelList *model = nil;
    for (DBHWalletManagerForNeoModelList *walletModel in self.ethWalletsArr) {
        if ([[walletModel.address lowercaseString] isEqualToString:[address lowercaseString]]) {
            model = walletModel;
            break;
        }
    }
    
    return model;
}

#pragma mark ----- respondsToBtn ---------
- (void)respondsToGasSlider {
    self.feeValueLabel.text = [NSString stringWithFormat:@"%.8lf", self.slider.value];
}

- (IBAction)respondsToPayBtn:(UIButton *)sender {
    NSString *currentBalance = [self.currentWalletModel.tokenStatistics objectForKey:self.tokenModel.name];
    if (self.sendSumValueTextField.text.doubleValue > currentBalance.doubleValue) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The send assets is beyond max amount", nil)];
        return;
    }

    if (self.sendCountValueTextField.text.integerValue > self.maxSendValueLabel.text.integerValue) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The send number is beyond max amount", nil)];
        return;
    }

    [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordPromptView];

    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.inputPasswordPromptView animationShow];
    });
}

- (IBAction)respondsToChooseWalletBtn:(UIButton *)sender {
    [[UIApplication sharedApplication].keyWindow addSubview:self.choosePayStyleView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.choosePayStyleView animationShow];
    });
}

- (IBAction)respondsToChooseToken:(UIButton *)sender {
    YYRedPacketChooseCashViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:CHOOSE_CASH_STORYBOARD_ID];
    WEAKSELF
    [vc setBlock:^(YYRedPacketEthTokenModel *model) {
        weakSelf.tokenModel = model;
        [sender setTitle:model.name forState:UIControlStateNormal];
        weakSelf.sendUnitLabel.text = model.name;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)respondsToAddWalletBtn:(UIButton *)sender {
    if (![UserSignData share].user.isLogin) {
        [[AppDelegate delegate] goToLoginVC:self];
    } else {
        DBHShowAddWalletViewController *vc = [[DBHShowAddWalletViewController alloc] init];
        vc.nc = self.navigationController;
        
        MyNavigationController *naviVC = [[MyNavigationController alloc] initWithRootViewController:vc];
        naviVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:naviVC animated:NO completion:^{
            [vc animateShow:YES completion:nil];
        }];
    }
}

#pragma mark ------- Data ---------
- (void)getMaxSentCount {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        NSString *maxCount = @"0";
        @try {
            EthmobileEthCall *call = EthmobileNewEthCall();
            
            NSString *contractAddr = TEST_REDPACKET_CONTRACT_ADDRESS;
            if ([APP_APIEHEAD isEqualToString:APIEHEAD1]) {
                contractAddr = REDPACKET_CONTRACT_ADDRESS;
            }
            
            NSError *error = nil;
            maxCount = [call redPacketMaxCount:contractAddr error:&error];
        } @catch (NSException *exception) {
            maxCount = @"0";
        }
        
        NSDictionary *params = [NSDictionary dictionaryWithJsonString:maxCount];
        WEAKSELF
        [PPNetworkHelper POST:@"offline_wallet/rpc" baseUrlType:3 parameters:params hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
            if (![NSObject isNulllWithObject:responseObject] && [responseObject isKindOfClass:[NSString class]]) {
                NSString *maxCount = responseObject;
                maxCount = [SystemConvert hexToDecimal:maxCount];
                
                weakSelf.maxSendValueLabel.text = MAX_SEND_COUNT(maxCount.intValue);
                weakSelf.maxSentCount = [NSString stringWithFormat:@"%@", @(maxCount.intValue)];
            }
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    });
}

/**
 获取count
 */
- (void)getTransactionCount {
    [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"Authorizing", nil)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *addr = self.currentWalletModel.address;
        if (addr.length > 0) {
            if (![addr hasPrefix:@"0x"]) {
                addr = [NSString stringWithFormat:@"0x%@", addr];
            }
            
            NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
            [parametersDic setObject:[addr lowercaseString] forKey:@"address"];
            
            WEAKSELF
            [PPNetworkHelper POST:@"extend/getTransactionCount" baseUrlType:1 parameters:parametersDic hudString:nil success:^(id responseObject) {
                [weakSelf handleResponseObj:responseObject type:0];
            } failure:^(NSString *error) {
                [LCProgressHUD hide];
                [LCProgressHUD showFailure:error];
            }];
            
        }
    });
}

/**
 授权
 */
- (void)gotoAuth:(NSString *)data asset_id:(NSString *)asset_id transferNum:(NSString *)transferNum handleFee:(NSString *)handleFee contractAddr:(NSString *)contractAddr nonce:(NSString *)nonce {
    @autoreleasepool {
        NSString *redBag_number = self.sendCountValueTextField.text;
        NSString *redBag = self.sendSumValueTextField.text;
        NSString *poundage = self.feeValueLabel.text;
        dispatch_async(dispatch_get_global_queue(
                                                 DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 0), ^{
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            NSString *addr = self.currentWalletModel.address;
            NSString *symbol = self.tokenModel.name;
            if (![NSObject isNulllWithObject:addr]) {
                [params setObject:[addr lowercaseString] forKey:REDBAG_ADDR];
            }
            
            NSString *authTxNonce = nonce;
            
            if (self.model) {
                authTxNonce = self.model.auth_tx_nonce;
                
                [params setObject:@(self.model.redPacketId) forKey:REPEAT_ID];
            } else {
                if (![NSObject isNulllWithObject:authTxNonce]) {
                    if ([authTxNonce hasPrefix:@"0x"]) {
                        authTxNonce = [authTxNonce substringFromIndex:2];
                    }
                    authTxNonce = [NSString numberHexString:authTxNonce];
                }
            }
            
            if (![NSObject isNulllWithObject:poundage]) {
                [params setObject:poundage forKey:AUTH_GAS];
            }
            
            if (![NSObject isNulllWithObject:authTxNonce]) {
                [params setObject:authTxNonce forKey:AUTH_TX_NONCE];
            }
            
            if (![NSObject isNulllWithObject:symbol]) {
                [params setObject:symbol forKey:REDBAG_SYMBOL];
            }
            
            if (![NSObject isNulllWithObject:redBag]) {
                [params setObject:redBag forKey:REDBAG];
            }
            
            if (![NSObject isNulllWithObject:redBag_number]) {
                [params setObject:redBag_number forKey:REDBAG_NUMBER];
            }
            
            NSMutableDictionary *transferParams = [NSMutableDictionary dictionary];
            
            if (![NSObject isNulllWithObject:asset_id]) {
                [transferParams setObject:asset_id forKey:ASSET_ID];
            }
            
            NSString *payAddr = [self.currentWalletModel.address lowercaseString];
            if (![NSObject isNulllWithObject:payAddr]) {
                [transferParams setObject:payAddr forKey:PAY_ADDRESS];
            }
            
            if (![NSObject isNulllWithObject:contractAddr]) {
                [transferParams setObject:[contractAddr lowercaseString] forKey:RECEIVE_ADDRESS];
            }
            
            if (![NSObject isNulllWithObject:transferNum]) {
                [transferParams setObject:transferNum forKey:FEE];
            }
            
            NSString *tempHandleFee = handleFee;
            if ([self.tokenModel.name isEqualToString:ETH]) { // eth
                tempHandleFee = [NSString stringWithFormat:@"0x%@", [NSString getHexByDecimal:[NSString DecimalFuncWithOperatorType:2 first:poundage secend:@"1000000000000000000" value:8].integerValue]];
            }
            
            if (![NSObject isNulllWithObject:tempHandleFee]) {
                [transferParams setObject:tempHandleFee forKey:HANDLE_FEE];
            }
            [transferParams setObject:data forKey:DATA];
            [transferParams setObject:@"" forKey:REMARK];
            
            [params setObject:transferParams forKey:TRANSACTION_PARAM];
            
            WEAKSELF
            [PPNetworkHelper POST:@"redbag/auth" baseUrlType:3 parameters:params hudString:nil success:^(id responseObject) {
                [weakSelf handleResponseObj:responseObject type:1];
            } failure:^(NSString *error) {
                [LCProgressHUD hide];
                
                if ([error isEqualToString:@"nonce too low"]) {
                    YYRedPacketPackagingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_PACKAGING_STORYBOARD_ID];
                    vc.packageType = PackageTypeRedPacket;
                    vc.model = self.model;
                    vc.ethWalletsArray = self.ethWalletsArr;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(error, nil)];
                }
            }];
        });
    }
}

- (void)getMinFees {
    WEAKSELF
    [PPNetworkHelper GET:@"config/get_key/REDBAG_MAX_GAS" baseUrlType:3 parameters:nil hudString:nil success:^(id responseObject) {
        [weakSelf handleResponseObj:responseObject type:2];
    } failure:^(NSString *error) {
        [weakSelf handleResponseObj:nil type:2];
    }];
}

- (void)handleResponseObj:(id)responseObj type:(NSInteger)type {
    if ([NSObject isNulllWithObject:responseObj]) {
        [LCProgressHUD hide];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (type == 0) { // getTransactionCount
            if (![responseObj isKindOfClass:[NSDictionary class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LCProgressHUD hide];
                });
                return;
            }
            
            NSString *count = responseObj[@"count"];
            if ([NSObject isNulllWithObject:count]) {
                count = @"0x0";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self transactionCountHandle:count];
            });
        } else if (type == 1) { // 授权
            dispatch_async(dispatch_get_main_queue(), ^{
                [LCProgressHUD hide];
            });
            
            if (![responseObj isKindOfClass:[NSDictionary class]]) {
                return;
            }
            
            YYRedPacketDetailModel *model = [YYRedPacketDetailModel mj_objectWithKeyValues:responseObj];
            if (model.status == RedBagStatusCashPackaging || model.status == RedBagStatusCashAuthPending) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    YYRedPacketPackagingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_PACKAGING_STORYBOARD_ID];
                    vc.packageType = PackageTypeCash;
                    vc.model = model;
                    vc.ethWalletsArray = self.ethWalletsArr;
                    [self.navigationController pushViewController:vc animated:YES];
                });
            }
        } else if (type == 2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *minValue = @"0";
                if ([responseObj isKindOfClass:[NSDictionary class]]) {
                    YYRedPacketConfigGasModel *gasModel = [YYRedPacketConfigGasModel mj_objectWithKeyValues:responseObj];
                    minValue = gasModel.value;
                }
                
                NSString *minSelfValue = [NSString DecimalFuncWithOperatorType:2 first:MIN_ETH_TOKEN_GASPRICE secend:self.tokenModel.gas value:8];
                minSelfValue = [NSString DecimalFuncWithOperatorType:3 first:minSelfValue secend:@"6" value:8];
                minSelfValue = [NSString DecimalFuncWithOperatorType:3 first:minSelfValue secend:@"1000000000000000000" value:8];
                
                if (minValue.doubleValue < minSelfValue.doubleValue) {
                    minValue = minSelfValue;
                }
                
                NSString *maxValue = [NSString DecimalFuncWithOperatorType:2 first:MAX_ETH_TOKEN_GASPRICE secend:self.tokenModel.gas value:8];
                maxValue = [NSString DecimalFuncWithOperatorType:3 first:maxValue secend:@"6"  value:8];
                maxValue = [NSString DecimalFuncWithOperatorType:3 first:maxValue secend:@"1000000000000000000" value:8];
                
                self.slider.minimumValue = minValue.doubleValue;
                self.slider.maximumValue = maxValue.doubleValue;
                
                if (self.model) {
                    self.slider.value = self.feeValueLabel.text.doubleValue;
                    
                    self.payBtn.enabled = YES;
                } else {
                    NSString *number = [NSString notRounding:minValue afterPoint:8];
                    self.feeValueLabel.text = [NSString stringWithFormat:@"%.8lf", number.doubleValue];
                    self.slider.value = self.slider.minimumValue;
                }
            });
        }
    });
}

// 16进制count
- (void)transactionCountHandle:(NSString *)count {
    NSString *redBag = self.sendSumValueTextField.text;
    NSString *poundage = self.feeValueLabel.text;
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        
        NSError * error;
        
        long long transfer = redBag.doubleValue * pow(10, self.tokenModel.decimals);
        
        NSString *transferStr = [NSString stringWithFormat:@"0x%@", [NSString getHexByDecimal:transfer]];
        
        NSString *gas = [NSString DecimalFuncWithOperatorType:2 first:poundage secend:@"1000000000000000000" value:10];
        
        NSString *gasPrice = [NSString DecimalFuncWithOperatorType:3 first:self.tokenModel.gas secend:@"6" value:0];
        gas = [NSString DecimalFuncWithOperatorType:3 first:gas secend:gasPrice value:8];
        
        gas = [NSString stringWithFormat:@"0x%@", [SystemConvert decimalToHex:gas.doubleValue]];
        
        NSString *gasLimit = [NSString stringWithFormat:@"0x%@",[NSString getHexByDecimal:self.tokenModel.gas.integerValue]];
        
        NSString *contractAddr = TEST_REDPACKET_CONTRACT_ADDRESS;
        if ([APP_APIEHEAD isEqualToString:APIEHEAD1]) {
            contractAddr = REDPACKET_CONTRACT_ADDRESS;
        }
        
        NSString *data = [self.currentWalletModel.ethWallet approve:[self.tokenModel.address lowercaseString]
                                                              nonce:count
                                                                 to:contractAddr
                                                              value:transferStr
                                                           gasPrice:gas
                                                          gasLimits:gasLimit
                                                              error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self gotoAuth:[NSString stringWithFormat:@"0x%@", data] asset_id:[self.tokenModel.address lowercaseString] transferNum:transferStr handleFee:gas contractAddr:contractAddr nonce:count];
            } else {
                [LCProgressHUD hide];
                [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Authorization failed", nil)];
            }
        });
    });
}

#pragma mark ------- TextField Delegate ---------
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *currentBalance = [self.currentWalletModel.tokenStatistics objectForKey:self.tokenModel.name];
    if ([textField isEqual:self.sendCountValueTextField]) {
        if (textField.text.integerValue == 0) {
            self.payBtn.enabled = NO;
        } else if (self.sendSumValueTextField.text.doubleValue != 0 &&
                   currentBalance.doubleValue != 0) {
            if (self.currentWalletModel.isLookWallet) {
                self.payBtn.enabled = NO;
                [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Watch wallet is invalid", nil)];
            } else {
                self.payBtn.enabled = YES;
            }
        }
        if (textField.text.integerValue > self.maxSendValueLabel.text.integerValue) {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The send number is beyond max amount", nil)];
            textField.text = self.maxSentCount;
        }
    } else if ([textField isEqual:self.sendSumValueTextField]) {
        if (textField.text.doubleValue == 0) {
            self.payBtn.enabled = NO;
        } else if (self.sendCountValueTextField.text.integerValue != 0 &&
                   currentBalance.doubleValue != 0) {
            if (self.currentWalletModel.isLookWallet) {
                self.payBtn.enabled = NO;
                [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Watch wallet is invalid", nil)];
            } else {
                self.payBtn.enabled = YES;
            }
        }
        
        if (textField.text.doubleValue > currentBalance.doubleValue) {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The send assets is beyond max amount", nil)];
            
            NSString *number = [NSString notRounding:currentBalance afterPoint:4];
            number = [NSString stringWithFormat:@"%.4lf", number.doubleValue];
            textField.text = number;
        }
    }
}

#pragma mark ----- Setters And Getters ---------
- (void)setTokenModel:(YYRedPacketEthTokenModel *)tokenModel {
    if ([_tokenModel isEqual:tokenModel]) {
        return;
    }
    
    _tokenModel = tokenModel;
    self.choosePayStyleView.tokenName = tokenModel.name;
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        
        _maxBalanceWalletModel = nil;
        
        NSMutableArray *tempWalletsArray = [NSMutableArray array];
        
        for (DBHWalletManagerForNeoModelList *model in self.ethWalletsArr) {
            @autoreleasepool {
                NSArray *tokenArr = model.infoModel.tokensArray;
                for (DBHWalletDetailTokenInfomationModelData *token in tokenArr) {
                    @autoreleasepool {
                        if ([token.name isEqualToString:tokenModel.name]) {  // 作为礼金的代币
                            [tempWalletsArray addObject:model];
                            NSString *balance = [self.maxBalanceWalletModel.tokenStatistics objectForKey:tokenModel.name];
                            if (balance.doubleValue < token.balance.doubleValue) {
                                self.maxBalanceWalletModel = model;
                            }
                        }
                    }
                }
            }
        }
        
        self.currentTokenWalletsArray = tempWalletsArray;
        self.currentWalletModel = self.maxBalanceWalletModel;
        
        [self getMinFees];
    });
}

- (void)setCurrentTokenWalletsArray:(NSMutableArray *)currentTokenWalletsArray {
    _currentTokenWalletsArray = currentTokenWalletsArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.choosePayStyleView.dataSource = currentTokenWalletsArray;
    });
}

- (void)setCurrentWalletModel:(DBHWalletManagerForNeoModelList *)currentWalletModel {
    _currentWalletModel = currentWalletModel;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.choosePayStyleView.currentWalletId = currentWalletModel.listIdentifier;
        
        NSString *balance = [self.currentWalletModel.tokenStatistics objectForKey:self.tokenModel.name];
        NSString *maxBalance = [self.maxBalanceWalletModel.tokenStatistics objectForKey:self.tokenModel.name];
        if (maxBalance.doubleValue == 0) { // 最大为0则显示添加钱包
            self.noWalletView.hidden = NO;
            self.walletInfoView.hidden = YES;
            
            self.payBtn.enabled = NO;
        } else {
            if (balance.doubleValue == 0) {
                self.payBtn.enabled = NO;
            } else if (self.sendCountValueTextField.text.integerValue != 0 && self.sendSumValueTextField.text.doubleValue != 0) {
                if (currentWalletModel.isLookWallet) { // 观察钱包
                    self.payBtn.enabled = NO;
                    [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Watch wallet is invalid", nil)];
                } else {
                    self.payBtn.enabled = YES;
                }
            }
            
            self.noWalletView.hidden = YES;
            self.walletInfoView.hidden = NO;
            self.walletAddressLabel.text = self.currentWalletModel.address;
            
            NSString *number = [NSString notRounding:balance afterPoint:4];
            number = [NSString stringWithFormat:@"%.4lf", number.doubleValue];
            self.walletMaxUseValueLabel.text = [NSString stringWithFormat:@"%@%@", number, self.tokenModel.name];
        }
    });
}

- (DBHInputPasswordPromptView *)inputPasswordPromptView {
    if (!_inputPasswordPromptView) {
        _inputPasswordPromptView = [[DBHInputPasswordPromptView alloc] init];
        
        _inputPasswordPromptView.placeHolder = DBHGetStringWithKeyFromTable(@"Please input a password", nil);
        WEAKSELF
        [_inputPasswordPromptView commitBlock:^(NSString *password) {
            NSString *tempAddr = weakSelf.currentWalletModel.address;
            NSString *data = [NSString keyChainDataFromKey:tempAddr isETH:YES];
            
            [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"In the validation...", nil)];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^ {
                //子线程异步执行下载任务，防止主线程卡顿
                NSError * error;
                
                weakSelf.currentWalletModel.ethWallet = EthmobileFromKeyStore(data, password, &error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LCProgressHUD hide];
                    if (!error) {
                        if (self.model) {
                            NSString *nonce = self.model.auth_tx_nonce;
                            if (![NSObject isNulllWithObject:nonce]) { // 10进制
                                nonce = [NSString stringWithFormat:@"0x%@", [NSString getHexByDecimal:nonce.integerValue]];
                            }
                            [weakSelf transactionCountHandle:nonce];
                        } else {
                            [weakSelf getTransactionCount];
                        }
                    } else {
                        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The password is incorrect. Please try again later", nil)];
                    }
                });
            });
        }];
    }
    return _inputPasswordPromptView;
}

- (void)setModel:(YYRedPacketDetailModel *)model {
    _model = model;
    [self setReAuthStatusUI];
}

- (YYRedPacketChoosePayStyleView *)choosePayStyleView {
    if (!_choosePayStyleView) {
        _choosePayStyleView = [[YYRedPacketChoosePayStyleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        WEAKSELF
        [_choosePayStyleView setBlock:^(DBHWalletManagerForNeoModelList *model) {
            weakSelf.currentWalletModel = model;
        }];
    }
    return _choosePayStyleView;
}

- (DBHWalletManagerForNeoModelList *)maxBalanceWalletModel {
    if (!_maxBalanceWalletModel) {
        _maxBalanceWalletModel = [[DBHWalletManagerForNeoModelList alloc] init];
    }
    return _maxBalanceWalletModel;
}

@end
