//
//  DBHBaseProtocol.m
//  FBG
//
//  Created by yy on 2018/3/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#define IP_ADDRESS_FROM_HOSTNAME @"ip_address_from_%@"
#define DEFAULT_REPLACE_IP @""

#include <sys/socket.h>
#include <netdb.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#import "DBHBaseProtocol.h"
#import "AFNetworking.h"
#import "DBHLanguageTool.h"

@implementation DBHBaseProtocol

/**
 将dic转成json字符串

 @param dic dic
 @return jsonstr
 */
- (NSString *)JSONString:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&parseError];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/**
 根据hostName获取主机IP

 @param hostName hostname
 @return ip
 */
+ (NSString *)getIPWithHostName:(const NSString *)hostName {
    const char* szname = [hostName UTF8String];
    struct hostent* phot;
    @try {
        phot = gethostbyname(szname);
        if (phot == NULL) {
            return nil;
        }
    } @catch (NSException * e) {
        return nil;
    }
    
    struct in_addr ip_addr;
    memcpy(&ip_addr,phot->h_addr_list[0],4);///h_addr_list[0]里4个字节,每个字节8位，此处为一个数组，一个域名对应多个ip地址或者本地时一个机器有多个网卡
    
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
}


/**
 替换url为主机IP

 @param target url
 @return 替换后的
 
 备注： 如果要用，需先设置 DEFAULT_REPLACE_IP 的值
 */
- (NSString *)getReplacedUrlByUrl:(NSString *)target {
    @autoreleasepool {
        if ([NSObject isNulllWithObject:target]) {
            return nil;
        }
        
        NSString *hostName = [NSURL URLWithString:target].host;
        NSString *key = [NSString stringWithFormat:IP_ADDRESS_FROM_HOSTNAME, hostName];
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:key];
        //如果本地取出的IP为空
        if ([NSObject isNulllWithObject:ip]) {
            ip = [DBHBaseProtocol getIPWithHostName:hostName];
            
            if ([NSObject isNulllWithObject:ip]) {
                ip = DEFAULT_REPLACE_IP;
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:ip ? ip : @"" forKey:key];
            }
        }
        if (![NSObject isNulllWithObject:hostName] && ![NSObject isNulllWithObject:ip]){
            NSString *addr = [target stringByReplacingOccurrencesOfString:hostName withString:ip];
            return addr;
        }
        
        return @"";
    }
}

@end
