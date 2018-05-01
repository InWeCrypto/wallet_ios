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
#import "YYRedPacketModels.h"
#import "DBHWalletManagerForNeoDataModels.h"
#import "DBHWalletDetailTokenInfomationModelData.h"
#import "YYWalletOtherInfoModel.h"
#import "IQKeyboardManager.h"
#import "YYWalletConversionListModel.h"

#define MAX_SEND_COUNT(count) [NSString stringWithFormat:@"%d%@", count, DBHGetStringWithKeyFromTable(@"  ", nil)]

typedef void(^CompletionBlock) (void);

@interface YYRedPacketSendFirstViewController ()

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


@property (nonatomic, strong) YYRedPacketChoosePayStyleView *choosePayStyleView;
@property (nonatomic, strong) YYRedPacketEthTokenModel *tokenModel; // 作为礼金的代币
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *maxBalanceWalletModel;

@end

@implementation YYRedPacketSendFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    self.walletInfoView.hidden = YES;
    self.noWalletView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self redPacketNavigationBar];
}

/**
 父类方法
 */
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(18)}];
}

- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Send RedPacket", nil);
    
    self.firstLabel.text = DBHGetStringWithKeyFromTable(@"First:", nil);
    self.pullMoneyLabel.text = DBHGetStringWithKeyFromTable(@"Authorization For Use RedPacket", nil);
    
    [self.chooseETHBtn setTitle:DBHGetStringWithKeyFromTable(@"Choose Below Authorization", nil) forState:UIControlStateNormal];
    
    self.sendSumTitleLabel.text = DBHGetStringWithKeyFromTable(@"Send Amount", nil);
    self.sendCountTitleLabel.text = DBHGetStringWithKeyFromTable(@"Send Count", nil);
    
    self.maxSendTipLabel.text = DBHGetStringWithKeyFromTable(@"(Max Availuable Send:", nil);
    self.maxSendValueLabel.text = MAX_SEND_COUNT(100);
    
    self.slider.value = 0;
    
    [self.payBtn setTitle:DBHGetStringWithKeyFromTable(@"Pay", nil) forState:UIControlStateNormal];
    self.walletMaxUseTitleLabel.text = DBHGetStringWithKeyFromTable(@"Max Avaliable Amount:", nil);

    self.slowLabel.text = DBHGetStringWithKeyFromTable(@"Slow", nil);
    self.fastLabel.text = DBHGetStringWithKeyFromTable(@"Fast", nil);
    self.feeLabel.text = DBHGetStringWithKeyFromTable(@"Pitman Cost", nil);
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.25, 4);
    layer.backgroundColor = COLORFROM16(0x029857, 1).CGColor;
    [self.progressView.layer addSublayer:layer];
    
    [self.payBtn setCorner:2];
    
    [self.payBtn setBackgroundColor:COLORFROM16(0xEA6204, 1) forState:UIControlStateNormal];
    [self.payBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    self.noWalletTip1Label.text = DBHGetStringWithKeyFromTable(@"Your wallet has not this property,", nil);
    self.noWalletTip2Label.text = DBHGetStringWithKeyFromTable(@"Please ", nil);
    [self.addWalletBtn setTitle:DBHGetStringWithKeyFromTable(@"Add Wallet", nil) forState:UIControlStateNormal];
    self.noWalletTip3Label.text = DBHGetStringWithKeyFromTable(@" Send redpacket after saved property", nil);
    
    self.sendUnitLabel.text = @"";
    
    self.payBtn.enabled = NO;
}

