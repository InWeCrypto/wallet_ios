//
//  LoginVC.m
//  FBG
//
//  Created by mac on 2017/7/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "LoginVC.h"
#import <AFNetworking/AFNetworking.h>
#import "TowButtonAlertView.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <YYCache/YYCache.h>
#import "EBTAttributeLinkClickLabel.h"
#import "KKWebView.h"
#import "CDNavigationController.h"
#import "PPNetworkCache.h"

@interface LoginVC () <TowButtonAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *hotPurseButton;
@property (weak, nonatomic) IBOutlet UIButton *coldPurseButton;
@property (weak, nonatomic) CALayer *progresslayer;

@property (nonatomic, strong) TowButtonAlertView * alertView;
@property (nonatomic, assign) BOOL ishot; //是否是热钱包

@property (nonatomic, strong) CTTelephonyNetworkInfo *networkInfo;

@property (weak, nonatomic) IBOutlet EBTAttributeLinkClickLabel *lbl_Content;

@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.hotPurseButton setTitle:NSLocalizedString(@"Hot Purse", nil) forState:UIControlStateNormal];
    [self.coldPurseButton setTitle:NSLocalizedString(@"Cold Purse", nil) forState:UIControlStateNormal];
    
    NSString *text = @"登录钱包即表示同意《服务协议》《隐私条款》";
    __weak typeof(self)weakSelf = self;
    [self.lbl_Content attributeLinkLabelText:text withLinksAttribute:@{
                                                                       NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                                                       NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                       }
                    withActiveLinkAttributes:nil withLinkClickCompleteHandler:^(NSInteger linkedURLTag) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"linkedURLTag =%ld",linkedURLTag);
                        NSString * api;
                        if ([APP_APIEHEAD isEqualToString:@"https://ropsten.unichain.io/api/"])
                        {
                            //测试
                            api = IMAGEHEAD;
                        }
                        else
                        {
                            //正式
                            api = IMAGEHEAD1;
                        }
                        KKWebView * vc = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@EULA.html",api]];
                        vc.title = @"用户协议";
                        vc.isLogin = YES;
                        CDNavigationController * nav = [[CDNavigationController alloc] initWithRootViewController:vc];
                        [self presentViewController:nav animated:YES completion:nil];
        
    } withUnderLineTextString:@"《服务协议》《隐私条款》",nil];
    
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = [UIColor colorWithHexString:@"FDD930"].CGColor;
    [progress.layer addSublayer:layer];
    _progresslayer = layer;
    
    
//    if ([NSString isNulllWithObject:[PPNetworkCache getResponseCacheForKey:@"wallet-category"]])
//    {
//        //获取钱包类型
//        [PPNetworkHelper GET:@"wallet-category" parameters:nil hudString:nil responseCache:^(id responseCache)
//         {
//         } success:^(id responseObject)
//         {
//         } failure:^(NSString *error)
//         {
//         }];
//        return;
//    }
}

