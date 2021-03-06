//
//  DBHHelpCenterWebViewController.m
//  FBG
//
//  Created by yy on 2018/3/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHHelpCenterWebViewController.h"
#import "DBHFeedbackViewController.h"
#import "LYShareMenuView.h"
#import <TencentOpenApi/QQApiInterface.h>
#import "WXApi.h"
#import <TwitterKit/TWTRComposer.h>
#import "CustomActivity.h"

@interface DBHHelpCenterWebViewController ()<WKUIDelegate,WKNavigationDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, LYShareMenuViewDelegate>

@property (weak, nonatomic) CALayer *progresslayer;
@property (weak, nonatomic) UIView *bottomView;
@property (weak, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIButton *shareBtn;

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) LYShareMenuView *sharedMenuView;

@end

@implementation DBHHelpCenterWebViewController

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _urlStr = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = DBHGetStringWithKeyFromTable(@"Help Center", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController) {
        if ([self.navigationController.viewControllers count] > 1) {
            UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
            leftBarButtonItem.width = -30;
            self.navigationItem.leftBarButtonItem = leftBarButtonItem;
            [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
            
            UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Feedback", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToFeedbackButton)];
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:FONT(15),NSFontAttributeName, nil];
            [rightBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
            [rightBarItem setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
            self.navigationItem.rightBarButtonItem = rightBarItem;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)setupUI {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES; //很重要，如果没有设置这个则不会回调createWebViewWithConfiguration方法，也不会回应window.open()方法
    config.preferences = preferences;
    
    WKWebView *webView=[[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) configuration:config];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    _webView = webView;
    
    if (![_urlStr containsString:@"<"]) {
        //添加属性监听
        [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        //进度条
        UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
        progress.backgroundColor = [UIColor clearColor];
        [self.view addSubview:progress];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 3);
        layer.backgroundColor = [UIColor colorWithHexString:@"FDD930"].CGColor;
        [progress.layer addSublayer:layer];
        _progresslayer = layer;
    }
    
    if ([_urlStr containsString:@"<"]) {
        [webView loadHTMLString:_urlStr baseURL:nil];
    } else {
        NSURL *url=[NSURL URLWithString:self.urlStr];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
    [self.view addSubview:self.shareBtn];
}

- (void)activityOriginalShare {
    NSArray* activityItems = [[NSArray alloc] initWithObjects:[self.webView.URL absoluteString], nil];
    
    CustomActivity *weixinActivity = [[CustomActivity alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"WeChat", nil) ActivityImage:[UIImage imageNamed:@"fenxiang_weixin"] URL:[NSURL URLWithString:@"WeChat"] ActivityType:@"WeChat"];
    
    CustomActivity *momentsActivity = [[CustomActivity alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Moments", nil) ActivityImage:[UIImage imageNamed:@"friend_pr"] URL:[NSURL URLWithString:@"Moments"] ActivityType:@"Moments"];
    
    NSArray *activityArray = @[weixinActivity, momentsActivity];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:activityArray];
    
    kWeakSelf(activityVC)
    WEAKSELF
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if(completed) {
            if ([activityType isEqualToString:@"WeChat"]) {
                [WXApi sendReq:[weakSelf shareToWX:1]];
            } else if ([activityType isEqualToString:@"Moments"]) {
                [WXApi sendReq:[weakSelf shareToWX:0]];
            } else {
                [self shareSuccess:YES];
            }
        } else {
            NSLog(@"Cancel the share");
        }
        [weakactivityVC dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - 响应按钮事件
- (void)respondsToFeedbackButton {
    if (![UserSignData share].user.isLogin) {
        [[AppDelegate delegate] goToLoginVC:self];
    } else {
        [self pushToFeedbackVC];
    }
}

- (void)respondsToShareBtn {
    [self activityOriginalShare];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.sharedMenuView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.sharedMenuView show];
//    });
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
    NSString *urlStr = [NSString stringWithFormat:@"https://t.me/share/url?text=%@&url=%@", @"", [self.webView.URL absoluteString]];
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
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    [composer setURL:self.webView.URL];
    
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
    QQApiTextObject *textObj = [QQApiTextObject objectWithText:[self.webView.URL absoluteString]];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:textObj];
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
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    
    req.text = [self.webView.URL absoluteString];
    if (index == 0) {
        req.scene = WXSceneTimeline; // 朋友圈
    } else {
        req.scene =  WXSceneSession; // 好友
    }
    return req;
}

#pragma mark - 跳转事件
- (void)pushToFeedbackVC {
    DBHFeedbackViewController *feedbackVC = [[DBHFeedbackViewController alloc] init];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

#pragma mark---WKNavigationDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    NSLog(@"createWebViewWithConfiguration");
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


//加载失败调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //    [_activityIndicator stopAnimating];
    if (_bottomView == nil) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 3, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];
        _bottomView = bottomView;
        UITapGestureRecognizer *recongizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action)];
        [bottomView addGestureRecognizer:recongizer];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 150)];
        imageView.center = CGPointMake(bottomView.center.x, bottomView.center.y-64.0);
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [UIImage imageNamed:@"noData"];
        [bottomView addSubview:imageView];
    }else {
        _bottomView.hidden = NO;
    }
}


/** 观察加载进度 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        float changeValue = [change[NSKeyValueChangeNewKey] floatValue];
        NSLog(@"changeValue = %f", changeValue);
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * MIN(changeValue, 1), 3);
        if (changeValue == 1) {
            
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    } else if ([keyPath isEqualToString:@"title"]){
        //        self.title = self.webView.title;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)action {
    _bottomView.hidden = YES;
    if (!_webView.isLoading) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    }
}

- (void)onClickBack {
    if (self.webView.canGoBack == YES) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc{
    NSLog(@"%@", NSStringFromClass([self class]));
    if (![_urlStr containsString:@"<"]) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.webView removeObserver:self forKeyPath:@"title"];
    }
}
#pragma mark ----- Setters And Getters ---------
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat width = 60;
        CGFloat x = SCREEN_WIDTH - width - 30;
        CGFloat y = SCREEN_HEIGHT - width - 50 - STATUS_HEIGHT - 44;
        shareBtn.frame = CGRectMake(x, y, width, width);
        [shareBtn addTarget:self action:@selector(respondsToShareBtn) forControlEvents:UIControlEventTouchUpInside];
        shareBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [shareBtn setImage:[UIImage imageNamed:@"help_center_share"] forState:UIControlStateNormal];
        _shareBtn = shareBtn;
    }
    return _shareBtn;
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
