//
//  DBHLookPrivateKeyViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/23.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHLookPrivateKeyViewController.h"

#import "DBHExtractViewController.h"

#import "WalletLeftListModel.h"
#import "WalletInfoGntModel.h"

@interface DBHLookPrivateKeyViewController ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UILabel *privateKeyLabel;
@property (nonatomic, strong) UILabel *privateKeyValueLabel;
@property (nonatomic, strong) UIButton *privateKeyCopyButton;
@property (nonatomic, strong) UIButton *saveLocalButton;

@end

@implementation DBHLookPrivateKeyViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = NSLocalizedString(@"Look Private Key", nil);
    self.view.backgroundColor = COLORFROM16(0xF7F7F8, 1);
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_share"] style:UIBarButtonItemStyleDone target:self action:@selector(respondsToRightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.headImageView];
    [self.view addSubview:self.whiteView];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.qrCodeImageView];
    [self.view addSubview:self.privateKeyLabel];
    [self.view addSubview:self.privateKeyValueLabel];
    [self.view addSubview:self.privateKeyCopyButton];
    [self.view addSubview:self.saveLocalButton];
    
    WEAKSELF
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(56));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(10));
    }];
    [self.whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(50));
        make.height.offset(AUTOLAYOUTSIZE(387));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.headImageView.mas_bottom).offset(AUTOLAYOUTSIZE(10));
    }];
    [self.promptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.whiteView).offset(AUTOLAYOUTSIZE(14));
        make.left.equalTo(weakSelf.whiteView).offset(AUTOLAYOUTSIZE(5.5));
        make.right.equalTo(weakSelf.whiteView).offset(- AUTOLAYOUTSIZE(8));
    }];
    [self.qrCodeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(weakSelf.whiteView.mas_width).offset(- AUTOLAYOUTSIZE(54));
        make.centerX.equalTo(weakSelf.whiteView);
        make.top.equalTo(weakSelf.promptLabel.mas_bottom).offset(AUTOLAYOUTSIZE(16));
    }];
    [self.privateKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.whiteView);
        make.bottom.equalTo(weakSelf.whiteView).offset(- AUTOLAYOUTSIZE(16.5));
    }];
    [self.privateKeyValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(31.5));
        make.right.equalTo(weakSelf.privateKeyCopyButton.mas_left);
        make.bottom.equalTo(weakSelf.saveLocalButton.mas_top).offset(- AUTOLAYOUTSIZE(20.5));
    }];
    [self.privateKeyCopyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(25));
        make.height.offset(AUTOLAYOUTSIZE(30));
        make.right.offset(- AUTOLAYOUTSIZE(17.5));
        make.centerY.equalTo(weakSelf.privateKeyValueLabel);
    }];
    [self.saveLocalButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(50));
        make.height.offset(AUTOLAYOUTSIZE(44));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(46.5));
    }];
}

#pragma mark ------ Event Responds ------
/**
 分享
 */
- (void)respondsToRightBarButtonItem {
    NSArray* activityItems = [[NSArray alloc] initWithObjects:self.model.address,nil];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    //applicationActivities可以指定分享的应用，不指定为系统默认支持的
    
    kWeakSelf(activityVC)
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError)
    {
        if(completed)
        {
            NSLog(@"Share success");
        }
        else
        {
            NSLog(@"Cancel the share");
        }
        [weakactivityVC dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:activityVC animated:YES completion:nil];
}
/**
 复制
 */
- (void)respondsToPrivateKeyCopyButton {
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = self.tokenModel ? self.tokenModel.address : self.model.address;
    [LCProgressHUD showMessage:@"复制成功"];
}
/**
 保存到本地
 */
- (void)respondsToSaveLocalButton {
    NSDictionary *paramters = @{@"jsonrpc":@"2.0",
                                @"method":@"balance",
                                @"params":@[@"AMpupnF6QweQXLfCtF4dR45FDdKbTXkLsr",
                                            @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"],
                                @"id":@(0)};

    [PPNetworkHelper POST:@"http://47.52.227.109:20332/extend" parameters:paramters hudString:@"" success:^(id responseObject) {
        //        [self transferAccountsForNEOWithPassword:passWord];
        NSLog(@"%@", responseObject);
    } failure:^(NSString *error) {
        NSLog(@"%@", error);
    }];
//    DBHExtractViewController *extractViewController = [[DBHExtractViewController alloc] init];
//    [self.navigationController pushViewController:extractViewController animated:YES];
}

#pragma mark ------ Getters And Setters ------
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"关于我们"]];
    }
    return _headImageView;
}
- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _promptLabel.textColor = COLORFROM16(0x333333, 1);
        _promptLabel.numberOfLines = 0;
        
        NSString *prompt = @"您必须保存并备份下面的密钥。如果你失去了他们，你将无法获取/找回你的资产。";
        NSMutableAttributedString *promptAttributedString = [[NSMutableAttributedString alloc] initWithString:prompt];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:AUTOLAYOUTSIZE(5)];
        [promptAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, prompt.length)];
        _promptLabel.attributedText = promptAttributedString;
    }
    return _promptLabel;
}
- (UIImageView *)qrCodeImageView {
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] init];
        _qrCodeImageView.backgroundColor = PICTURECOLOR;
    }
    return _qrCodeImageView;
}
- (UILabel *)privateKeyLabel {
    if (!_privateKeyLabel) {
        _privateKeyLabel = [[UILabel alloc] init];
        _privateKeyLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _privateKeyLabel.text = @"Private key";
        _privateKeyLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _privateKeyLabel;
}
- (UILabel *)privateKeyValueLabel {
    if (!_privateKeyValueLabel) {
        _privateKeyValueLabel = [[UILabel alloc] init];
        _privateKeyValueLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        _privateKeyValueLabel.text = @"xjnj8004jhs97d0fj4mg8xjnj8004jhs97d0fj4mg8";
        _privateKeyValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _privateKeyValueLabel;
}
- (UIButton *)privateKeyCopyButton {
    if (!_privateKeyCopyButton) {
        _privateKeyCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_privateKeyCopyButton setImage:[UIImage imageNamed:@"icon_copy"] forState:UIControlStateNormal];
        [_privateKeyCopyButton addTarget:self action:@selector(respondsToPrivateKeyCopyButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privateKeyCopyButton;
}
- (UIButton *)saveLocalButton {
    if (!_saveLocalButton) {
        _saveLocalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveLocalButton.backgroundColor = COLORFROM16(0x008C55, 1);
        _saveLocalButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)];
        [_saveLocalButton setTitle:@"保存到本地" forState:UIControlStateNormal];
        [_saveLocalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveLocalButton addTarget:self action:@selector(respondsToSaveLocalButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveLocalButton;
}

@end
