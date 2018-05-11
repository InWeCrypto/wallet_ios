//
//  YYRedPacketSendThirdViewController.m
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSendThirdViewController.h"
#import "YYRedPacketSendFourthTextViewController.h"
#import "YYRedPacketSendFourthImageViewController.h"
#import "YYRedPacketSendFourthLinkViewController.h"
#import "YYRedPacketSendFourthCodeViewController.h"

typedef enum _share_style {
    ShareStyleText = 0,
    ShareStyleImage,
    ShareStyleLink,
    ShareStyleCode
}ShareStyle;

@interface YYRedPacketSendThirdViewController ()

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

/**
 纯文字view
 */
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;

/**
 图片view
 */
@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;

/**
 链接view
 */
@property (weak, nonatomic) IBOutlet UIView *linkView;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UIButton *linkBtn;

/**
 代码view
 */
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (nonatomic, weak) UIButton *lastSelectedBtn;

@property (nonatomic, assign) ShareStyle style;

@end

@implementation YYRedPacketSendThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
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

#pragma mark ------- SetUI ---------
- (void)setUI {
    self.backIndex = 2;
    self.title = DBHGetStringWithKeyFromTable(@"Send Red Packet", nil);
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.75, 4);
    layer.backgroundColor = COLORFROM16(0x029857, 1).CGColor;
    [self.progressView.layer addSublayer:layer];

    self.thirdLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Third", nil)];
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"Choose Style of Sharing", nil);
    
    [self.nextBtn setCorner:2];
    
    [self.textView setBorderWidth:0.5 color:COLORFROM16(0xD9D9D9, 1)];
    [self.imageView setBorderWidth:0.5 color:COLORFROM16(0xD9D9D9, 1)];
    [self.linkView setBorderWidth:0.5 color:COLORFROM16(0xD9D9D9, 1)];
    [self.codeView setBorderWidth:0.5 color:COLORFROM16(0xD9D9D9, 1)];

    self.textBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.linkBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.codeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.textLabel.text = DBHGetStringWithKeyFromTable(@"Text-only Red Packet", nil);
    self.imageLabel.text = DBHGetStringWithKeyFromTable(@"Insert Image for sharing", nil);
    self.linkLabel.text = DBHGetStringWithKeyFromTable(@"Customize Red Packet Links", nil);
    self.codeLabel.text = DBHGetStringWithKeyFromTable(@"Generate Red Packet code to insert the web page", nil);

    _lastSelectedBtn = self.textBtn;
}

#pragma mark ----- RespondsToSelector ---------
- (void)clickBtn:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    
    _lastSelectedBtn.selected = NO;
    sender.selected = YES;
    
    _lastSelectedBtn = sender;
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToNextBtn:(UIButton *)sender {
    switch (_style) {
        case 0: {
            YYRedPacketSendFourthTextViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_SEND_FOURTH_TEXT_STORYBOARD_ID];
            vc.styleStr = self.textLabel.text;
            vc.ethWalletsArray = self.ethWalletsArray;
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            YYRedPacketSendFourthImageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_SEND_FOURTH_IMAGE_STORYBOARD_ID];
            vc.ethWalletsArray = self.ethWalletsArray;
            vc.model = self.model;
            vc.styleStr = self.imageLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            YYRedPacketSendFourthLinkViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_SEND_FOURTH_LINK_STORYBOARD_ID];
            vc.ethWalletsArray = self.ethWalletsArray;
            vc.model = self.model;
            vc.styleStr = self.linkLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3: {
            YYRedPacketSendFourthCodeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_SEND_FOURTH_CODE_STORYBOARD_ID];
            vc.ethWalletsArray = self.ethWalletsArray;
            vc.model = self.model;
            vc.styleStr = self.codeLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

- (IBAction)respondsToTextBtn:(UIButton *)sender {
    _style = 0;
    [self clickBtn:sender];
}

- (IBAction)respondsToImageBtn:(UIButton *)sender {
    _style = 1;
    [self clickBtn:sender];
}

- (IBAction)respondsToLinkBtn:(UIButton *)sender {
    _style = 2;
    [self clickBtn:sender];
}

- (IBAction)respondsToCodeBtn:(UIButton *)sender {
    _style = 3;
    [self clickBtn:sender];
}
@end
