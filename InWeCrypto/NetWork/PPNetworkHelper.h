//
//  PPNetworkHelper.h
//  PPNetworkHelper
//
//  Created by AndyPang on 16/8/12.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PPNetworkStatus) {
    /** 未知网络*/
    PPNetworkStatusUnknown,
    /** 无网络*/
    PPNetworkStatusNotReachable,
    /** 手机网络*/
    PPNetworkStatusReachableViaWWAN,
    /** WIFI网络*/
    PPNetworkStatusReachableViaWiFi
};

/** 请求成功的Block */
typedef void(^HttpRequestSuccess)(id responseObject);

/** 请求失败的Block */
typedef void(^HttpRequestFailed)(NSString *error);

/** 缓存的Block */
typedef void(^HttpRequestCache)(id responseCache);

/** 特殊处理Block */
typedef void(^HttpRequestSpecial)(void);

/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^HttpProgress)(NSProgress *progress);

/** 网络状态的Block*/
typedef void(^NetworkStatus)(PPNetworkStatus status);

/** 请求任务 */
typedef NSURLSessionTask PPURLSessionTask;

#pragma mark - 网络数据请求类


@interface PPNetworkHelper : NSObject

/**
 *  开始监听网络状态
 */
+ (void)startMonitoringNetwork;

/**
 *  实时获取网络状态回调
 */
+ (void)networkStatusWithBlock:(NetworkStatus)status;

/**
 *  GET请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (PPURLSessionTask *)GET:(NSString *)URL baseUrlType:(BaseURLType)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

/**
 *  GET请求,自动缓存
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (PPURLSessionTask *)GET:(NSString *)URL baseUrlType:(BaseURLType)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

/**
 *  POST请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (PPURLSessionTask *)POST:(NSString *)URL baseUrlType:(BaseURLType)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

/**
 *  POST请求,自动缓存
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (PPURLSessionTask *)POST:(NSString *)URL baseUrlType:(BaseURLType)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

// PUT 请求
+ (PPURLSessionTask *)PUT:(NSString *)URL baseUrlType:(BaseURLType)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

// DELETE 请求
+ (PPURLSessionTask *)DELETE:(NSString *)URL baseUrlType:(BaseURLType)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

+ (BOOL)hasConnectedNetwork;

#pragma mark -- 根据项目需求更改


@end

