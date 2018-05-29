//
//  PPNetworkHelper.m
//  PPNetworkHelper
//
//  Created by AndyPang on 16/8/12.
//  Copyright © 2016年 AndyPang. All rights reserved.
//


#import "PPNetworkHelper.h"
#import "PPNetworkCache.h"
#import <AFNetworking/AFNetworking.h>

#define MainScreenW [UIScreen mainScreen].bounds.size.width
#ifdef DEBUG
#define PPLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define PPLog(...)
#endif

@implementation PPNetworkHelper
static AFHTTPSessionManager *_manager = nil;
static NetworkStatus _status;

#pragma mark - 开始监听网络

+ (BOOL)hasConnectedNetwork {
   AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    BOOL result = NO;
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            NSLog(@"未知网络");
            result = YES;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            NSLog(@"未连接");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@"4G");
            result = YES;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            NSLog(@"WIFI");
            result = YES;
            break;
    }
    return result;
}

+ (void)startMonitoringNetwork {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 网络提示
    static UILabel *_warningLabel = nil;
    _warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(-MainScreenW, 64, MainScreenW, 44)];
    _warningLabel.backgroundColor = [UIColor colorWithRed:0.996f green:0.973f blue:0.718f alpha:1.00f];
    _warningLabel.text = DBHGetStringWithKeyFromTable(@"The current network is not available, please check your network Settings.", nil);
    _warningLabel.numberOfLines = 0;
    _warningLabel.textAlignment = NSTextAlignmentCenter;
    _warningLabel.font = [UIFont systemFontOfSize:14];
    [[[UIApplication sharedApplication] keyWindow]addSubview:_warningLabel];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                _status(PPNetworkStatusUnknown);
                [self showMsg:DBHGetStringWithKeyFromTable(@"Unknown network", nil) forStatus:YES warningLabel:_warningLabel];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                _status(PPNetworkStatusNotReachable);
                [self showMsg:DBHGetStringWithKeyFromTable(@"The current network is not available, please check your network Settings.", nil) forStatus:NO warningLabel:_warningLabel];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _status(PPNetworkStatusReachableViaWWAN);
                [self showMsg:DBHGetStringWithKeyFromTable(@"The network of mobile", nil) forStatus:YES warningLabel:_warningLabel];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _status(PPNetworkStatusReachableViaWiFi);
                [self showMsg:@"WIFI" forStatus:YES warningLabel:_warningLabel];
                break;
        }
    }];
    [manager startMonitoring];
}

+ (void)showMsg:(NSString*)msg forStatus:(BOOL)status warningLabel:(UILabel*)warningLabel {
    if (!status) {
        [[[UIApplication sharedApplication] keyWindow]addSubview:warningLabel];
        warningLabel.text = msg;
        __block CGRect rect = warningLabel.frame;
        [UIView animateWithDuration:0.3 animations:^{
            rect.origin.x = 0;
            warningLabel.frame = rect;
        }];
    } else {
        if (warningLabel && warningLabel.frame.origin.x == 0) {
            
            [UIView transitionWithView:warningLabel duration:0.33 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
                warningLabel.text = msg;
            } completion:^(BOOL finished) {
                __block CGRect rect = warningLabel.frame;
                [UIView animateWithDuration:0.6 animations:^{
                    rect.origin.x = MainScreenW;
                    warningLabel.frame = rect;
                } completion:^(BOOL finished) {
                    rect.origin.x = -MainScreenW;
                    warningLabel.frame = rect;
                    [warningLabel removeFromSuperview];
                }];
            }];
        }
    }
}

+ (void)networkStatusWithBlock:(NetworkStatus)status
{
    _status = status;
}

+ (void)gotoLoginVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        [LCProgressHUD hide];
        UIViewController *targetVC = [UIView currentViewController];
        [[AppDelegate delegate] goToLoginVC:targetVC];
    });
}

/**
 设置开始/结束请求时的UI变化
 
 @param isStart 开始/结束请求
 @param hudString 加载提示语
 */
+ (void)setStartRequestUI:(BOOL)isStart hudString:(NSString *)hudString {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isStart) {
            [LCProgressHUD showLoading:hudString];
        } else {
            [LCProgressHUD hide];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = isStart;
    });
}

/**
 如果开始处于登录状态，需先退出登录
 */
