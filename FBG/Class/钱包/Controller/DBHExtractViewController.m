//
//  DBHExtractViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHExtractViewController.h"

#import "WalletInfoGntModel.h"

@interface DBHExtractViewController ()<PassWordViewDelegate>

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *maxExtractGasLabel;
@property (nonatomic, strong) UILabel *maxExtractGasValueLabel;
@property (nonatomic, strong) UILabel *noExtractGasLabel;
@property (nonatomic, strong) UIButton *unfreezeButton;
@property (nonatomic, strong) UILabel *applyExtractGasLabel;
@property (nonatomic, strong) UITextField *extractGasTextField;
@property (nonatomic, strong) UIView *orangeLineView;
@property (nonatomic, strong) UILabel *canExtractGasLabel;
@property (nonatomic, strong) UIButton *allExtractButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) PassWordView * password;

@property (nonatomic, assign) NSInteger type; // 1:解冻 2:提取

@end

@implementation DBHExtractViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Extract", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.boxView];
    [self.view addSubview:self.maxExtractGasLabel];
    [self.view addSubview:self.maxExtractGasValueLabel];
    [self.view addSubview:self.noExtractGasLabel];
    [self.view addSubview:self.unfreezeButton];
    [self.view addSubview:self.applyExtractGasLabel];
    [self.view addSubview:self.extractGasTextField];
    [self.view addSubview:self.orangeLineView];
    [self.view addSubview:self.canExtractGasLabel];
    [self.view addSubview:self.allExtractButton];
    [self.view addSubview:self.sureButton];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(152));
        make.top.centerX.equalTo(weakSelf.view);
    }];
    [self.maxExtractGasLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(32));
    }];
    [self.maxExtractGasValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(4));
    }];
    [self.noExtractGasLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(11));
        make.bottom.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(11.5));
    }];
    [self.unfreezeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(40));
        make.height.offset(AUTOLAYOUTSIZE(14));
        make.left.equalTo(weakSelf.noExtractGasLabel.mas_right).offset(AUTOLAYOUTSIZE(5));
        make.centerY.equalTo(weakSelf.noExtractGasLabel);
    }];
    [self.applyExtractGasLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.boxView.mas_bottom).offset(AUTOLAYOUTSIZE(37));
    }];
    [self.extractGasTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.orangeLineView);
        make.height.offset(AUTOLAYOUTSIZE(62.5));
        make.bottom.centerX.equalTo(weakSelf.orangeLineView);
    }];
    [self.orangeLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(168));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.applyExtractGasLabel.mas_bottom).offset(AUTOLAYOUTSIZE(67.5));
    }];
    [self.canExtractGasLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.orangeLineView);
        make.top.equalTo(weakSelf.orangeLineView.mas_bottom).offset(AUTOLAYOUTSIZE(7.5));
    }];
    [self.allExtractButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(AUTOLAYOUTSIZE(29));
        make.centerY.equalTo(weakSelf.canExtractGasLabel);
        make.right.equalTo(weakSelf.orangeLineView);
    }];
    [self.sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(88));
        make.height.offset(AUTOLAYOUTSIZE(42));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(36.5));
    }];
}

#pragma mark ------ PassWordViewDelegate ------
/**
 取消支付
 */
- (void)canel
{
    [self caneButtonClicked];
}
- (void)sureWithPassWord:(NSString *)passWord {
    //确认支付
    [LCProgressHUD showLoading:@"验证中..."];
    
    WEAKSELF
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^
                   {
                       if (weakSelf.type == 1) {
                           // 解冻
                           [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoUtxo?address=%@&type=%@", self.model.address, @"neo-asset-id"] isOtherBaseUrl:NO parameters:nil hudString:@"" success:^(id responseObject) {
                               NSArray *result = responseObject[@"result"];
                               [self transferAccountsForNEOWithPassword:passWord unspent:[result toJSONStringForArray]];
                           } failure:^(NSString *error) {
                               [LCProgressHUD showFailure:error];
                           }];
                       } else {
                           // 提取
                           [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoClaimUtxo?address=%@", self.model.address] isOtherBaseUrl:NO parameters:nil hudString:@"" success:^(id responseObject) {
                               NSArray *result = responseObject[@"result"][@"Claims"];
                               [self transferAccountsForNEOWithPassword:passWord unspent:[result toJSONStringForArray]];
                           } failure:^(NSString *error) {
                               [LCProgressHUD showFailure:error];
                           }];
                       }
                   });
}

