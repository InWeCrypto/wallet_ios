//
//  YYRedPacketSendSecondViewController.m
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//  

#import "YYRedPacketSendSecondViewController.h"
#import "DBHInputPasswordPromptView.h"
#import "YYRedPacketPackagingViewController.h"
#import "YYRedPacketChoosePayStyleView.h"
#import "SystemConvert.h"

#define GAS_LIMITS @"360000"

@interface YYRedPacketSendSecondViewController () {
    NSString *minHandlefeeOrigin; // 多个红包最小手续费原值
    NSString *maxHandlefeeOrigin; // 多个红包最大手续费原值
    
    NSString *minHandlefeeShow; // 多个红包最小手续费 显示到界面上的值 即除以了pow(10, 18)
    NSString *maxHandlefeeShow; // 多个红包最大手续费 显示到界面上的值 即除以了pow(10, 18)
    
    NSString *minValue;  // 最小矿工费
    NSString *maxValue;  // 最大矿工费
    
    NSString *totalShowMinValue;  // 最终显示的最小手续费 （包括矿工费和多个红包的手续费）
    NSString *totalShowMaxValue;  // 最终显示的最大手续费 （包括矿工费和多个红包的手续费）
}

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *poundageLabel;
@property (weak, nonatomic) IBOutlet UILabel *poundageValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UIButton *startCreateBtn;

@property (weak, nonatomic) IBOutlet UILabel *wallletAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseWalletBtn;


@property (weak, nonatomic) IBOutlet UILabel *walletMaxUseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletMaxUseValueLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *walletInfoView;

@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *maxBalanceWalletModel;
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *currentWalletModel; // 当前选中的钱包

@property (nonatomic, strong) YYRedPacketChoosePayStyleView *choosePayStyleView;
@property (nonatomic, copy) NSString *transactionCount;

@end

@implementation YYRedPacketSendSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self getPerRedPacketHandleFee];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self redPacketNavigationBar];
    self.title = DBHGetStringWithKeyFromTable(@"Send Red Packet", nil);
}

/**
 父类方法
 */
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(18)}];
}

#pragma mark ------- Data ---------
/**
 获取手续费
 */
- (void)getPerRedPacketHandleFee {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        EthmobileEthCall *call = EthmobileNewEthCall();
        
        NSString *contractAddr = TEST_REDPACKET_CONTRACT_ADDRESS;
        if ([APP_APIEHEAD isEqualToString:APIEHEAD1]) {
            contractAddr = REDPACKET_CONTRACT_ADDRESS;
        }
        
        NSError *error = nil;
        NSString *cost = [call redPacketTaxCost:contractAddr error:&error];
        
        NSDictionary *params = [NSDictionary dictionaryWithJsonString:cost];
        
        WEAKSELF
        [PPNetworkHelper POST:@"offline_wallet/rpc" baseUrlType:3 parameters:params hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
            [weakSelf handleResponseObj:responseObject type:2];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    });
}

/**
 获取eth最多的钱包
 */
- (void)getMaxETHBalanceModel {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        _maxBalanceWalletModel = nil;
        
        DBHWalletManagerForNeoModelList *maxModel = nil;
        for (DBHWalletManagerForNeoModelList *model in self.ethWalletsArray) {
            @autoreleasepool {
                DBHWalletDetailTokenInfomationModelData *ethModel = model.infoModel.ethModel;
                if (maxModel.infoModel.ethModel.balance.doubleValue < ethModel.balance.doubleValue) {
                    maxModel = model;
                }
            }
        }
        
        self.maxBalanceWalletModel = maxModel;
        self.currentWalletModel = self.maxBalanceWalletModel;
    });
}

/**
 获取count
 */
