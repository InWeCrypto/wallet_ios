//
//  KKWebView.m
//  StomatologicalOfCustomer
//
//  Created by 吴灶洲 on 2017/6/30.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

#import "KKWebView.h"
#import <WebKit/WebKit.h>
#import "ChoseWalletView.h"
#import "CommitOrderView.h"
#import "ConfirmationTransferVC.h"

@interface KKWebView ()<WKUIDelegate,WKNavigationDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, ChoseWalletViewDelegate, CommitOrderViewDelegate>

@property (weak, nonatomic) CALayer *progresslayer;
@property (weak, nonatomic) UIView *bottomView;
@property (weak, nonatomic) WKWebView *webView;

@property (nonatomic, strong) ChoseWalletView * choseWalletView;
@property (nonatomic, strong) CommitOrderView * commitOrderView;

//转账订单生产
@property (nonatomic, strong) WalletLeftListModel * walletModel;
@property (nonatomic, copy) NSString * gasPrice;   //手续费单价
@property (nonatomic, copy) NSString * totleGasPrice;       //总手续费
@property (nonatomic, copy) NSString * nonce;
@property (nonatomic, assign) int defaultGasNum;
@property (nonatomic, copy) NSString * banlacePrice;

@end

@implementation KKWebView

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _urlStr = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController) {
        if ([self.navigationController.viewControllers count] > 1)
        {
            UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
            leftBarButtonItem.width = -30;
            self.navigationItem.leftBarButtonItem = leftBarButtonItem;
            [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
            
            UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_share"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
            self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        }
    }
    if (self.isLogin)
    {
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
        leftBarButtonItem.width = -30;
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];}


-(void)setupUI
{
    
    WKWebView *webView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    webView.UIDelegate=self;
    webView.navigationDelegate=self;
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    _webView = webView;
    
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
    
    NSURL *url=[NSURL URLWithString:self.urlStr];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    //模拟按钮
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 100, 100, 100);
    [button setTitle:@"前往支付" forState: UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
}

- (void)rightButton
{
    //分享
    NSArray* activityItems = [[NSArray alloc] initWithObjects:_urlStr,nil];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    //applicationActivities可以指定分享的应用，不指定为系统默认支持的
    
    kWeakSelf(activityVC)
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError)
    {
        if(completed)
        {
            NSLog(@"Share success");
        }
        else
        {
            NSLog(@"Cancel the share");
        }
        [weakactivityVC dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)buttonClicked
{
    //模拟
    [self.choseWalletView showWithView:nil];
}

//选择钱包回调
- (void)sureButtonCilickWithData:(id)data
{
    self.walletModel = data;
    
    [LCProgressHUD showLoading:@"加载中..."];
    //获取账户余额
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.walletModel.address forKey:@"address"];
    
    [PPNetworkHelper POST:@"extend/getBalance" parameters:dic hudString:nil success:^(id responseObject)
     {
         self.banlacePrice = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[responseObject objectForKey:@"value"] substringFromIndex:2]] secend:@"1000000000000000000" value:4];
         self.commitOrderView.banalceLB.text = [NSString stringWithFormat:@"(当前余额:%@)",self.banlacePrice];
         
         //获取gas手续费
         NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
         [parametersDic setObject:@(self.walletModel.category_id) forKey:@"category_id"];
         [parametersDic setObject:@"1" forKey:@"type"];
         
         [PPNetworkHelper GET:@"gas" parameters:parametersDic hudString:nil success:^(id responseObject)
          {
              //获取单价
              NSString * per = @"0";
              if (![NSString isNulllWithObject:[responseObject objectForKey:@"gas"]])
              {
                  per = [[responseObject objectForKey:@"record"] objectForKey:@"gas"];
              }
              self.gasPrice = [NSString DecimalFuncWithOperatorType:3 first:per secend:@"1000000000000000000" value:4];
              self.totleGasPrice = [NSString DecimalFuncWithOperatorType:2 first:self.gasPrice secend:[NSString stringWithFormat:@"%d",self.defaultGasNum] value:4];
              self.commitOrderView.changesPriceLB.text = self.totleGasPrice;
              
              [self.commitOrderView.priceSilder setValue:[self.totleGasPrice floatValue]];
              
              //获取交易次数
              NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
              [dic setObject:self.walletModel.address forKey:@"address"];
              
              [PPNetworkHelper POST:@"extend/getTransactionCount" parameters:dic hudString:nil success:^(id responseObject)
               {
                   // nonce 参数
                   if (![NSString isNulllWithObject:[responseObject objectForKey:@"count"]])
                   {
                       self.nonce = [responseObject objectForKey:@"count"];
                   }
                   
                   dispatch_queue_t mainQueue = dispatch_get_main_queue();
                   //异步返回主线程，根据获取的数据，更新UI
                   dispatch_async(mainQueue, ^
                  {
                      [LCProgressHUD hide];
                  });
                   //初始化钱包订单页面
                   self.commitOrderView.orderLB.text = self.icoModel.title;
                   self.commitOrderView.transferAddressLB.text = self.icoModel.address;
                   self.commitOrderView.addressLB.text = self.walletModel.address;
                   
                   if (self.walletModel.isLookWallet)
                   {
                       //观察钱包
                       [self.view addSubview:self.commitOrderView];
                       
                       [UIView animateWithDuration:0.3 animations:^{
                           self.commitOrderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
                       } completion:^(BOOL finished){
                           
                       }];
                   }
                   else
                   {
                       //普通钱包
                       [self.view addSubview:self.commitOrderView];
                       
                       [UIView animateWithDuration:0.3 animations:^{
                           self.commitOrderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
                       } completion:^(BOOL finished){
                           
                       }];
                       
                   }
               } failure:^(NSString *error)
               {
                   [LCProgressHUD showFailure:error];
                   dispatch_queue_t mainQueue = dispatch_get_main_queue();
                   //异步返回主线程，根据获取的数据，更新UI
                   dispatch_async(mainQueue, ^
                                  {
                                      [LCProgressHUD hide];
                                  });
               }];
              
          } failure:^(NSString *error)
          {
              [LCProgressHUD showFailure:error];
              dispatch_queue_t mainQueue = dispatch_get_main_queue();
              //异步返回主线程，根据获取的数据，更新UI
              dispatch_async(mainQueue, ^
                             {
                                 [LCProgressHUD hide];
                             });
          }];
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
         dispatch_queue_t mainQueue = dispatch_get_main_queue();
         //异步返回主线程，根据获取的数据，更新UI
         dispatch_async(mainQueue, ^
                        {
                            [LCProgressHUD hide];
                        });
     }];

}

 - (void)cancelView
{
    //取消订单详情
    [UIView animateWithDuration:0.3 animations:^{
        self.commitOrderView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    } completion:^(BOOL finished){
        [self.commitOrderView removeFromSuperview];
    }];
}