+ (void)gotologinAndchangeLoginStatusIfLogin {
    if ([UserSignData share].user.isLogin) { // 登录状态 --> 未登录状态
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            [[UserSignData share] storageData:nil];
            
            UserModel *user = [UserSignData share].user;
            // 货币单位跟随语言
            user.walletUnitType = [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? 1 : 2;
            [[UserSignData share] storageData:user];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_LOGIN_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[EMClient sharedClient].options setIsAutoLogin:NO];
        }
    }
    
    [UserSignData share].user.token = nil;
    [[UserSignData share] storageData:[UserSignData share].user];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self gotoLoginVC];
    });
}

/**
 处理响应成功数据
 
 @param responseObj 响应数据
 @param URL url
 @param parameters 参数
 @param hudString 加载提示语
 @param success 成功block
 @param failure 失败block
 @param isCache 是否缓存
 @param isHandleErrorCode 是否处理要登录的错误码
 */
+ (void)handleResponseSuccess:(id)responseObj URL:(NSString *)URL parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure isCache:(BOOL)isCache isHandleErrorCode:(BOOL)isHandleErrorCode {
    [self setStartRequestUI:NO hudString:hudString];
    
    if ([NSObject isNulllWithObject:responseObj] || ![responseObj isKindOfClass:[NSDictionary class]]) {
        //接收数据格式不正确
        failure ? failure(nil) : nil;
        return ;
    }
    
    ResponseCode code = [responseObj[CODE] intValue];
    switch (code) {
        case ResponseCodeSuccess: { //4000
            id data = responseObj[DATA];
            success ? success(data) : nil;
            
            if (isCache && ![NSObject isNulllWithObject:data]) { // 不为空--缓存到本地
                NSString *key = [NSString stringWithFormat:@"%@/%@", URL, [NSString dataTOjsonString:parameters]];
                [PPNetworkCache saveResponseCache:data forKey:key];
            }
            break;
        }
            
        case ResponseCodeSuccessAndPush: { // 4007
            if (success) {
                NSString *urlStr = responseObj[@"url"];
                success(urlStr);
            }
            break;
        }
            
        default: {
            if (isHandleErrorCode) {
                if (code == ResponseCodeUnLogin || // 4001
                    code == ResponseCodeTokenInvalidate || // 4009
                    code == ResponseCodeTokenExpired ||  // 4010
                    code == ResponseCodeAcountFrozen) { // 4011
                    [self gotologinAndchangeLoginStatusIfLogin];
                    break;
                }
            }
            
//            if (![UserSignData share].user.token.length) {
//                [self gotologinAndchangeLoginStatusIfLogin];
//            } else
            if (failure) {
                NSString *errorMsg = responseObj[MSG];
                failure(errorMsg);
            }
            break;
        }
    }
}

/**
 处理响应数据出错

 @param error 错误
 @param hudString 加载提示语
 @param failure 失败block
 */
+ (void)handleResponseFailed:(NSError *)error hudString:(NSString *)hudString failure:(HttpRequestFailed)failure {
    [self setStartRequestUI:NO hudString:hudString];
    
    failure ? failure(error.localizedDescription) : nil;
    PPLog(@"error = %@", error.localizedDescription);
}

#pragma mark - GET请求无缓存
+ (PPURLSessionTask *)GET:(NSString *)URL baseUrlType:(BaseURLType)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    return [self GET:URL baseUrlType:baseUrlType parameters:parameters hudString:hudString responseCache:nil success:success failure:failure];
}

#pragma mark - GET请求自动缓存
+ (PPURLSessionTask *)GET:(NSString *)URL baseUrlType:(BaseURLType)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    [self setStartRequestUI:YES hudString:hudString];
    
    PPLog(@"❤️GET URL❤️ = %@ -+++❤️+++- %@", URL, [NSThread currentThread]);
    PPLog(@"⚽️GET 数据⚽️ = %@",parameters);
    if (responseCache) { //读取缓存
        id cache = [PPNetworkCache getResponseCacheForKey:[NSString stringWithFormat:@"%@/%@", URL, [NSString dataTOjsonString:parameters]]];
        responseCache(cache);
    }
    
    if (![self hasConnectedNetwork]) {
        [self setStartRequestUI:NO hudString:hudString];
        //是否需要提示无网络
        return nil;
    }
    
    WEAKSELF
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL baseUrlType:baseUrlType];
    return [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf handleResponseSuccess:responseObject URL:URL parameters:parameters hudString:hudString success:success failure:failure isCache:YES isHandleErrorCode:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf handleResponseFailed:error hudString:hudString failure:failure];
    }];
}