- (void)getTransactionCount {
    [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"Creating...", nil)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *addr = self.currentWalletModel.ethWallet.address;
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
 获取红包ID
 */
- (void)getRedBagID {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:@"offline_wallet/extend/getRedbagId" baseUrlType:3 parameters:nil hudString:nil success:^(id responseObject) {
            [weakSelf handleResponseObj:responseObject type:3];
        } failure:^(NSString *error) {
            [LCProgressHUD hide];
            NSLog(@"💣💣----获取红包ID失败");
        }];
    });
}

- (void)getMinFees {
    WEAKSELF
    [PPNetworkHelper GET:@"config/get_key/REDBAG_MAX_GAS" baseUrlType:3 parameters:nil hudString:nil success:^(id responseObject) {
        [weakSelf handleResponseObj:responseObject type:4];
    } failure:^(NSString *error) {
        [weakSelf handleResponseObj:nil type:4];
    }];
}

- (void)handleResponseObj:(id)responseObj type:(NSInteger)type {
    if ([NSObject isNulllWithObject:responseObj]) {
        [LCProgressHUD hide];
        return;
    }
    
    CGFloat sliderValue = self.slider.value;
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
                count = @"0";
            }
            
            self.transactionCount = count;
            [self getRedBagID];
        } else if (type == 1) { // 支付手续费
            dispatch_async(dispatch_get_main_queue(), ^{
                [LCProgressHUD hide];
            });
            
            if (![responseObj isKindOfClass:[NSDictionary class]]) {
                return;
            }
            
            YYRedPacketDetailModel *model = [YYRedPacketDetailModel mj_objectWithKeyValues:responseObj];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (model.status == RedBagStatusCreatePending || model.status == RedBagStatusCreating) {
                    YYRedPacketPackagingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_PACKAGING_STORYBOARD_ID];
                    vc.packageType = PackageTypeRedPacket;
                    vc.model = model;
                    vc.ethWalletsArray = self.ethWalletsArray;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (model.status == RedBagStatusCreateFailed) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Creation Failed", nil)];
                }
            });
        } else if (type == 2) { // 获取手续费
            if ([responseObj isKindOfClass:[NSString class]]) {
                NSString *redbagHandleFee = responseObj;
                if ([redbagHandleFee hasPrefix:@"0x"]) {
                    redbagHandleFee = [redbagHandleFee substringFromIndex:2];
                }
                
                if (redbagHandleFee.length >= 128) {
                    // 单个红包最小手续费
                    NSString *perMinHandleFee = [@"0x" stringByAppendingString:[redbagHandleFee substringWithRange:NSMakeRange(0, 64)]];
                    perMinHandleFee = [SystemConvert hexToDecimal:perMinHandleFee];
                    
                    // 多个红包最小手续费原值
                    minHandlefeeOrigin = [NSString DecimalFuncWithOperatorType:2 first:perMinHandleFee secend:@(self.model.redbag_number) value:0];
                    // 多个红包最小手续费显示到界面的值
                    minHandlefeeShow = [NSString DecimalFuncWithOperatorType:3 first:minHandlefeeOrigin secend:[NSString stringWithFormat:@"%@", @(pow(10, 18))] value:0];
                    
                    // 单个红包最大手续费
                    NSString *perMaxHandleFee = [@"0x" stringByAppendingString:[redbagHandleFee substringFromIndex:64]];
                    perMaxHandleFee = [SystemConvert hexToDecimal:perMaxHandleFee];
                    
                    // 多个红包最大手续费原值
                    maxHandlefeeOrigin = [NSString DecimalFuncWithOperatorType:2 first:perMaxHandleFee secend:@(self.model.redbag_number) value:0];
                    // 多个红包最大手续费显示到界面的值
                    maxHandlefeeShow = [NSString DecimalFuncWithOperatorType:3 first:maxHandlefeeOrigin secend:[NSString stringWithFormat:@"%@", @(pow(10, 18))] value:0];
                }
            }
            
            [self getMinFees];
        } else if (type == 3) { // 获取红包ID
            NSError * error;
            NSString *contractAddr = TEST_REDPACKET_CONTRACT_ADDRESS;
            if ([APP_APIEHEAD isEqualToString:APIEHEAD1]) { // 正式网还没有 YYTODO
                contractAddr = REDPACKET_CONTRACT_ADDRESS;
            }
            
            NSString *totalValue = [NSString DecimalFuncWithOperatorType:0 first:minValue secend:maxValue value:0]; // 矿工费 最大最小的和
            NSString *totalHandleFeeShow = [NSString DecimalFuncWithOperatorType:0 first:minHandlefeeShow secend:maxHandlefeeShow value:0]; // 多个红包手续费原值 最大最小的和
            // 手续费总和
            NSString *total = [NSString DecimalFuncWithOperatorType:0 first:totalValue secend:totalHandleFeeShow value:0];
            
            // 多个红包手续费所占比例
            NSString *handleFeePercent = [NSString DecimalFuncWithOperatorType:3 first:totalHandleFeeShow secend:total value:0];
            
            // 矿工费所占比例
            NSString *percent = [NSString DecimalFuncWithOperatorType:3 first:totalValue secend:total value:0];
            
            // 发红包收取的手续费
            NSString *amount = [NSString DecimalFuncWithOperatorType:2 first:@(sliderValue) secend:handleFeePercent value:0];
            long long transfer = amount.doubleValue * pow(10, 18);
            amount = [NSString getHexByDecimal:transfer];
            amount = [NSString stringWithFormat:@"0x%@", amount];
            
            // 燃料费价格
            NSString *gasPrice = [NSString DecimalFuncWithOperatorType:2 first:@(sliderValue) secend:percent value:0];
            gasPrice = [NSString DecimalFuncWithOperatorType:3 first:gasPrice secend:GAS_LIMITS value:0];
            gasPrice = [NSString DecimalFuncWithOperatorType:2 first:gasPrice secend:@(pow(10, 18)) value:0];
            gasPrice = [SystemConvert decimalToHex:gasPrice.integerValue];
            gasPrice = [NSString stringWithFormat:@"0x%@", [gasPrice lowercaseString]];
            
            long long gasPriceLong =  2 * pow(10, 10);
            NSString *tempgasPrice = [SystemConvert decimalToHex:gasPriceLong];
            tempgasPrice = [NSString stringWithFormat:@"0x%@", [tempgasPrice lowercaseString]];
            
            
            long long redbagID = [responseObj longLongValue];
            
            NSString *redBagIDStr = [NSString stringWithFormat:@"0x%@", [NSString getHexByDecimal:redbagID]];
            
            NSString *redBagValue = self.model.redbag;
            redBagValue = [NSString DecimalFuncWithOperatorType:2 first:redBagValue secend:@(pow(10, self.model.gnt_category.decimals)) value:0];
            redBagValue = [[NSString stringWithFormat:@"0x%@", [SystemConvert decimalToHex:redBagValue.doubleValue]] lowercaseString];
            
            NSString *redBagNumber = [NSString stringWithFormat:@"0x%@", [SystemConvert decimalToHex:self.model.redbag_number]];
            
            NSString *data = [self.currentWalletModel.ethWallet newRedPacket:contractAddr
                                                                       nonce:self.transactionCount
                                                               erc20contract:[self.model.gnt_category.address lowercaseString]
                                                                     tokenId:redBagIDStr
                                                                        from:[self.model.redbag_addr lowercaseString]
                                                                      amount:amount
                                                                       value:redBagValue
                                                                       count:redBagNumber
                                                                     command:@"0"
                                                                    gasPrice:gasPrice
                                                                   gasLimits:@"0x57e40"
                                                                       error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    [self gotoPay:[NSString stringWithFormat:@"0x%@", data] asset_id:@"0x0000000000000000000000000000000000000000" transferNum:amount handleFee:gasPrice contractAddr:contractAddr redBagID:redbagID];
                } else {
                    [LCProgressHUD hide];
                    [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Creation Failed", nil)];
                }
            });
        } else if (type == 4) { //  最小矿工费
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                YYRedPacketConfigGasModel *gasModel = [YYRedPacketConfigGasModel mj_objectWithKeyValues:responseObj];
                minValue = gasModel.value;
            }
            
            NSString *minSelfValue = [NSString DecimalFuncWithOperatorType:2 first:@"25200000000000" secend:GAS_LIMITS value:8];
            minSelfValue = [NSString DecimalFuncWithOperatorType:3 first:minSelfValue secend:@"21000" value:8];
            minSelfValue = [NSString DecimalFuncWithOperatorType:3 first:minSelfValue secend:@"1000000000000000000" value:8];
            
            if (minValue.doubleValue < minSelfValue.doubleValue) {
                minValue = minSelfValue;
            }
            
            // 最大矿工费
            maxValue = [NSString DecimalFuncWithOperatorType:2 first:@"2520120000000000" secend:GAS_LIMITS value:8];
            maxValue = [NSString DecimalFuncWithOperatorType:3 first:maxValue secend:@"21000" value:8];
            maxValue = [NSString DecimalFuncWithOperatorType:3 first:maxValue secend:@"1000000000000000000" value:8];
            
            totalShowMinValue = [NSString DecimalFuncWithOperatorType:0 first:minValue secend:minHandlefeeShow value:8];
            totalShowMaxValue = [NSString DecimalFuncWithOperatorType:0 first:maxValue secend:maxHandlefeeShow value:8];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *number = [NSString notRounding:totalShowMinValue afterPoint:8];
                self.minLabel.text = [NSString stringWithFormat:@"%.8lf", number.doubleValue];
                
                self.poundageValueLabel.text = [NSString stringWithFormat:@"%@ETH", self.minLabel.text];
                self.slider.value = totalShowMinValue.doubleValue;
                
                number = [NSString notRounding:totalShowMaxValue afterPoint:8];
                self.maxLabel.text = [NSString stringWithFormat:@"%.8lf", number.doubleValue];
                
                self.slider.minimumValue = totalShowMinValue.doubleValue;
                self.slider.maximumValue = totalShowMaxValue.doubleValue;
            });
            
            [self getMaxETHBalanceModel];
        }
    });
}

