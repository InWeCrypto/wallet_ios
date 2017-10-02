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
+ (void)startMonitoringNetwork
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 网络提示
    static UILabel *_warningLabel = nil;
    _warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(-MainScreenW, 64, MainScreenW, 44)];
    _warningLabel.backgroundColor = [UIColor colorWithRed:0.996f green:0.973f blue:0.718f alpha:1.00f];
    _warningLabel.text = @"当前网络不可用,请检查你的网络设置";
    _warningLabel.textAlignment = NSTextAlignmentCenter;
    _warningLabel.font = [UIFont systemFontOfSize:14];
    [[[UIApplication sharedApplication] keyWindow]addSubview:_warningLabel];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                _status(PPNetworkStatusUnknown);
                [self showMsg:@"未知网络" forStatus:YES warningLabel:_warningLabel];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                _status(PPNetworkStatusNotReachable);
                [self showMsg:@"当前网络不可用,请检查你的网络设置" forStatus:NO warningLabel:_warningLabel];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _status(PPNetworkStatusReachableViaWWAN);
                [self showMsg:@"手机自带网络" forStatus:YES warningLabel:_warningLabel];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _status(PPNetworkStatusReachableViaWiFi);
                [self showMsg:@"WIFI" forStatus:YES warningLabel:_warningLabel];
                break;
        }
    }];
    [manager startMonitoring];
}

+ (void)showMsg:(NSString*)msg forStatus:(BOOL)status warningLabel:(UILabel*)warningLabel
{
    if (!status) {
        [[[UIApplication sharedApplication] keyWindow]addSubview:warningLabel];
        warningLabel.text = msg;
        __block CGRect rect = warningLabel.frame;
        [UIView animateWithDuration:0.3 animations:^{
            rect.origin.x = 0;
            warningLabel.frame = rect;
        }];
    }
    else {
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

#pragma mark - GET请求无缓存
+ (PPURLSessionTask *)GET:(NSString *)URL parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    if (![NSString isNulllWithObject:hudString])
    {
        [LCProgressHUD showLoading:hudString];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    PPLog(@"❤️GET URL❤️ = %@",URL);
    PPLog(@"⚽️GET 数据⚽️ = %@",parameters);
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL];
    return [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (![NSString isNulllWithObject:hudString])
        {
            [LCProgressHUD hide];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([[responseObject objectForKey:@"code"] intValue] == 4000)
        {
            success([responseObject objectForKey:@"data"]);
            PPLog(@"responseObject = %@",responseObject);
        }
        else if ([[responseObject objectForKey:@"code"] intValue] == 4007)
        {
            success([responseObject objectForKey:@"url"]);
        }
        else
        {
            if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] containsString:@"token无效"])
            {
                [[AppDelegate delegate] showLoginController];
            }
            else
            {
                failure([responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (![NSString isNulllWithObject:hudString])
        {
            [LCProgressHUD hide];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error.localizedDescription) : nil;
        PPLog(@"error = %@",error.localizedFailureReason);
    }];
}

#pragma mark - GET请求自动缓存
+ (PPURLSessionTask *)GET:(NSString *)URL parameters:(NSDictionary *)parameters hudString:(NSString *)hudString responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    if (![NSString isNulllWithObject:hudString])
    {
        [LCProgressHUD showLoading:hudString];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    PPLog(@"❤️GET URL❤️ = %@",URL);
    PPLog(@"⚽️GET 数据⚽️ = %@",parameters);
    //读取缓存
    responseCache([PPNetworkCache getResponseCacheForKey:URL]);
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL];
    return [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (![NSString isNulllWithObject:hudString])
        {
            [LCProgressHUD hide];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([[responseObject objectForKey:@"code"] intValue] == 4000)
        {
            success([responseObject objectForKey:@"data"]);
            [PPNetworkCache saveResponseCache:[responseObject objectForKey:@"data"] forKey:URL];
            PPLog(@"responseObject = %@",responseObject);
        }
        else if ([[responseObject objectForKey:@"code"] intValue] == 4007)
        {
            success([responseObject objectForKey:@"url"]);
        }
        else
        {
            if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] containsString:@"token无效"])
            {
                [[AppDelegate delegate] showLoginController];
            }
            else
            {
                failure([responseObject objectForKey:@"msg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (![NSString isNulllWithObject:hudString])
        {
            [LCProgressHUD hide];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error.localizedDescription) : nil;
        PPLog(@"error = %@",error.localizedDescription);
    }];
}

#pragma mark - POST请求无缓存
+ (PPURLSessionTask *)POST:(NSString *)URL parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    if (![NSString isNulllWithObject:hudString])
    {
        [LCProgressHUD showLoading:hudString];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL];
    PPLog(@"❤️POST URL❤️ = %@",URL);
    PPLog(@"⚽️POST 数据⚽️ = %@",parameters);
    
    return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (![NSString isNulllWithObject:hudString])
        {
            [LCProgressHUD hide];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([[responseObject objectForKey:@"code"] intValue] == 4000)
        {
            success([responseObject objectForKey:@"data"]);
            PPLog(@"responseObject = %@",responseObject);
        }
        else if ([[responseObject objectForKey:@"code"] intValue] == 4007)
        {
            success([responseObject objectForKey:@"url"]);
        }
        else
        {
            if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] containsString:@"token无效"])
            {
                [[AppDelegate delegate] showLoginController];
            }
            else
            {
                failure([responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (![NSString isNulllWithObject:hudString])
        {
            [LCProgressHUD hide];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error.localizedDescription) : nil;
        PPLog(@"error = %@",error.localizedDescription);
    }];
    
}

#pragma mark - POST请求自动缓存
+ (PPURLSessionTask *)POST:(NSString *)URL parameters:(NSDictionary *)parameters hudString:(NSString *)hudString responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    if (![NSString isNulllWithObject:hudString])
    {
        [LCProgressHUD showLoading:hudString];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    PPLog(@"❤️POST URL❤️ = %@",URL);
    PPLog(@"⚽️POST 数据⚽️ = %@",parameters);
    //读取缓存
    responseCache([PPNetworkCache getResponseCacheForKey:URL]);
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL];
    return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (![NSString isNulllWithObject:hudString])
        {
            [LCProgressHUD hide];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([[responseObject objectForKey:@"code"] intValue] == 4000)
        {
            success([responseObject objectForKey:@"data"]);
            [PPNetworkCache saveResponseCache:[responseObject objectForKey:@"data"] forKey:URL];
            PPLog(@"responseObject = %@",responseObject);
        }
        else if ([[responseObject objectForKey:@"code"] intValue] == 4007)
        {
            success([responseObject objectForKey:@"url"]);
        }
        else
        {
            if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] containsString:@"token无效"])
            {
                [[AppDelegate delegate] showLoginController];
            }
            else
            {
                failure([responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (![NSString isNulllWithObject:hudString])
        {
            [LCProgressHUD hide];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error.localizedDescription) : nil;
        PPLog(@"error = %@",error.localizedDescription);
    }];
    
}