#pragma mark ------ Data ------
// 上传后台提交NEO订单
- (void)creatNeoOrderWithData:(NSString *)data trade_no:(NSString *)trade_no
{
    //创建钱包订单
    NSString *assert = self.type == 1 ? @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b" : @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7";
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(self.model.id) forKey:@"wallet_id"];
    [dic setObject:data forKey:@"data"];
    [dic setObject:self.model.address forKey:@"pay_address"];
    [dic setObject:self.model.address forKey:@"receive_address"];
    [dic setObject:@"" forKey:@"remark"];
    [dic setObject:self.type == 1 ? self.neoModel.balance : self.model.balance forKey:@"fee"];
    [dic setObject:@"0" forKey:@"handle_fee"];
    [dic setObject:@"NEO" forKey:@"flag"];
    [dic setObject:[NSString stringWithFormat:@"0x%@", trade_no] forKey:@"trade_no"];
    [dic setObject:assert forKey:@"asset_id"];
    
    [PPNetworkHelper POST:@"wallet-order" parameters:dic hudString:@"创建中..." success:^(id responseObject)
     {
         [LCProgressHUD showMessage:@"订单创建成功"];
         [self.navigationController popViewControllerAnimated:YES];
         
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:self.type == 1 ? @"解冻失败" : @"提取失败"];
     }];
}

#pragma mark ------ Event Responds ------
/**
 解冻
 */
- (void)respondsToUnfreezeButton {
    if (self.model.noExtractbalance.floatValue <= 0) {
        [LCProgressHUD showFailure:@"暂未可解冻的Gas"];
        
        return;
    }
    if (self.neoModel.balance.floatValue <= 0) {
        [LCProgressHUD showFailure:@"NEO数量不够 解冻失败"];
        
        return;
    }
    
    self.type = 1;
    self.password.titleLN.text = @"请输入密码";
    self.password.infoLB.text = @"";
    [self.maskView addToWindow];
    [self.password addToWindow];
    [self.password springingAnimation];
    [self.password begainFirstResponder];
}
/**
 全部提取
 */
- (void)respondsToAllExtractButton {
    self.extractGasTextField.text = [NSString stringWithFormat:@"%.8lf", self.model.balance.floatValue];
}
/**
 确定
 */
- (void)respondsToSureButton {
    if (self.model.balance.floatValue <= 0) {
        [LCProgressHUD showFailure:@"暂未可提取的Gas"];
        
        return;
    }
    
    self.type = 2;
    self.password.titleLN.text = @"请输入密码";
    self.password.infoLB.text = @"";
    [self.maskView addToWindow];
    [self.password addToWindow];
    [self.password springingAnimation];
    [self.password begainFirstResponder];
}
/**
 取消支付
 */
