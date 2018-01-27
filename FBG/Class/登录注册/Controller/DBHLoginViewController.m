//
//  DBHLoginViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/19.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHLoginViewController.h"

#import <HyphenateLite/HyphenateLite.h>

#import "DBHForgetPasswordViewController.h"
#import "DBHSignUpViewController.h"

@interface DBHLoginViewController ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *helloLabel;
@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UIView *firsetLineView;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *showPasswordButton;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UIButton *forgetPasswordButton;
@property (nonatomic, strong) UIButton *enterWalletButton;
@property (nonatomic, strong) UIButton *registerButton;

@end

@implementation DBHLoginViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

#pragma mark ------ Touch ------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.helloLabel];
    [self.view addSubview:self.welcomeLabel];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.firsetLineView];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.showPasswordButton];
    [self.view addSubview:self.secondLineView];
    [self.view addSubview:self.forgetPasswordButton];
    [self.view addSubview:self.enterWalletButton];
    [self.view addSubview:self.registerButton];
    
    WEAKSELF
    [self.backImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(73.5));
        make.right.bottom.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(173));
    }];
    [self.helloLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(AUTOLAYOUTSIZE(2));
        make.left.offset(AUTOLAYOUTSIZE(35));
    }];
    [self.welcomeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.helloLabel);
        make.top.equalTo(weakSelf.helloLabel.mas_bottom).offset(AUTOLAYOUTSIZE(15));
    }];
    [self.accountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(AUTOLAYOUTSIZE(48));
        make.left.equalTo(weakSelf.firsetLineView);
        make.right.equalTo(weakSelf.showPasswordButton.mas_left);
        make.bottom.equalTo(weakSelf.firsetLineView);
    }];
    [self.firsetLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(70));
        make.height.offset(AUTOLAYOUTSIZE(1.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.secondLineView.mas_top).offset(- AUTOLAYOUTSIZE(80));
    }];
    [self.passwordTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.firsetLineView);
        make.right.equalTo(weakSelf.showPasswordButton.mas_left);
        make.height.equalTo(weakSelf.accountTextField);
        make.bottom.equalTo(weakSelf.secondLineView);
    }];
    [self.showPasswordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(34.5));
        make.height.equalTo(weakSelf.passwordTextField);
        make.right.offset(- AUTOLAYOUTSIZE(25));
        make.centerY.equalTo(weakSelf.passwordTextField);
    }];
    [self.secondLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.firsetLineView);
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.enterWalletButton.mas_top).offset(- AUTOLAYOUTSIZE(99));
    }];
    [self.forgetPasswordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(AUTOLAYOUTSIZE(27));
        make.right.equalTo(weakSelf.firsetLineView);
        make.top.equalTo(weakSelf.secondLineView.mas_bottom);
    }];
    [self.enterWalletButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.firsetLineView);
        make.height.offset(AUTOLAYOUTSIZE(39));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(214.5));
    }];
    [self.registerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(50));
        make.height.offset(AUTOLAYOUTSIZE(32));
        make.top.equalTo(weakSelf.enterWalletButton.mas_bottom);
        make.centerX.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ Data ------
/**
 登录
 */