#pragma mark - POST请求无缓存
+ (PPURLSessionTask *)POST:(NSString *)URL baseUrlType:(BaseURLType)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    return [self POST:URL baseUrlType:baseUrlType parameters:parameters hudString:hudString responseCache:nil success:success failure:failure];
}

#pragma mark - POST请求自动缓存
+ (PPURLSessionTask *)POST:(NSString *)URL baseUrlType:(BaseURLType)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    [self setStartRequestUI:YES hudString:hudString];
    
    PPLog(@"❤️POST URL❤️ = %@",URL);
    PPLog(@"⚽️POST 数据⚽️ = %@",parameters);
    
    if (responseCache) { //读取缓存
        id cache = [PPNetworkCache getResponseCacheForKey:[NSString stringWithFormat:@"%@/%@", URL, [NSString dataTOjsonString:parameters]]];
        responseCache(cache);
    }
    
    if (![self hasConnectedNetwork]) {
        [self setStartRequestUI:NO hudString:hudString];
        //是否需要提示无网络
        return nil;
    }
    
    WEAKSELF
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL baseUrlType:baseUrlType];
    return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf handleResponseSuccess:responseObject URL:URL parameters:parameters hudString:hudString success:success failure:failure isCache:YES isHandleErrorCode:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf handleResponseFailed:error hudString:hudString failure:failure];
    }];
    
}

+ (PPURLSessionTask *)PUT:(NSString *)URL baseUrlType:(BaseURLType)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    PPLog(@"❤️PUT URL❤️ = %@",URL);
    PPLog(@"⚽️PUT 数据⚽️ = %@",parameters);
    
    if (![self hasConnectedNetwork]) {
        //是否需要提示无网络
        return nil;
    }
    
    [self setStartRequestUI:YES hudString:hudString];
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL baseUrlType:baseUrlType];
    
    WEAKSELF
    return [manager PUT:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf handleResponseSuccess:responseObject URL:URL parameters:parameters hudString:hudString success:success failure:failure isCache:NO isHandleErrorCode:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf handleResponseFailed:error hudString:hudString failure:failure];
    }];
}

+ (PPURLSessionTask *)DELETE:(NSString *)URL baseUrlType:(BaseURLType)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    PPLog(@"❤️DELETE URL❤️ = %@",URL);
    PPLog(@"⚽️DELETE 数据⚽️ = %@",parameters);
    if (![self hasConnectedNetwork]) {
        //是否需要提示无网络
        return nil;
    }
    
    [self setStartRequestUI:YES hudString:hudString];
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL baseUrlType:baseUrlType];
    
    WEAKSELF
    return [manager DELETE:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf handleResponseSuccess:responseObject URL:URL parameters:parameters hudString:hudString success:success failure:failure isCache:NO isHandleErrorCode:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf handleResponseFailed:error hudString:hudString failure:failure];
    }];
}

#pragma mark - 设置AFHTTPSessionManager相关属性
/**
 创建并设置sessionManager
 
 @param url url
 @param baseUrlType baseUrlType
 @return manager
 */
+ (AFHTTPSessionManager *)createAFHTTPSessionManagerWithUrl:(NSString *)url baseUrlType:(BaseURLType)baseUrlType {
    NSString *baseUrl;
    BOOL isOfficial = [APP_APIEHEAD isEqualToString:V2API];
    switch (baseUrlType) {
        case BaseURLTypeV2API:
            baseUrl = isOfficial ? V2API : TESTV2API;
            break;
        case BaseURLTypeV1:
            baseUrl = isOfficial ? V1 : TESTV1;
            break;
        default:
            baseUrl = isOfficial ? V2 : TESTV2;
            break;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60.f; //设置请求的超时时间
    
    //设置服务器返回结果的类型:JSON
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"application/x-www-form-urlencoded",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html",
                                                         @"text/plain",
                                                         nil];
    [manager.requestSerializer setValue:[[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? @"zh" : @"en" forHTTPHeaderField:@"lang"];
    if ([UserSignData share].user.token.length > 0) {
        [manager.requestSerializer setValue:[UserSignData share].user.token forHTTPHeaderField:@"Authorization"];
        [manager.requestSerializer setValue:@"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b" forHTTPHeaderField:@"neo-asset-id"];
        [manager.requestSerializer setValue:@"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7" forHTTPHeaderField:@"neo-gas-asset-id"];
    }
    return manager;
}

@end
