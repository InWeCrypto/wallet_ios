//
//  DBHImportWalletViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHImportWalletViewController.h"

#import "ScanVC.h"
#import "DBHCreateWalletViewController.h"
#import "DBHCreateWalletWithNameViewController.h"
#import "DBHWalletDetailViewController.h"

#import "DBHInputPasswordPromptView.h"

#import "DBHWalletManagerForNeoModelList.h"

@interface DBHImportWalletViewController ()<UITextViewDelegate, ScanVCDelegate>

@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIButton *scanQRCodeButton;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UIButton *importButton;
@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;

@property (nonatomic, strong) NeomobileWallet *neoWallet;
@property (nonatomic, assign) NSInteger currentSelectedIndex; // 当前选中下标
@property (nonatomic, copy) NSArray *placeHolderArray;
@property (nonatomic, copy) NSArray *typeArray;

@end

@implementation DBHImportWalletViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Import Wallet", nil);
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.bottomLineView];
    [self.view addSubview:self.scanQRCodeButton];
    [self.view addSubview:self.contentTextView];
    [self.view addSubview:self.placeHolderLabel];
    [self.view addSubview:self.importButton];
    
    WEAKSELF
    [self.scanQRCodeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(57));
        make.height.offset(AUTOLAYOUTSIZE(34));
        make.right.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(15));
    }];
    [self.contentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(39));
        make.height.offset(AUTOLAYOUTSIZE(298));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.scanQRCodeButton.mas_bottom).offset(AUTOLAYOUTSIZE(15));
    }];
    [self.placeHolderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentTextView).offset(AUTOLAYOUTSIZE(7));
        make.right.equalTo(weakSelf.contentTextView).offset(- AUTOLAYOUTSIZE(7));
        make.top.equalTo(weakSelf.contentTextView).offset(AUTOLAYOUTSIZE(9));
    }];
    [self.importButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(45.5));
    }];
    
    for (NSInteger i = 0; i < self.typeArray.count; i++) {
        UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        typeButton.tag = 200 + i;
        typeButton.titleLabel.font = FONT(12);
        typeButton.selected = self.currentSelectedIndex == i;
        [typeButton setTitle:NSLocalizedString(self.typeArray[i], nil) forState:UIControlStateNormal];
        [typeButton setTitleColor:COLORFROM16(0x333333, 1) forState:UIControlStateNormal];
        [typeButton setTitleColor:COLORFROM16(0x0A9234, 1) forState:UIControlStateSelected];
        [typeButton addTarget:self action:@selector(respondsToTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:typeButton];
        
        [typeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.offset([NSString getWidthtWithString:NSLocalizedString(self.typeArray[i], nil) fontSize:12]);
            make.height.offset(AUTOLAYOUTSIZE(30));
            make.left.equalTo(!i ? weakSelf.contentTextView : [weakSelf.view viewWithTag:199 + i].mas_right).offset(!i ? 0 : AUTOLAYOUTSIZE(15));
            make.centerY.equalTo(weakSelf.scanQRCodeButton);
        }];
    }
    
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(13.5));
        make.height.offset(AUTOLAYOUTSIZE(1.5));
        make.centerX.equalTo([weakSelf.view viewWithTag:200]);
        make.bottom.equalTo([weakSelf.view viewWithTag:200]);
    }];
}

#pragma mark ------ UITextViewDelegate ------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *changeAfterString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    self.placeHolderLabel.hidden = changeAfterString.length;
    
    return YES;
}

#pragma mark ------ ScanVCDelegate ------
- (void)scanSucessWithObject:(id)object
{
    //扫一扫回调
    NSString *string = object;
    if (!self.currentSelectedIndex && (![[string substringToIndex:1] isEqualToString:@"{"] || ![[object substringFromIndex:string.length - 1] isEqualToString:@"}"])) {
        [LCProgressHUD showFailure:@"请输入正确的KeyStore"];
        
        return;
    }
    
    self.contentTextView.text = [NSString stringWithFormat:@"%@", object];
}

#pragma mark ------ Event Responds ------
/**
 扫描二维码
 */