- (void)caneButtonClicked {
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

#pragma mark ------ Private Methods ------
/**
 NEO转账
 */
- (void)transferAccountsForNEOWithPassword:(NSString *)password unspent:(NSString *)unspent {
    id data = [PDKeyChain load:self.model.address];
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
                           //热钱包代币转账
                           //生成data
                           NSError * error;
                           NeomobileTx *tx;
                           if (self.type == 1) {
                               // 解冻
                               tx = [Wallet createAssertTx:@"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b" from:self.neoModel.address to:self.neoModel.address amount:self.neoModel.balance.doubleValue unspent:unspent error:&error];
                           } else {
                               // 提取
                               tx = [Wallet createClaimTx:self.model.balance.doubleValue address:self.model.address unspent:unspent error:&error];
                           }
                           
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
                                                  [self creatNeoOrderWithData:tx.data trade_no:tx.id_];
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
                           [LCProgressHUD hide];
                           [self caneButtonClicked];
                           [LCProgressHUD showMessage:@"密码错误，请稍后重试"];
                       }
                   });
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(WalletInfoGntModel *)model {
    _model = model;
    
    self.maxExtractGasValueLabel.text = _model.balance;
    self.noExtractGasLabel.text = [NSString stringWithFormat:@"不可提取Gas：%@", _model.noExtractbalance];
    self.canExtractGasLabel.text = [NSString stringWithFormat:@"可提取1.000-%@", _model.balance];
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = COLORFROM16(0x158A1B, 1);
    }
    return _boxView;
}
- (UILabel *)maxExtractGasLabel {
    if (!_maxExtractGasLabel) {
        _maxExtractGasLabel = [[UILabel alloc] init];
        _maxExtractGasLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _maxExtractGasLabel.text = @"最高可提取Gas";
        _maxExtractGasLabel.textColor = COLORFROM16(0xD7D7D7, 1);
    }
    return _maxExtractGasLabel;
}
- (UILabel *)maxExtractGasValueLabel {
    if (!_maxExtractGasValueLabel) {
        _maxExtractGasValueLabel = [[UILabel alloc] init];
        _maxExtractGasValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(32)];
        _maxExtractGasValueLabel.textColor = COLORFROM16(0xF7F7F7, 1);
    }
    return _maxExtractGasValueLabel;
}
- (UILabel *)noExtractGasLabel {
    if (!_noExtractGasLabel) {
        _noExtractGasLabel = [[UILabel alloc] init];
        _noExtractGasLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(10)];
        _noExtractGasLabel.textColor = COLORFROM16(0xD7D7D7, 1);
    }
    return _noExtractGasLabel;
}
- (UIButton *)unfreezeButton {
    if (!_unfreezeButton) {
        _unfreezeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _unfreezeButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(10)];
        _unfreezeButton.layer.cornerRadius = AUTOLAYOUTSIZE(7);
        _unfreezeButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _unfreezeButton.layer.borderWidth = AUTOLAYOUTSIZE(0.5);
        [_unfreezeButton setTitle:@"解冻" forState:UIControlStateNormal];
        [_unfreezeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_unfreezeButton addTarget:self action:@selector(respondsToUnfreezeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unfreezeButton;
}
- (UILabel *)applyExtractGasLabel {
    if (!_applyExtractGasLabel) {
        _applyExtractGasLabel = [[UILabel alloc] init];
        _applyExtractGasLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _applyExtractGasLabel.text = @"申请提取";
        _applyExtractGasLabel.textColor = COLORFROM16(0x000000, 1);
    }
    return _applyExtractGasLabel;
}
- (UITextField *)extractGasTextField {
    if (!_extractGasTextField) {
        _extractGasTextField = [[UITextField alloc] init];
        _extractGasTextField.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(24)];
        _extractGasTextField.textColor = COLORFROM16(0x333333, 1);
        _extractGasTextField.textAlignment = NSTextAlignmentCenter;
        _extractGasTextField.keyboardType = UIKeyboardTypeDecimalPad;
//        _extractGasTextField.placeholder = @"请输入提取金额";
        _extractGasTextField.userInteractionEnabled = NO;
        _extractGasTextField.text = @"0.00000000";
    }
    return _extractGasTextField;
}
- (UIView *)orangeLineView {
    if (!_orangeLineView) {
        _orangeLineView = [[UIView alloc] init];
        _orangeLineView.backgroundColor = COLORFROM16(0xFB7B33, 1);
    }
    return _orangeLineView;
}
- (UILabel *)canExtractGasLabel {
    if (!_canExtractGasLabel) {
        _canExtractGasLabel = [[UILabel alloc] init];
        _canExtractGasLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(10)];
        _canExtractGasLabel.textColor = COLORFROM16(0xA8A8A8, 1);
    }
    return _canExtractGasLabel;
}
- (UIButton *)allExtractButton {
    if (!_allExtractButton) {
        _allExtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _allExtractButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(10)];
        [_allExtractButton setTitle:@"全部提取" forState:UIControlStateNormal];
        [_allExtractButton setTitleColor:COLORFROM16(0xF95A00, 1) forState:UIControlStateNormal];
        [_allExtractButton addTarget:self action:@selector(respondsToAllExtractButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allExtractButton;
}
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = COLORFROM16(0x158A1B, 1);
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(respondsToSureButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
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

@end