- (void)weChatLogin
{
    NSString * device;
    if (![NSString isNulllWithObject:[PDKeyChain load:@"APP_DEVICEID"]])
    {
        device = [PDKeyChain load:@"APP_DEVICEID"];
    }
    else
    {
        if (!APP_DEVICEID)
        {
            [LCProgressHUD showMessage:@"暂未获取到DeviceToken"];
            return;
        }
        else
        {
            device = APP_DEVICEID;
        }
    }
    
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@"1" forKey:@"open_id"];
    
    [PPNetworkHelper POST:@"auth" parameters:parametersDic hudString:@"登录中..." success:^(id responseObject)
     {
         //登录成功
         if ([NSString isNulllWithObject:[PDKeyChain load:@"APP_DEVICEID"]])
         {
             [PDKeyChain save:@"APP_DEVICEID" data:device];
         }
         
         if ([NSString isNulllWithObject:[UserSignData share].user.token])
         {
             [UserSignData share].user = [[UserModel alloc] init];
             [UserSignData share].user.walletUnitType = 1;
             [UserSignData share].user.ETHAssets_ether = @"0.0000";
             [UserSignData share].user.ETHAssets_cny = @"0.00";
             [UserSignData share].user.BTCAssets_ether = @"0.0000";
             [UserSignData share].user.BTCAssets_cny = @"0.00";
             [UserSignData share].user.totalAssets = @"0.00";
         }
         [UserSignData share].user.token = [responseObject objectForKey:@"token"];
         [UserSignData share].user.open_id = [[responseObject objectForKey:@"user"] objectForKey:@"open_id"];
         [UserSignData share].user.nickname = [[responseObject objectForKey:@"user"] objectForKey:@"nickname"];
         [UserSignData share].user.sex = [[responseObject objectForKey:@"user"] objectForKey:@"sex"];
         [UserSignData share].user.img = [[responseObject objectForKey:@"user"] objectForKey:@"img"];
         [UserSignData share].user.isCode = NO;
         [UserSignData share].user.walletUnitType = 1;
         [[UserSignData share] storageData:[UserSignData share].user];
         [UserSignData share].user.isRefeshAssets = YES;
         
         if ([NSString isNulllWithObject:[UserSignData share].user.nickname])
         {
             [UserSignData share].user.nickname = [APP_DEVICEID substringToIndex:12];
         }
         
         if ([NSString isNulllWithObject:[UserSignData share].user.sex])
         {
             [UserSignData share].user.sex = @"1";
         }
         
         if ([NSString isNulllWithObject:[UserSignData share].user.img])
         {
             [UserSignData share].user.img = @"1";
         }
         
         [[AppDelegate delegate] goToTabbar];
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
         
     }];
}

#pragma mark - 微信登录

- (IBAction)hotPurseButtonCilick:(id)sender
{
    //热钱包
    self.ishot = YES;
    
    [self weChatLogin];
}

- (IBAction)coldPurseButtonCilick:(id)sender
{
    //冷钱包
//    if ([NSString isNulllWithObject:[PPNetworkCache getResponseCacheForKey:@"wallet-category"]])
//    {
//        [LCProgressHUD showInfoMsg:@"暂未获取到钱包类型，请联网好再打开"];
//        //获取钱包类型
//        [PPNetworkHelper GET:@"wallet-category" parameters:nil hudString:nil responseCache:^(id responseCache)
//         {
//         } success:^(id responseObject)
//         {
//         } failure:^(NSString *error)
//         {
//         }];
//        return;
//    }
    //判断是不是飞行模式
    self.networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    if ([NSString isNulllWithObject:self.networkInfo.currentRadioAccessTechnology])
    {
        if ([NSString isNulllWithObject:[UserSignData share].user.token])
        {
            [UserSignData share].user = [[UserModel alloc] init];
            [UserSignData share].user.walletUnitType = 1;
        }
        [UserSignData share].user.nickname = @"冷钱包";
        [UserSignData share].user.ETHAssets_ether = @"0.0000";
        [UserSignData share].user.ETHAssets_cny = @"0.00";
        [UserSignData share].user.BTCAssets_ether = @"0.0000";
        [UserSignData share].user.BTCAssets_cny = @"0.00";
        [UserSignData share].user.totalAssets = @"0.00";
        [UserSignData share].user.walletUnitType = 1;

        [UserSignData share].user.isCode = YES;
        [[UserSignData share] storageData:[UserSignData share].user];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"CODE" forKey:@"appWalletStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[AppDelegate delegate] goToTabbar];
    }
    else
    {
        //清楚热钱包缓存
        
        self.ishot = NO;
        YYCache * dataCache = [YYCache cacheWithName:@"FBGNetworkResponseCache"];
        [dataCache removeAllObjects];
        self.alertView.alertImageView.image = [UIImage imageNamed:@"tip"];
        self.alertView.alertContInfoLB.text = @"手机启用飞行模式后才可以创建冷钱包，冷钱包创建后无法切换热钱包，请备份钱包";
        [self.alertView show];
    }
}

- (TowButtonAlertView *)alertView
{
    if (!_alertView)
    {
        _alertView = [[TowButtonAlertView alloc] initWithFrame:[AppDelegate delegate].window.bounds];
        _alertView.delegate = self;
    }
    return _alertView;
}

@end
