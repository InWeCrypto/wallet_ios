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

@interface YYRedPacketSendSecondViewController ()
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

@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;


@end

@implementation YYRedPacketSendSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
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

#pragma mark ------- SetUI ---------
- (void)setUI {
    self.backIndex = 2;
    self.title = DBHGetStringWithKeyFromTable(@"Send RedPacket", nil);
    
    self.secondLabel.text = DBHGetStringWithKeyFromTable(@"Second:", nil);
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"Pay Some Poundage, Finish The Creation of Red Packet", nil);
    self.walletMaxUseTitleLabel.text = DBHGetStringWithKeyFromTable(@"Max Avaliable Amount:", nil);
    self.poundageLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Fees", nil)];
    
    [self.startCreateBtn setTitle:DBHGetStringWithKeyFromTable(@"Start Create Red Packet", nil) forState:UIControlStateNormal];
    [self.startCreateBtn setCorner:2];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, 4);
    layer.backgroundColor = COLORFROM16(0x029857, 1).CGColor;
    [self.progressView.layer addSublayer:layer];
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
            vc.packageType = PackageTypeRedPacket;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _inputPasswordPromptView;
}
@end