/**
 支付手续费
 */
- (void)gotoPay:(NSString *)data asset_id:(NSString *)asset_id transferNum:(NSString *)transferNum handleFee:(NSString *)handleFee contractAddr:(NSString *)contractAddr redBagID:(long long)redBagID {
    @autoreleasepool {
        CGFloat sliderValue = self.slider.value;
        dispatch_async(dispatch_get_global_queue(
                                                 DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 0), ^{
       
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            [params setObject:@(sliderValue) forKey:FEE];
            
            NSString *redbag_fee_addr = self.currentWalletModel.address;
            if (![NSObject isNulllWithObject:redbag_fee_addr]) {
                [params setObject:[redbag_fee_addr lowercaseString] forKey:FEE_ADDR];
            }
            
            [params setObject:[NSString stringWithFormat:@"%@", @(redBagID)] forKey:REDBAG_ID];
            
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
            
            if (![NSObject isNulllWithObject:handleFee]) {
                [transferParams setObject:handleFee forKey:HANDLE_FEE];
            }
            
            if (![NSObject isNulllWithObject:data]) {
                [transferParams setObject:data forKey:DATA];
            }
            
            [transferParams setObject:@"" forKey:REMARK];
            
            [params setObject:transferParams forKey:TRANSACTION_PARAM];
            
            NSString *urlStr = [NSString stringWithFormat:@"redbag/fee/%ld/%@", self.model.redPacketId, [self.model.redbag_addr lowercaseString]];
            WEAKSELF
            [PPNetworkHelper POST:urlStr baseUrlType:3 parameters:params hudString:nil success:^(id responseObject) {
                [weakSelf handleResponseObj:responseObject type:1];
            } failure:^(NSString *error) {
                [LCProgressHUD hide];
                [LCProgressHUD showFailure:error];
            }];
        });
    }
}

