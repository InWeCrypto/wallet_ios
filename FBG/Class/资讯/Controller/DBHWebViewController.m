//
//  DBHWebViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHWebViewController.h"

#import <WebKit/WKWebView.h>
#import <WebKit/WKNavigationDelegate.h>

@interface DBHWebViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UIButton *yourOpinionButton;

@end

@implementation DBHWebViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.webView];
//    [self.view addSubview:self.grayLineView];
    //[self.view addSubview:self.yourOpinionButton];
    
    WEAKSELF
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
//        make.bottom.equalTo(weakSelf.grayLineView.mas_top);
        make.bottom.equalTo(weakSelf.view);
    }];
//    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.view);
//        make.height.offset(AUTOLAYOUTSIZE(1));
//        make.centerX.equalTo(weakSelf.view);
//        make.bottom.equalTo(weakSelf.yourOpinionButton.mas_top);
//    }];
    //    [self.yourOpinionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.view);
//        make.height.offset(AUTOLAYOUTSIZE(47));
//        make.centerX.bottom.equalTo(weakSelf.view);
//    }];
}

#pragma mark ------ Event Responds ------
/**
 你的观点
 */
- (void)respondsToYourOpinionButton {
    
}

#pragma mark ------ Getters And Setters ------
- (void)setIsHiddenYourOpinion:(BOOL)isHiddenYourOpinion {
    _isHiddenYourOpinion = isHiddenYourOpinion;
    
    self.grayLineView.hidden = _isHiddenYourOpinion;
    self.yourOpinionButton.hidden = _isHiddenYourOpinion;
    
    WEAKSELF
    if (_isHiddenYourOpinion) {
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.view);
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view);
        }];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'" completionHandler:nil];
}

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

- (void)setHtmlString:(NSString *)htmlString {
    _htmlString = htmlString;
    
    if (!_htmlString) {
        return;
    }
    [self.webView loadHTMLString:_htmlString baseURL:nil];
}
- (void)setUrl:(NSString *)url {
    _url = url;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES; //很重要，如果没有设置这个则不会回调createWebViewWithConfiguration方法，也不会回应window.open()方法
        config.preferences = preferences;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}
- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xDEDEDE, 1);
    }
    return _grayLineView;
}
- (UIButton *)yourOpinionButton {
    if (!_yourOpinionButton) {
        _yourOpinionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _yourOpinionButton.titleLabel.font = FONT(14);
        [_yourOpinionButton setTitle:DBHGetStringWithKeyFromTable(@"Your Opinion", nil) forState:UIControlStateNormal];
        [_yourOpinionButton setTitleColor:COLORFROM16(0x626262, 1) forState:UIControlStateNormal];
        [_yourOpinionButton addTarget:self action:@selector(respondsToYourOpinionButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yourOpinionButton;
}

@end
