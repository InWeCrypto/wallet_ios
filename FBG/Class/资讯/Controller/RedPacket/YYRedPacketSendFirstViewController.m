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

#define MAX_SEND_COUNT(count) [NSString stringWithFormat:@"%d%@", count, DBHGetStringWithKeyFromTable(@"  ", nil)]

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

@end

@implementation YYRedPacketSendFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    self.walletInfoView.hidden = NO;
    self.noWalletView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"redpacket_navigation"] forBarMetrics:UIBarMetricsDefault];
}

/**
 父类方法
 */
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(20)}];
}

- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Send RedPacket", nil);
    
    self.firstLabel.text = DBHGetStringWithKeyFromTable(@"First:", nil);
    self.pullMoneyLabel.text = DBHGetStringWithKeyFromTable(@"Authorization For Use RedPacket", nil);
    
    [self.chooseETHBtn setTitle:DBHGetStringWithKeyFromTable(@"Choose Below Authorization", nil) forState:UIControlStateNormal];
    
    self.sendSumTitleLabel.text = DBHGetStringWithKeyFromTable(@"Send Amount", nil);
    self.sendCountTitleLabel.text = DBHGetStringWithKeyFromTable(@"Send Count", nil);
    
    self.maxSendTipLabel.text = DBHGetStringWithKeyFromTable(@"(Max Availuable Send:", nil);
    self.maxSendValueLabel.text = MAX_SEND_COUNT(0);
    
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
    
    self.noWalletTip1Label.text = DBHGetStringWithKeyFromTable(@"Your wallet has not this property,", nil);
    self.noWalletTip2Label.text = DBHGetStringWithKeyFromTable(@"Please ", nil);
    [self.addWalletBtn setTitle:DBHGetStringWithKeyFromTable(@"Add Wallet", nil) forState:UIControlStateNormal];
    self.noWalletTip3Label.text = DBHGetStringWithKeyFromTable(@" Send redpacket after saved property", nil);
    
    self.sendUnitLabel.text = @"";
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

#pragma mark ----- Setters And Getters ---------
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

@end
