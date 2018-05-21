//
//  YYShareAppViewController.m
//  FBG
//
//  Created by yy on 2018/5/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYShareAppViewController.h"
#import "LYShareMenuView.h"
#import <TencentOpenApi/QQApiInterface.h>
#import "WXApi.h"
#import <TwitterKit/TWTRComposer.h>

@interface YYShareAppViewController ()<LYShareMenuViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tip1Label;
@property (weak, nonatomic) IBOutlet UILabel *tip2Label;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *qrImgView;

@property (nonatomic, strong) LYShareMenuView *sharedMenuView;

@end

@implementation YYShareAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setUI];
}

- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Share APP", nil);
    self.tip1Label.text = DBHGetStringWithKeyFromTable(@"Informed portfolio investment", nil);
    self.tip2Label.text = DBHGetStringWithKeyFromTable(@"Share your attitude", nil);
    [self.shareBtn setTitle:DBHGetStringWithKeyFromTable(@"Share InWeCrypto to your friends.", nil) forState:UIControlStateNormal];
    self.qrImgView.image = [UIImage imageNamed:DBHGetStringWithKeyFromTable(@"share_app_qr_img_en", nil)];
    
    [self.shareBtn setCorner:2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark ------- 父类方法 ---------
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(18)}];
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToShareBtn:(UIButton *)sender {
    [[UIApplication sharedApplication].keyWindow addSubview:self.sharedMenuView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sharedMenuView show];
    });
}

#pragma mark ----- Share Delegate ------
- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index {
    switch (index) {
        case 2: { // QQ
            [self shareToQQ];
            break;
        }
        case 3: { // Tele
            [self shareTelegram];
            break;
        }
        case 4: { // Twitter
            [self shareToTwitter];
            break;
        }
        default: {
            [WXApi sendReq:[self shareToWX:index]];
            break;
        }
            
    }
}

- (void)shareSuccess:(BOOL)isSuccess {
    if (isSuccess) {
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Share successfully", nil)];
    } else {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Share failed", nil)];
    }
}

- (void)shareTelegram {
    NSString *sharedTitle = [self sharedTitle];
    NSString *urlStr = [NSString stringWithFormat:@"https://t.me/share/url?text=%@&url=%@", sharedTitle, [self sharedURL]];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
    [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success) {
        if (!success) {
            [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Uninstalled Telegram", nil)];
        }
    }];
}

- (void)shareToTwitter {
    NSString *urlStr = [self sharedURL];
    
    NSString *sharedTitle = [self sharedTitle];
    
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    [composer setURL:[NSURL URLWithString:urlStr]];
    
    [composer setText:sharedTitle];
    
    WEAKSELF
    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
        [weakSelf shareSuccess:result == TWTRComposerResultDone];
    }];
}

- (void)shareToQQ {
    WEAKSELF
    [[AppDelegate delegate] setQqResultBlock:^(QQBaseResp *res) {
        if ([res isKindOfClass:[SendMessageToQQResp class]]) {
            if (res.type == ESENDMESSAGETOQQRESPTYPE) { // 手Q->第三方
                if ([res.result intValue] == 0) { // 没有错误
                    [weakSelf shareSuccess:YES];
                } else {
                    if (res.result.intValue == -4) { // 取消分享
                        [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Cancel share", nil)];
                    } else {
                        [weakSelf shareSuccess:NO];
                    }
                }
            }
        }
    }];
    
    NSString *sharedURL = [self sharedURL];
    NSString *sharedTitle = [self sharedTitle];
    
    UIImage *img = [UIImage imageWithImage:self.qrImgView.image scaledToSize:CGSizeMake(100, 100)];
    NSData *data = UIImagePNGRepresentation(img);
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:sharedURL] title:sharedTitle description:sharedURL previewImageData:data];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode send = [QQApiInterface sendReq:req];
    [self handleSendResult:send];
    
}

- (void)handleSendResult:(QQApiSendResultCode)code {
    switch (code) {
        case EQQAPIAPPNOTREGISTED: // 未注册
            NSLog(@"未注册");
            break;
        case EQQAPIQQNOTINSTALLED:
            [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Please install QQ mobile", nil)]; // todo
            break;
        case EQQAPISENDFAILD:
            [self shareSuccess:NO];
            break;
        default:
            break;
    }
}

/**
 发送消息到微信
 
 @param index 0 - 朋友圈  1 - 好友
 @return 消息
 */
- (SendMessageToWXReq *)shareToWX:(NSInteger)index {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    WEAKSELF
    [appDelegate setResultBlock:^(BaseResp *res) {
        if ([res isKindOfClass:[SendMessageToWXResp class]]) {
            if (res.errCode == 0) { // 没有错误
                //本地记录备份了
                [weakSelf shareSuccess:YES];
            } else {
                if (res.errCode == -2) { // cancel
                } else {
                    [weakSelf shareSuccess:NO];
                }
            }
        }
    }];
    
    NSString *sharedURL = [self sharedURL];
    NSString *sharedTitle = [self sharedTitle];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = sharedTitle;
    message.description = sharedURL;
    
    WXWebpageObject *obj = [[WXWebpageObject alloc] init];
    obj.webpageUrl = sharedURL;
    
    UIImage *img = [UIImage imageWithImage:self.qrImgView.image scaledToSize:CGSizeMake(100, 100)];
    [message setThumbImage:img];
    
    message.mediaObject = obj;
    req.message = message;
    
    if (index == 0) {
        req.scene = WXSceneTimeline; // 朋友圈
    } else {
        req.scene =  WXSceneSession; // 好友
    }
    return req;
}

#pragma mark ----- Setters And Getters ---------
- (NSString *)sharedURL {
    return [DOWNLOAD_APP_URL stringByAppendingFormat:@"%@/platform", [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? @"zh" : @"en"];
}

- (NSString *)sharedTitle {
    return DBHGetStringWithKeyFromTable(@"I’m using 【InWeCrypto】 (informed portfolio investment). Truly recommended!", nil);
}

- (LYShareMenuView *)sharedMenuView {
    if (!_sharedMenuView) {
        _sharedMenuView = [[LYShareMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        LYShareMenuItem *friendItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"friend_pr" itemTitle:DBHGetStringWithKeyFromTable(@"Moments", nil)];
        LYShareMenuItem *weixinItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"weixin_pr" itemTitle:DBHGetStringWithKeyFromTable(@"WeChat", nil)];
        LYShareMenuItem *qqItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"qq_pr" itemTitle:@"QQ"];
        LYShareMenuItem *telegramItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"fenxiang_telegram" itemTitle:@"Telegram"];
        LYShareMenuItem *twitterShareItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"fenxiang_twitter" itemTitle:@"Twitter"];
        
        _sharedMenuView.shareMenuItems = [NSMutableArray arrayWithObjects:friendItem, weixinItem, qqItem, telegramItem, twitterShareItem, nil];
    }
    if (!_sharedMenuView.delegate) {
        _sharedMenuView.delegate = self;
    }
    return _sharedMenuView;
}

@end