#pragma mark ------- SetUI ---------
- (void)setUI {
    self.backIndex = 2;
    
    self.secondLabel.text = DBHGetStringWithKeyFromTable(@"Second:", nil);
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"Pay for the gas to finish creating Red Packet", nil);
    self.walletMaxUseTitleLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Max Amount", nil)];
    self.poundageLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Fees", nil)];
    
    [self.startCreateBtn setTitle:DBHGetStringWithKeyFromTable(@"Start creating the Red Packet", nil) forState:UIControlStateNormal];
    [self.startCreateBtn setCorner:2];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, 4);
    layer.backgroundColor = COLORFROM16(0x029857, 1).CGColor;
    [self.progressView.layer addSublayer:layer];
    [self.slider addTarget:self action:@selector(respondsToGasSlider) forControlEvents:UIControlEventValueChanged];
    self.slider.value = 0;
    
    [self.startCreateBtn setBackgroundColor:COLORFROM16(0xEA6204, 1) forState:UIControlStateNormal];
    [self.startCreateBtn setBackgroundColor:COLORFROM16(0xD5D5D5, 1) forState:UIControlStateDisabled];
    
    self.startCreateBtn.enabled = NO;
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToStartCreateBtn:(id)sender {
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

- (void)respondsToGasSlider {
    NSString *number = [NSString notRounding:[NSString stringWithFormat:@"%@", @(self.slider.value)] afterPoint:8];
    self.poundageValueLabel.text = [NSString stringWithFormat:@"%.8lfETH", number.doubleValue];
    
    self.startCreateBtn.enabled = NO;
    NSString *balance = self.currentWalletModel.infoModel.ethModel.balance;
    if (balance.doubleValue != 0) {
        CGFloat selectedPoundage = self.slider.value;
        if (selectedPoundage <= balance.doubleValue &&
            !self.currentWalletModel.isLookWallet) {
            self.startCreateBtn.enabled = YES;
        }
    }
}

#pragma mark ----- Setters And Getters ---------
- (void)setCurrentWalletModel:(DBHWalletManagerForNeoModelList *)currentWalletModel {
    _currentWalletModel = currentWalletModel;
    if (!currentWalletModel) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.choosePayStyleView.tokenName = ETH;
        self.choosePayStyleView.currentWalletId = currentWalletModel.listIdentifier;
        self.choosePayStyleView.dataSource = self.ethWalletsArray;
        
        self.walletInfoView.hidden = NO;
        self.wallletAddressLabel.text = currentWalletModel.address;
        
        NSString *balance = self.currentWalletModel.infoModel.ethModel.balance;
        
        NSString *number = [NSString notRounding:balance afterPoint:4];
        self.walletMaxUseValueLabel.text = [NSString stringWithFormat:@"%.4lfETH", number.doubleValue];
        
        self.startCreateBtn.enabled = NO;
        if (balance.doubleValue != 0) {
            CGFloat selectedPoundage = self.slider.value;
            if (selectedPoundage <= balance.doubleValue) {
                if (currentWalletModel.isLookWallet) {
                    [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Watch wallet is invalid", nil)];
                } else {
                    self.startCreateBtn.enabled = YES;
                }
            }
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
                
                weakSelf.currentWalletModel.ethWallet = EthmobileFromKeyStore(data,password,&error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LCProgressHUD hide];
                    if (!error) {
                        [weakSelf getTransactionCount];
                    } else {
                        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The password is incorrect. Please try again later", nil)];
                    }
                });
            });
        }];
    }
    return _inputPasswordPromptView;
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
