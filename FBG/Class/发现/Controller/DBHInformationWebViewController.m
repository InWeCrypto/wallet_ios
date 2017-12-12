//
//  DBHInformationWebViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/12/7.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationWebViewController.h"

#import <WebKit/WebKit.h>

@interface DBHInformationWebViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation DBHInformationWebViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    NSURL *url = [NSURL URLWithString:[APP_APIEHEAD isEqualToString:APIEHEAD] ? @"http://testnet.inwecrypto.com/#/" : @"http://inwecrypto.com/#/"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.webView];
}

#pragma mark ------ Getters And Setters ------
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

@end