- (void)respondsToScanQRCodeButton {
    ScanVC * vc = [[ScanVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 导入
 */
- (void)respondsToImportButton {
    if (!self.contentTextView.text.length) {
        [LCProgressHUD showMessage:@"请确认信息是否完善"];
        return;
    }
    
    WEAKSELF
    switch (self.currentSelectedIndex) {
        case 0: {
            // Keystore
            [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordPromptView];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.inputPasswordPromptView animationShow];
            });
            break;
        }
        case 1: {
            // 助记词
            [LCProgressHUD showLoading:@"验证中..."];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^
                           {
                               //子线程异步执行下载任务，防止主线程卡顿
                               NSError * error;
                               self.neoWallet = NeomobileFromMnemonic(self.contentTextView.text, &error);
                               
                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                               //异步返回主线程，根据获取的数据，更新UI
                               dispatch_async(mainQueue, ^
                                              {
                                                  if (!error)
                                                  {
                                                      [LCProgressHUD hide];
                                                      
//                                                      //创建成功
                                                      if (self.neoWalletModel)
                                                      {
                                                          //观察钱包升级 助记词
                                                          if ([[self.neoWallet address] isEqualToString:self.neoWalletModel.address])
                                                          {
                                                              DBHCreateWalletViewController *createWalletViewController = [[DBHCreateWalletViewController alloc] init];
                                                              createWalletViewController.neoWalletModel = self.neoWalletModel;
                                                              createWalletViewController.neoWallet = self.neoWallet;
                                                              [self.navigationController pushViewController:createWalletViewController animated:YES];
                                                          }
                                                          else
                                                          {
                                                              [LCProgressHUD showMessage:@"该钱包的地址对比不正确,请确认后重试"];
                                                          }
                                                      }
                                                      else
                                                      {
                                                          DBHCreateWalletViewController *createWalletViewController = [[DBHCreateWalletViewController alloc] init];
                                                          createWalletViewController.neoWallet = self.neoWallet;
                                                          [self.navigationController pushViewController:createWalletViewController animated:YES];
                                                      }
                                                  }
                                                  else
                                                  {
                                                      [LCProgressHUD hide];
                                                      [LCProgressHUD showMessage:@"钱包导入失败"];
                                                  }
                                              });
                               
                           });
            
            break;
        }
        case 2: {
            // 私钥
            [LCProgressHUD showLoading:@"验证中..."];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^
                           {
                               //子线程异步执行下载任务，防止主线程卡顿
                               NSError * error;
                               self.neoWallet = NeomobileFromWIF(self.contentTextView.text, &error);
                               
                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                               //异步返回主线程，根据获取的数据，更新UI
                               dispatch_async(mainQueue, ^
                                              {
                                                  if (!error)
                                                  {
                                                      [LCProgressHUD hide];
                                                      //创建成功
                                                      if (self.neoWalletModel)
                                                      {
                                                          //观察钱包升级 私匙
                                                          if ([[self.neoWallet address] isEqualToString:self.neoWalletModel.address])
                                                          {
                                                              DBHCreateWalletViewController *createWalletViewController = [[DBHCreateWalletViewController alloc] init];
                                                              createWalletViewController.neoWalletModel = self.neoWalletModel;
                                                              createWalletViewController.neoWallet = self.neoWallet;
                                                              [self.navigationController pushViewController:createWalletViewController animated:YES];
                                                          }
                                                          else
                                                          {
                                                              [LCProgressHUD showMessage:@"该钱包的地址对比不正确,请确认后重试"];
                                                          }
                                                      }
                                                      else
                                                      {
                                                      DBHCreateWalletViewController *createWalletViewController = [[DBHCreateWalletViewController alloc] init];
                                                      createWalletViewController.neoWallet = self.neoWallet;
                                                      [self.navigationController pushViewController:createWalletViewController animated:YES];
                                                      }
                                                  }
                                                  else
                                                  {
                                                      [LCProgressHUD hide];
                                                      [LCProgressHUD showMessage:@"钱包导入失败"];
                                                  }
                                              });
                               
                           });
            
            break;
        }
        case 3: {
            // 观察
            if ([NSString isNEOAdress:[self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]])
            {
                //创建成功
                DBHCreateWalletWithNameViewController *createWalletWithNameViewController = [[DBHCreateWalletWithNameViewController alloc] init];
                createWalletWithNameViewController.address = [self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [self.navigationController pushViewController:createWalletWithNameViewController animated:YES];
            }
            else
            {
                [LCProgressHUD showMessage:@"请输入正确的钱包地址"];
            }
            
            break;
        }
            
        default:
            break;
    }
}
/**
 类型选择
 */
- (void)respondsToTypeButton:(UIButton *)sender {
    if (sender.tag - 200 == self.currentSelectedIndex) {
        return;
    }
    
    if (self.neoWalletModel && sender.tag - 200 == 3) {
        [LCProgressHUD showMessage:@"已经是观察钱包了"];
        return;
    }
    
    UIButton *lastSelectedButton = [self.view viewWithTag:self.currentSelectedIndex + 200];
    lastSelectedButton.selected = NO;
    
    sender.selected = YES;
    self.currentSelectedIndex = sender.tag - 200;
    
    self.placeHolderLabel.text = NSLocalizedString(self.placeHolderArray[sender.tag - 200], nil);
    
    WEAKSELF
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(13.5));
        make.height.offset(AUTOLAYOUTSIZE(1.5));
        make.centerX.equalTo(sender);
        make.bottom.equalTo([weakSelf.view viewWithTag:200]);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