- (void)comiitButtonCilickWithData:(id)data
{
    //确定
    
    if (self.nonce.length == 0)
    {
        [LCProgressHUD showMessage:@"暂未获取到交易次数。请稍后再试"];
        return;
    }
    //钱包余额判断   手续费 + 转账金额 <= ether钱包余额
    if (self.commitOrderView.priceTF.text.length == 0)
    {
        [LCProgressHUD showMessage:@"请输入正确价格"];
        return;
    }
    
    NSComparisonResult result = [NSString DecimalFuncComparefirst:self.commitOrderView.priceTF.text secend:self.banlacePrice];
    if (result == NSOrderedDescending)
    {
        [LCProgressHUD showMessage:@"钱包余额不足"];
        return;
    }
    
    ConfirmationTransferVC * vc = [[ConfirmationTransferVC alloc] init];
    vc.totleGasPrice = self.totleGasPrice;
    vc.gasprice = self.gasPrice;
    vc.nonce = self.nonce;
    vc.price = self.commitOrderView.priceTF.text;
    vc.address = self.commitOrderView.transferAddressLB.text;
    vc.remark = @"";
    vc.model = self.walletModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---WKNavigationDelegate
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
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.progresslayer.opacity = 1;
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 3);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else if ([keyPath isEqualToString:@"title"]){
//        self.title = self.webView.title;
    }else {
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
    if (self.webView.canGoBack==YES) {
        
        [self.webView goBack];
        
    }
    else
    {
        if (self.isLogin)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    NSLog(@"%@", NSStringFromClass([self class]));
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}


- (ChoseWalletView *)choseWalletView
{
    if (!_choseWalletView)
    {
        _choseWalletView = [[ChoseWalletView alloc] initWithFrame:[AppDelegate delegate].window.bounds];
        _choseWalletView.delegate = self;
    }
    return _choseWalletView;
}

- (CommitOrderView *)commitOrderView
{
    if (!_commitOrderView)
    {
        _commitOrderView = [[CommitOrderView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _commitOrderView.delegate = self;
    }
    return _commitOrderView;
}

@end
