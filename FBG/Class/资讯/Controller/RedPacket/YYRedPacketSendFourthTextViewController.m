//
//  YYRedPacketSendFourthTextViewController.m
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSendFourthTextViewController.h"
#import "DBHPlaceHolderTextView.h"
#import "YYSharePromptView.h"

@interface YYRedPacketSendFourthTextViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;

@property (weak, nonatomic) IBOutlet UIView *senderView;
@property (weak, nonatomic) IBOutlet UITextField *senderNameTextField;


@property (weak, nonatomic) IBOutlet UIView *bestView;
@property (weak, nonatomic) IBOutlet DBHPlaceHolderTextView *bestTextView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (assign, nonatomic) BOOL isSendRedBag;

@end

@implementation YYRedPacketSendFourthTextViewController

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
    
    [self.senderView setBorderWidth:0.5f color:COLORFROM16(0xD9D9D9, 1)];
    [self.bestView setBorderWidth:0.5f color:COLORFROM16(0xD9D9D9, 1)];
    
    self.senderNameTextField.placeholder = DBHGetStringWithKeyFromTable(@"Sender's Name", nil);
    self.bestTextView.placeholder = DBHGetStringWithKeyFromTable(@"Wishes / Messages", nil);
    
    [self.shareBtn setBackgroundColor:COLORFROM16(0xD5D5D5, 1) forState:UIControlStateDisabled];
    [self.shareBtn setBackgroundColor:COLORFROM16(0xEA6204, 1) forState:UIControlStateNormal];
    
    [self.shareBtn setCorner:2];
   
    [self.shareBtn setTitle:DBHGetStringWithKeyFromTable(@" Share ", nil) forState:UIControlStateNormal];
    
    self.shareBtn.enabled = NO;
}

#pragma mark ------- Data ---------
- (void)sendRedPacket:(NSString *)senderName best:(NSString *)best {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        NSString *urlStr = [NSString stringWithFormat:@"redbag/send/%@/%@", @(self.model.redPacketId), self.model.redbag_addr];
        
        NSDictionary *params = @{
                                 @"share_type" : @"2", // 红包分享类型,1.图片,2.文字,3.url,4code
                                 @"share_attr" : @"", // 红包分享内容,图片链接,文章内容,url
                                 @"share_user" : senderName, // 红包分享用户
                                 @"share_msg" : best, // 红包分享消息
                                 };
        WEAKSELF
        [PPNetworkHelper POST:urlStr baseUrlType:3 parameters:params hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
            [weakSelf handleResponse:responseObject];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Load failed", nil)];
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
        
        YYSharePromptView *shareView = [[YYSharePromptView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        shareView.model = model;
        
        [[UIApplication sharedApplication].keyWindow addSubview:shareView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [shareView show];
        });
    }
}


#pragma mark ------- text field and text view ---------
- (void)textFieldTextChange:(UITextField *)textField {
    if (textField.text.length != 0 && self.bestTextView.text.length != 0) {
        self.shareBtn.enabled = YES;
    } else {
        self.shareBtn.enabled = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length != 0 && self.senderNameTextField.text.length != 0) {
        self.shareBtn.enabled = YES;
    } else {
        self.shareBtn.enabled = NO;
    }
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToShareBtn:(UIButton *)sender {
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

@end
