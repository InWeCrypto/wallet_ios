//
//  YYRedPacketPackagingViewController.m
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketPackagingViewController.h"
#import "YYRedPacketSendSecondViewController.h"
#import "YYRedPacketSendThirdViewController.h"
#import "LDProgressView.h"

@interface YYRedPacketPackagingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *backToHomeBtn;
@property (weak, nonatomic) IBOutlet UILabel *afterTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet LDProgressView *progress;

@end

@implementation YYRedPacketPackagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

/**
 父类方法
 */
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(18)}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self redPacketNavigationBar];
}

#pragma mark ------- SetUI ---------
- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Send RedPacket", nil);
    
    if (self.packageType == PackageTypeCash) {
        self.titleLabel.text = DBHGetStringWithKeyFromTable(@"Cash Packaging", nil);
    } else {
        self.titleLabel.text = DBHGetStringWithKeyFromTable(@"Red Packet Creating", nil);
    }
    
    self.statusLabel.text = [NSString stringWithFormat:@"(%@)", DBHGetStringWithKeyFromTable(@"Waiting Confirm", nil)];
    self.afterTipLabel.text = DBHGetStringWithKeyFromTable(@"Check the creation of the red packets later", nil);
    [self.backToHomeBtn setTitle:DBHGetStringWithKeyFromTable(@"Back To RedPacket Home Page", nil) forState:UIControlStateNormal];
    
    [self.nextBtn setTitle:DBHGetStringWithKeyFromTable(@"Next", nil) forState:UIControlStateNormal];
    
    [self.nextBtn setCorner:2];
    [self.nextBtn setBackgroundColor:COLORFROM16(0xD5D5D5, 1) forState:UIControlStateDisabled];
    [self.nextBtn setBackgroundColor:COLORFROM16(0xEA6204, 1) forState:UIControlStateNormal];
    
    CALayer *layer = [CALayer layer];
    if (self.packageType == PackageTypeCash) {
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.25, 4);
    } else {
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, 4);
    }
    
    layer.backgroundColor = COLORFROM16(0x029857, 1).CGColor;
    [self.progressView.layer addSublayer:layer];
    
    self.progress.progress = 0.5;
    self.progress.showText = @0;
    
//    self.nextBtn.enabled = NO; YYTODO
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToBackToHomeBtn:(UIButton *)sender {
    self.backIndex = 2;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)respondsToNextBtn:(UIButton *)sender {
    if (self.packageType == PackageTypeCash) {
        YYRedPacketSendSecondViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_SEND_SECOND_STORYBOARD_ID];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        YYRedPacketSendThirdViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_SEND_THIRD_STORYBOARD_ID];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
