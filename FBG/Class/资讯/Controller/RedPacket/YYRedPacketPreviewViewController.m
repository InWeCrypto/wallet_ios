//
//  YYRedPacketPreviewViewController.m
//  FBG
//
//  Created by yy on 2018/4/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketPreviewViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WKNavigationDelegate.h>
#import "YYSharePromptView.h"

@interface YYRedPacketPreviewViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *grayLineView;

@end

@implementation YYRedPacketPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadUrl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.webView.navigationDelegate = self;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WHITE_COLOR] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.webView.navigationDelegate = nil;
}

#pragma mark ------- SetUI ---------
- (void)setUI {
    if (self.from == PreViewVCFromSendRedPacket) {
        self.backIndex = 2;
    }
    NSString *titleStr = @"Preview";
    if (self.from == PreViewVCFromProtocol) {
        _hideShareBtn = YES;
        titleStr = @"InWeCrypto Red Packet Use Agreement";
    }
    self.title = DBHGetStringWithKeyFromTable(titleStr, nil);
    
    if (!self.hideShareBtn) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"redpacket_share"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToShareBarButtonItem)];
    }
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.grayLineView];
    
    WEAKSELF
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
    }];
    
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.grayLineView.mas_bottom);
    }];
    
}

#pragma mark ------- load URL ---------
- (void)loadUrl:(NSString *)url {
    if ([NSObject isNulllWithObject:url]) {
        return;
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)loadUrl {
    if (!self.detailModel) {
        return;
    }
    
    NSString *tempURL = TEST_REDPACKET_CREATE_CODE;
    if ([APP_APIEHEAD isEqualToString:APIEHEAD1]) {
        tempURL = REDPACKET_CREATE_CODE;
    }
    
    NSString *user = [self.detailModel.share_user stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *createCodeUrl = [tempURL stringByAppendingFormat:@"redbag/%@/%@?share_user=%@&lang=%@&target=%@&inwe", @(self.detailModel.redPacketId), self.detailModel.redbag_addr, user, [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? @"zh" : @"en", @"draw"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:createCodeUrl]]];
}

#pragma mark ------- SetUI ---------
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark ----- RespondsToSelector ---------
- (void)respondsToShareBarButtonItem {
    YYSharePromptView *shareView = [[YYSharePromptView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    shareView.model = self.detailModel;
    
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [shareView showWithTarget:self];
    });
}

#pragma mark ----- Setters And Getters ---------
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
    }
    return _webView;
}

- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _grayLineView;
}
@end
