//
//  YYRedPacketSendFourthCodeViewController.m
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSendFourthCodeViewController.h"
#import "DBHPlaceHolderTextView.h"

@interface YYRedPacketSendFourthCodeViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;

@property (weak, nonatomic) IBOutlet UIView *senderView;
@property (weak, nonatomic) IBOutlet UITextField *senderNameTextField;

@property (weak, nonatomic) IBOutlet UIView *bestView;
@property (weak, nonatomic) IBOutlet DBHPlaceHolderTextView *bestTextView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *tipCopyBtn;
@property (assign, nonatomic) BOOL isSendRedBag;

@end

@implementation YYRedPacketSendFourthCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self redPacketNavigationBar];
}

#pragma mark ------- 父类方法 ---------
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(18)}];
}

- (void)setNavigationTintColor {
    self.navigationController.navigationBar.tintColor = WHITE_COLOR;
}

#pragma mark ------- SetUI ---------
- (void)setUI {
    _isSendRedBag = NO;
    
    self.title = DBHGetStringWithKeyFromTable(@"Send Red Packet", nil);
    
    [self.senderNameTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.bestTextView.delegate = self;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 4);
    layer.backgroundColor = COLORFROM16(0x029857, 1).CGColor;
    [self.progressView.layer addSublayer:layer];
    
    self.fourthLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Fourth", nil)];
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"Generate style, Preview And Share", nil);
    
    self.styleLabel.text = self.styleStr;
    self.codeLabel.text = @"";
    
    [self.senderView setBorderWidth:0.5f color:COLORFROM16(0xD9D9D9, 1)];
    [self.bestView setBorderWidth:0.5f color:COLORFROM16(0xD9D9D9, 1)];
    
    self.senderNameTextField.placeholder = DBHGetStringWithKeyFromTable(@"Sender's Name", nil);
    self.bestTextView.placeholder = DBHGetStringWithKeyFromTable(@"Wishes / Messages", nil);
    
    [self.sureBtn setBackgroundColor:COLORFROM16(0xD5D5D5, 1) forState:UIControlStateDisabled];
    [self.sureBtn setBackgroundColor:COLORFROM16(0xEA6204, 1) forState:UIControlStateNormal];
    
    [self.sureBtn setCorner:2];
    self.sureBtn.enabled = NO;
    
    [self.sureBtn setTitle:DBHGetStringWithKeyFromTable(@" Confirm ", nil) forState:UIControlStateNormal];
    
    [self.tipCopyBtn setTitle:DBHGetStringWithKeyFromTable(@"Click To Copy Code", nil) forState:UIControlStateNormal];
}

#pragma mark ----- RespondsToSelector ---------
/**
 点击复制
 */
- (IBAction)respondsToTipCopyBtn:(UIButton *)sender {
    NSString *str = self.codeLabel.text;
    if (str.length == 0) {
        return;
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = str;
    [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Copy success", nil)];
}

/**
 确认 发送红包

 @param sender sender
 */
- (IBAction)respondsToSureBtn:(UIButton *)sender {
    if (_isSendRedBag) {
        return;
    }
    
    NSString *bestStr = self.bestTextView.text;
    NSString *senderName = self.senderNameTextField.text;
    
    if ([NSObject isNulllWithObject:bestStr]) {
        bestStr = @"";
    }
    
    if ([NSObject isNulllWithObject:senderName]) {
        senderName = @"";
    }
    
    [self sendRedPacket:senderName best:bestStr];
}

#pragma mark ------- Data ---------
- (void)sendRedPacket:(NSString *)senderName best:(NSString *)best {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        NSString *urlStr = [NSString stringWithFormat:@"redbag/send/%@/%@", @(self.model.redPacketId), self.model.redbag_addr];
        
        NSDictionary *params = @{
                                 @"share_type" : @"4", // 红包分享类型,1.图片,2.文字,3.url,4code
                                 @"share_attr" : @"", // 红包分享内容,图片链接,文章内容,url
                                 @"share_user" : senderName, // 红包分享用户
                                 @"share_msg" : best, // 红包分享消息
                                 };
        WEAKSELF
        [PPNetworkHelper POST:urlStr baseUrlType:3 parameters:params hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
            [weakSelf handleResponse:responseObject];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    });
}

- (void)handleResponse:(id)responseObj {
    if ([NSObject isNulllWithObject:responseObj]) {
        return;
    }
    
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        _isSendRedBag = YES;
        self.backIndex = 2;
        YYRedPacketDetailModel *model = [YYRedPacketDetailModel mj_objectWithKeyValues:responseObj];
        
        NSString *tempURL = TEST_REDPACKET_CREATE_CODE;
        if ([APP_APIEHEAD isEqualToString:APIEHEAD1]) {
            tempURL = REDPACKET_CREATE_CODE;
        }
        
        NSString *user = [model.share_user stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *createCodeUrl = [tempURL stringByAppendingFormat:@"redbag/%@/%@?share_user=%@&lang=%@&target=%@&symbol=%@&inwe", @(model.redPacketId), model.redbag_addr, user, [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? @"zh" : @"en", @"draw2", model.redbag_symbol];
        
        NSString *codeStr = [NSString stringWithFormat:@"<iframe height=498 width=510 src='%@'></iframe>", createCodeUrl];
        self.codeLabel.text = codeStr;
        
        [self respondsToTipCopyBtn:nil];
        
        self.sureBtn.enabled = NO;
    }
}

#pragma mark ------- text field and text view ---------
- (void)textFieldTextChange:(UITextField *)textField {
    if (textField.text.length != 0 &&
        self.bestTextView.text.length != 0 &&
        !_isSendRedBag) {
        self.sureBtn.enabled = YES;
    } else {
        self.sureBtn.enabled = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length != 0 &&
        self.senderNameTextField.text.length != 0 &&
        !_isSendRedBag) {
        self.sureBtn.enabled = YES;
    } else {
        self.sureBtn.enabled = NO;
    }
}

@end
