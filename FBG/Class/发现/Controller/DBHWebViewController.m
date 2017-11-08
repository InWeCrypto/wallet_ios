//
//  DBHWebViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/7.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHWebViewController.h"

#import <WebKit/WebKit.h>

#import "MJRefresh.h"

@interface DBHWebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *url;

@end

@implementation DBHWebViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
    [self addRefresh];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.webView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.webView.scrollView.mj_header beginRefreshing];
}

#pragma mark ------ WKNavigationDelegate ------
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self endRefresh];
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
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
    
}

#pragma mark ------ Public Methods ------
/**
 初始化
 
 @param url 加载的url
 @return vc
 */
- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

#pragma mark ------ Private Methods ------
/**
 添加下拉刷新
 */
- (void)addRefresh {
    typeof(self) __weak weakSelf = self;
    self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.webView.isLoading) {
            return ;
        }
        [weakSelf.webView reload];
    }];
}
/**
 结束刷新
 */
- (void)endRefresh {
    if (self.webView.scrollView.mj_header.isRefreshing) {
        [self.webView.scrollView.mj_header endRefreshing];
    }
}

#pragma mark ------ Getters And Setters ------
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