- (void)login {
    NSDictionary *paramters = @{@"email":self.accountTextField.text,
                                @"password":self.passwordTextField.text};
    
    WEAKSELF
    [PPNetworkHelper POST:@"login" baseUrlType:3 parameters:paramters hudString:[NSString stringWithFormat:@"%@...", NSLocalizedString(@"Log in", nil)] success:^(id responseObject) {
        EMError *error = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"%@", responseObject[@"id"]] password:weakSelf.passwordTextField.text];
        if (!error) {
            // 环信登录成功
            [UserSignData share].user.token = responseObject[@"token"];
            [UserSignData share].user.open_id = [NSString stringWithFormat:@"%@", responseObject[@"id"]];
            [UserSignData share].user.email = responseObject[@"email"];
            [UserSignData share].user.nickname = responseObject[@"name"];
            [UserSignData share].user.img = responseObject[@"img"];
            [UserSignData share].user.walletUnitType = 1;
            [[UserSignData share] storageData:[UserSignData share].user];
            
            [[AppDelegate delegate] goToTabbar];
        } else {
            [LCProgressHUD showFailure:NSLocalizedString(@"Login Failed", nil)];
        }
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 显示/隐藏密码
 */
- (void)respondsToShowPasswordButton:(UIButton *)button {
    button.selected = !button.selected;
    self.passwordTextField.secureTextEntry = !button.isSelected;
}
/**
 忘记密码
 */
- (void)respondsToforgetPasswordButton {
    DBHForgetPasswordViewController *forgetPasswordViewController = [[DBHForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetPasswordViewController animated:YES];
}
/**
 进入钱包
 */
- (void)respondsToenterWalletButton {
    if (!self.accountTextField.text.length) {
        [LCProgressHUD showFailure:NSLocalizedString(@"Please input a email", nil)];
        return;
    }
    if (!self.passwordTextField.text.length) {
        [LCProgressHUD showFailure:NSLocalizedString(@"Please input a password", nil)];
        return;
    }
    
    [self.view endEditing:YES];
    [self login];
}
/**
 注册
 */
- (void)respondsToregisterButton {
    DBHSignUpViewController *signUpViewController = [[DBHSignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpViewController animated:YES];
}

#pragma mark ------ Getters And Setters ------
- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denglu_bg"]];
    }
    return _backImageView;
}
- (UILabel *)helloLabel {
    if (!_helloLabel) {
        _helloLabel = [[UILabel alloc] init];
        _helloLabel.font = BOLDFONT(25);
        _helloLabel.text = DBHGetStringWithKeyFromTable(@"Hello,", nil);
        _helloLabel.textColor = COLORFROM16(0xFF841C, 1);
    }
    return _helloLabel;
}
- (UILabel *)welcomeLabel {
    if (!_welcomeLabel) {
        _welcomeLabel = [[UILabel alloc] init];
        _welcomeLabel.font = BOLDFONT(25);
        _welcomeLabel.text = DBHGetStringWithKeyFromTable(@"Welcome Back!", nil);
        _welcomeLabel.textColor = COLORFROM16(0xFF841C, 1);
    }
    return _welcomeLabel;
}
- (UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc] init];
        _accountTextField.font = FONT(14);
        _accountTextField.textColor = COLORFROM16(0x333333, 1);
        _accountTextField.placeholder = DBHGetStringWithKeyFromTable(@"Email", nil);
    }
    return _accountTextField;
}
- (UIView *)firsetLineView {
    if (!_firsetLineView) {
        _firsetLineView = [[UIView alloc] init];
        _firsetLineView.backgroundColor = COLORFROM16(0xECECEC, 1);
    }
    return _firsetLineView;
}
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.font = FONT(14);
        _passwordTextField.textColor = COLORFROM16(0x333333, 1);
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.placeholder = DBHGetStringWithKeyFromTable(@"Password", nil);
    }
    return _passwordTextField;
}
- (UIButton *)showPasswordButton {
    if (!_showPasswordButton) {
        _showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPasswordButton setImage:[UIImage imageNamed:@"denglu_eyes_open"] forState:UIControlStateNormal];
        [_showPasswordButton setImage:[UIImage imageNamed:@"denglu_eyes_close"] forState:UIControlStateSelected];
        [_showPasswordButton addTarget:self action:@selector(respondsToShowPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordButton;
}
- (UIView *)secondLineView {
    if (!_secondLineView) {
        _secondLineView = [[UIView alloc] init];
        _secondLineView.backgroundColor = COLORFROM16(0xECECEC, 1);
    }
    return _secondLineView;
}
- (UIButton *)forgetPasswordButton {
    if (!_forgetPasswordButton) {
        _forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetPasswordButton.titleLabel.font = FONT(11);
        [_forgetPasswordButton setTitle:NSLocalizedString(@"Forget the password？", nil) forState:UIControlStateNormal];
        [_forgetPasswordButton setTitleColor:COLORFROM16(0xDADDDC, 1) forState:UIControlStateNormal];
        [_forgetPasswordButton addTarget:self action:@selector(respondsToforgetPasswordButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPasswordButton;
}
- (UIButton *)enterWalletButton {
    if (!_enterWalletButton) {
        _enterWalletButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterWalletButton.backgroundColor = COLORFROM16(0xFF841C, 1);
        _enterWalletButton.titleLabel.font = BOLDFONT(14);
        _enterWalletButton.layer.cornerRadius = AUTOLAYOUTSIZE(2);
        _enterWalletButton.clipsToBounds = YES;
        
        [_enterWalletButton setTitle:NSLocalizedString(@"Enter InWeCrypto", nil) forState:UIControlStateNormal];
        [_enterWalletButton addTarget:self action:@selector(respondsToenterWalletButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterWalletButton;
}
- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.titleLabel.font = FONT(14);
        [_registerButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
        [_registerButton setTitleColor:COLORFROM16(0x008C55, 1) forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(respondsToregisterButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

@end