#pragma mark ----- respondsToBtn ---------
- (IBAction)respondsToPayBtn:(UIButton *)sender {
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

- (void)handleTokenListReponse:(id)responseObj withWallet:(DBHWalletManagerForNeoModelList *)walletModel completion:(CompletionBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *tempTokensArr = nil;
        if (![NSObject isNulllWithObject:responseObj] && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArray = responseObj[LIST];
            if (![NSObject isNulllWithObject:dataArray] &&
                [dataArray isKindOfClass:[NSArray class]] &&
                dataArray.count > 0) {
                tempTokensArr = [NSMutableArray array];
                NSString *typeName = walletModel.category.name;
                for (NSDictionary *dict in dataArray) {
                    @autoreleasepool {
                        YYWalletConversionListModel *listModel = [YYWalletConversionListModel mj_objectWithKeyValues:dict];
                        
                        NSString *price_cny = listModel.gnt_category.cap.priceCny;
                        NSString *price_usd = listModel.gnt_category.cap.priceUsd;
                        
                        NSString *symbol = listModel.symbol;
                        NSString *balance = listModel.balance;
                        NSInteger decimals = listModel.decimals;
                        
                        DBHWalletDetailTokenInfomationModelData *model = [[DBHWalletDetailTokenInfomationModelData alloc] init];
                        model.address = listModel.gnt_category.address;
                        model.symbol = symbol;
                        model.typeName = typeName;
                        model.name = listModel.gnt_category.name;
                        model.icon = listModel.gnt_category.icon;
                        model.flag = model.name;
                        
                        model.priceCny = price_cny;
                        model.priceUsd = price_usd;
                        
                        NSString *temp, *second = @"0";
                        if (![NSObject isNulllWithObject:balance] && balance.length > 2) {
                            temp = [NSString numberHexString:[balance substringFromIndex:2]];
                            second = [NSString DecimalFuncWithOperatorType:3 first:temp secend:[NSString stringWithFormat:@"%lf", pow(10, decimals)] value:8];
                            
                            // 代币数量统计
                            [walletModel.tokenStatistics setObject:second forKey:model.name];
                        }
                        model.balance = second;
                        
                        [tempTokensArr addObject:model];
                        
                        if ([model.name isEqualToString:self.tokenModel.name]) { // 作为礼金的代币
                            if (self.maxBalanceWalletModel.balance.doubleValue < second.doubleValue) {
                                self.maxBalanceWalletModel.balance = second;
                                self.maxBalanceWalletModel = walletModel;
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (self.maxBalanceWalletModel.balance == 0) {
                                    self.noWalletView.hidden = NO;
                                    self.walletInfoView.hidden = YES;
                                } else {
                                    self.noWalletView.hidden = YES;
                                    self.walletInfoView.hidden = NO;
                                    self.walletAddressLabel.text = self.maxBalanceWalletModel.address;
                    
                                    NSString *number = [NSString notRounding:self.maxBalanceWalletModel.balance afterPoint:8];
                                    number = [NSString stringWithFormat:@"%.8lf", number.doubleValue];
                                    self.walletMaxUseValueLabel.text = [NSString stringWithFormat:@"%@%@", number, self.tokenModel.name];
                                }
                            });
                        }
                    }
                }
            }
        }
        
        YYWalletOtherInfoModel *infoModel = walletModel.infoModel;
        if (!infoModel) {
            infoModel = [[YYWalletOtherInfoModel alloc] init];
        }
        
        infoModel.tokensArray = tempTokensArr;
        
        if (completion) {
            completion();
        }
    });
}

- (void)handleConversionReponse:(id)responseObj withWallet:(DBHWalletManagerForNeoModelList *)walletModel completion:(CompletionBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![NSObject isNulllWithObject:responseObj]) {
            NSArray *dataArray = responseObj[LIST];
            
            DBHWalletDetailTokenInfomationModelData *ethModel = [[DBHWalletDetailTokenInfomationModelData alloc] init];
            ethModel.name = ETH;
            ethModel.icon = ETH;
            ethModel.flag = ETH;
            
            if (![NSObject isNulllWithObject:dataArray] && dataArray.count > 0) {
                for (NSDictionary *dict in dataArray) {
                    @autoreleasepool {
                        DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:dict];
                        
                        NSString *price_cny = model.category.cap.priceCny;
                        NSString *price_usd = model.category.cap.priceUsd;
                        NSString *balance = model.balance;
                        
                        NSString *second = balance;
                        if (model.categoryId == 1) { //ETH
                            NSString *temp = @"0";
                            if (![NSObject isNulllWithObject:balance] && balance.length > 2) {
                                temp = [NSString numberHexString:[balance substringFromIndex:2]];
                            }
                            second = [NSString DecimalFuncWithOperatorType:3 first:temp secend:@"1000000000000000000" value:8];
                            
                            ethModel.balance = second;
                            ethModel.priceCny = price_cny;
                            ethModel.priceUsd = price_usd;
                            ethModel.address = model.address;
                        }
                    }
                }
            } else {
                ethModel.balance = @"0";
                ethModel.priceCny = @"0";
                ethModel.priceUsd = @"0";
            }
            
            YYWalletOtherInfoModel *infoModel = walletModel.infoModel;
            if (!infoModel) {
                infoModel = [[YYWalletOtherInfoModel alloc] init];
            }
            
            infoModel.ethModel = ethModel;
        }
        
        if (completion) {
            completion();
        }
    });
}