#pragma mark ------ Getters And Setters ------
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0x0A9234, 1);
    }
    return _bottomLineView;
}
- (UIButton *)scanQRCodeButton {
    if (!_scanQRCodeButton) {
        _scanQRCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanQRCodeButton setImage:[UIImage imageNamed:@"身份证扫描"] forState:UIControlStateNormal];
        [_scanQRCodeButton addTarget:self action:@selector(respondsToScanQRCodeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanQRCodeButton;
}
- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.backgroundColor = COLORFROM16(0xFAFAFA, 1);
        _contentTextView.delegate = self;
        _contentTextView.font = FONT(9);
        _contentTextView.textColor = COLORFROM16(0x333333, 1);
    }
    return _contentTextView;
}
- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.font = FONT(9);
        _placeHolderLabel.text = NSLocalizedString(self.placeHolderArray.firstObject, nil);
        _placeHolderLabel.textColor = COLORFROM16(0xCFCFCF, 1);
        _placeHolderLabel.numberOfLines = 0;
    }
    return _placeHolderLabel;
}
- (UIButton *)importButton {
    if (!_importButton) {
        _importButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _importButton.backgroundColor = COLORFROM16(0xFF841C, 1);
        _importButton.titleLabel.font = BOLDFONT(14);
        _importButton.layer.cornerRadius = AUTOLAYOUTSIZE(2);
        [_importButton setTitle:NSLocalizedString(@"Import", nil) forState:UIControlStateNormal];
        [_importButton addTarget:self action:@selector(respondsToImportButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importButton;
}
- (DBHInputPasswordPromptView *)inputPasswordPromptView {
    if (!_inputPasswordPromptView) {
        _inputPasswordPromptView = [[DBHInputPasswordPromptView alloc] init];
        
        WEAKSELF
        [_inputPasswordPromptView commitBlock:^(NSString *password) {
            NSString *data = self.contentTextView.text;
            [LCProgressHUD showLoading:@"验证中..."];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^
                           {
                               //子线程异步执行下载任务，防止主线程卡顿
                               NSError * error;
                               
                               weakSelf.neoWallet = NeomobileFromKeyStore(data, password, &error);
                               
                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                               //异步返回主线程，根据获取的数据，更新UI
                               dispatch_async(mainQueue, ^
                                              {
                                                  if (!error)
                                                  {
                                                      [LCProgressHUD hide];
                                                      //创建成功
                                                      if (self.neoWalletModel)
                                                      {
                                                          //观察钱包升级 keyStore
                                                          if ([[self.neoWallet address] isEqualToString:self.neoWalletModel.address])
                                                          {
                                                              [LCProgressHUD showMessage:@"转化成功"];
                                                              [PDKeyChain save:[self.neoWallet address] data:data];
                                                              DBHWalletDetailViewController *walletDetailViewController = [[DBHWalletDetailViewController alloc] init];
                                                              self.neoWalletModel.isLookWallet = NO;
                                                              walletDetailViewController.neoWalletModel = self.neoWalletModel;
                                                              walletDetailViewController.backIndex = 2;
                                                              [weakSelf.navigationController pushViewController:walletDetailViewController animated:YES];
                                                          }
                                                          else
                                                          {
                                                              [LCProgressHUD showMessage:@"该钱包的地址对比不正确,请确认后重试"];
                                                          }
                                                      }
                                                      else
                                                      {
                                                      DBHCreateWalletViewController *createWalletViewController = [[DBHCreateWalletViewController alloc] init];
                                                      createWalletViewController.neoWallet = self.neoWallet;
                                                      [self.navigationController pushViewController:createWalletViewController animated:YES];
                                                          [PDKeyChain save:[self.neoWallet address] data:data];
                                                      }
                                                  }
                                                  else
                                                  {
                                                      [LCProgressHUD hide];
                                                      [LCProgressHUD showMessage:@"钱包输入密码错误"];
                                                  }
                                              });
                               
                           });
        }];
    }
    return _inputPasswordPromptView;
}

- (NSArray *)placeHolderArray {
    if (!_placeHolderArray) {
        _placeHolderArray = @[@"Copy and paste the contents of the keystore file, you can also scan the two-dimensional code through the upper right corner, enter the information",
                              @"Please enter a security code, separated by space",
                              @"Please enter the explicit private key",
                              @"Watch the wallet, you only need to import the wallet address, you can conduct day-to-day account management and transactions. Large assets suggest cold wallet or other means of management, to avoid leakage, stolen"];
    }
    return _placeHolderArray;
}
- (NSArray *)typeArray {
    if (!_typeArray) {
        _typeArray = @[@"Keystore",
                       @"Safety Code",
                       @"Private Key",
                       @"Observation"];
    }
    return _typeArray;
}

@end