+ (PPURLSessionTask *)PUT:(NSString *)URL parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    if (![NSString isNulllWithObject:hudString])
    {
        [LCProgressHUD showLoading:hudString];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL];
    PPLog(@"❤️PUT URL❤️ = %@",URL);
    PPLog(@"⚽️PUT 数据⚽️ = %@",parameters);
    
    return [manager PUT:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (![NSString isNulllWithObject:hudString])
        {
            [LCProgressHUD hide];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([[responseObject objectForKey:@"code"] intValue] == 4000)
        {
            success([responseObject objectForKey:@"data"]);
            PPLog(@"responseObject = %@",responseObject);
        }
        else if ([[responseObject objectForKey:@"code"] intValue] == 4007)
        {
            success([responseObject objectForKey:@"url"]);
        }
        else
        {
            failure([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (![NSString isNulllWithObject:hudString])
        {
            [LCProgressHUD hide];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error.localizedDescription) : nil;
        PPLog(@"error = %@",error.localizedDescription);
    }];
}

+ (PPURLSessionTask *)DELETE:(NSString *)URL parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    if (![NSString isNulllWithObject:hudString])
    {
        [LCProgressHUD showLoading:hudString];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL];
    PPLog(@"❤️DELETE URL❤️ = %@",URL);
    PPLog(@"⚽️DELETE 数据⚽️ = %@",parameters);
    
    return [manager DELETE:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
            {
                if (![NSString isNulllWithObject:hudString])
                {
                    [LCProgressHUD hide];
                }
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                if ([[responseObject objectForKey:@"code"] intValue] == 4000)
                {
                    success([responseObject objectForKey:@"data"]);
                    PPLog(@"responseObject = %@",responseObject);
                }
                else if ([[responseObject objectForKey:@"code"] intValue] == 4007)
                {
                    success([responseObject objectForKey:@"url"]);
                }
                else
                {
                    failure([responseObject objectForKey:@"msg"]);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
            {
                if (![NSString isNulllWithObject:hudString])
                {
                    [LCProgressHUD hide];
                }
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                failure ? failure(error.localizedDescription) : nil;
                PPLog(@"error = %@",error.localizedDescription);
            }];
}


#pragma mark - 上传图片文件
+ (PPURLSessionTask *)uploadWithURL:(NSString *)URL parameters:(NSDictionary *)parameters images:(NSArray<UIImage *> *)images name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType hudString:(NSString *)hudString progress:(HttpProgress)progress success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{   
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if (![NSString isNulllWithObject:hudString])
    {
        [LCProgressHUD showLoading:@"上传中..."];
    }
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL];
    return [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //压缩-添加-上传图片
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%@%ld.%@",fileName,idx,mimeType?mimeType:@"jpeg"] mimeType:[NSString stringWithFormat:@"image/%@",mimeType?mimeType:@"jpeg"]];
            
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        progress ? progress(uploadProgress) : nil;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (![NSString isNulllWithObject:hudString])
        {
            [LCProgressHUD hide];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        success(responseObject);
        PPLog(@"responseObject = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (![NSString isNulllWithObject:hudString])
        {
            [LCProgressHUD hide];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error.localizedDescription) : nil;
        PPLog(@"error = %@",error.localizedDescription);
    }];
}

#pragma mark - 下载文件
+ (PPURLSessionTask *)downloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(HttpProgress)progress success:(void(^)(NSString *))success failure:(HttpRequestFailed)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        progress ? progress(downloadProgress) : nil;
        PPLog(@"下载进度:%.2f%%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        
        PPLog(@"downloadDir = %@",downloadDir);
        
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        failure && error ? failure(error.localizedDescription) : nil;
        
    }];
    
    //开始下载
    [downloadTask resume];
    
    return downloadTask;
}


#pragma mark - 设置AFHTTPSessionManager相关属性

+ (AFHTTPSessionManager *)createAFHTTPSessionManagerWithUrl:(NSString *)url
{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:APP_APIEHEAD]];
    //设置请求参数的类型:HTTP (AFJSONRequestSerializer,AFHTTPRequestSerializer)
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置请求的超时时间
    manager.requestSerializer.timeoutInterval = 60.f;