// 遍历钱包，获取该钱包的指定代币
- (void)getMaxBalanceWallet {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.ethWalletsArr.count > 0) {
            // 创建全局并行
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_t group = dispatch_group_create();
            
            for (DBHWalletManagerForNeoModelList *model in self.ethWalletsArr) {
                @autoreleasepool {
                    WEAKSELF
                    dispatch_group_enter(group);
                    dispatch_group_async(group, queue, ^{ // 获取该ETH钱包下的代币列表
                        [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%ld", (NSInteger)model.listIdentifier] baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
                            [weakSelf handleTokenListReponse:responseObject withWallet:model completion:^{
                                dispatch_group_leave(group);
                            }];
                        } failure:^(NSString *error) {
                            [weakSelf handleTokenListReponse:nil withWallet:model completion:^{
                                dispatch_group_leave(group);
                            }];
                        }];
                    });
                    
                    NSDictionary *paramsDict = @{@"wallet_ids" : [@[@(model.listIdentifier)] toJSONStringForArray]};
                    dispatch_group_enter(group);
                    dispatch_group_async(group, queue, ^{
                          // 获取ETH
                        [PPNetworkHelper GET:@"conversion" baseUrlType:1 parameters:paramsDict hudString:nil success:^(id responseObject) {
                            [weakSelf handleConversionReponse:responseObject withWallet:model completion:^{
                                dispatch_group_leave(group);
                            }];
                        } failure:^(NSString *error) {
                            [weakSelf handleConversionReponse:nil withWallet:model completion:^{
                                dispatch_group_leave(group);
                            }];
                        }];
                    });
                    
                }
            }
            
            dispatch_group_notify(group, queue, ^{
            });
        } else { // 钱包为空
            dispatch_async(dispatch_get_main_queue(), ^{
                self.noWalletView.hidden = NO;
                self.walletInfoView.hidden = YES;
            });
        }
    });
}
 
#pragma mark ----- Setters And Getters ---------
- (void)setTokenModel:(YYRedPacketEthTokenModel *)tokenModel {
    if ([_tokenModel isEqual:tokenModel]) {
        return;
    }
    
    _tokenModel = tokenModel;
    [self getMaxBalanceWallet];
}

- (DBHInputPasswordPromptView *)inputPasswordPromptView {
    if (!_inputPasswordPromptView) {
        _inputPasswordPromptView = [[DBHInputPasswordPromptView alloc] init];
        
        _inputPasswordPromptView.placeHolder = DBHGetStringWithKeyFromTable(@"Please input a password", nil);
        WEAKSELF
        [_inputPasswordPromptView commitBlock:^(NSString *password) {
            //YYTODO 去打包
            YYRedPacketPackagingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_PACKAGING_STORYBOARD_ID];
            vc.packageType = PackageTypeCash;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _inputPasswordPromptView;
}

- (YYRedPacketChoosePayStyleView *)choosePayStyleView {
    if (!_choosePayStyleView) {
        _choosePayStyleView = [[YYRedPacketChoosePayStyleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        [_choosePayStyleView setBlock:^(id model) {
           //YYTODO
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