//    manager.operationQueue.maxConcurrentOperationCount = 10;
    //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/x-www-form-urlencoded", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    if ([UserSignData share].user.token.length > 0)
    {
        [manager.requestSerializer setValue:[UserSignData share].user.token forHTTPHeaderField:@"ct"];
    }
    return manager;
}

- (NSString *)errorFromCode:(int)code
{
    /*
     4000    请求执行成功
     4001    未登陆
     4002    无权限
     4003    路由不存在
     4004    验证不通过
     4005    查询数据不存在
     4006    请求执行失败
     4007    请求执行成功,即将跳转
     4008    未注册
     4009    token过期
     */
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"请求执行成功" forKey:@"4000"];
    [dic setObject:@"未登陆" forKey:@"4001"];
    [dic setObject:@"无权限" forKey:@"4002"];
    [dic setObject:@"路由不存在" forKey:@"4003"];
    [dic setObject:@"验证不通过" forKey:@"4004"];
    [dic setObject:@"查询数据不存在" forKey:@"4005"];
    [dic setObject:@"请求执行失败" forKey:@"4006"];
    [dic setObject:@"请求执行成功,即将跳转" forKey:@"4007"];
    [dic setObject:@"未注册" forKey:@"4008"];
    [dic setObject:@"token过期" forKey:@"4009"];
    
    return [dic objectForKey:[NSString stringWithFormat:@"%d",code]];
}

@end
