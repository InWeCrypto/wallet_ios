//
//  CommonUtils.m
//  InWeCrypto
//
//  Created by 赵旭瑞 on 2018/5/21.
//  Copyright © 2018年 赵旭瑞. All rights reserved.
//

#import "CommonUtils.h"


#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation CommonUtils

/**
 *  获取IP地址
 *
 *  @param preferIPv4 是否ip4
 *
 *  @return IP地址
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}


+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


/**
 *  字符串日期转换成nsDate
 *
 */
+ (NSDate *)convertStringToDate:(NSString *)strDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_CN"];//本地化
    [df setLocale:locale];
    return [df dateFromString:strDate];

//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
//    return [dateFormatter dateFromString:strDate];
}


/**
 *  从nsdate转成时间戳
 */
+ (NSString *)convertDateToTimestamp:(NSDate *)date {
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

/**
 *  从时间戳转成nsdate
 *
 */
+ (NSString *) convertTimestampToDate :(NSTimeInterval)Timestamp {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:Timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:confromTimesp];
    return destDateString;
}

+ (NSString *) convertTimestamp :(NSTimeInterval)Timestamp {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:Timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:confromTimesp];
    return destDateString;
}

+ (NSString *) convertTimestampToSimpleDate :(NSTimeInterval)Timestamp {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:Timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy/M/d"];
    NSString *destDateString = [dateFormatter stringFromDate:confromTimesp];
    return destDateString;
}

/**
 *  把两个时间戳的时间差
 */
+ (NSDateComponents *)calcuSendTime:(NSTimeInterval)estimateTimeStamp serverTime:(NSTimeInterval)serverTimeStamp {
    NSDate *confromDate = [NSDate dateWithTimeIntervalSince1970:estimateTimeStamp];
    NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:serverTimeStamp];
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ;
    NSDateComponents *d = [cal components:unitFlags fromDate:serverDate toDate:confromDate options:0 ];
    
    //    NSLog(@"%@", [NSString stringWithFormat:@"%d年%d月%d日%d时%d分%d秒",[d year],[d month], [d day], [d hour], [d minute], [d second]]);
    return d;
}



/**
 *  切割字符串
 *
 *  @param string 原字符串
 *
 *  @return 生成的数组
 */
+ (NSArray *)convertStringToArray:(NSString *)string splitString:(NSString *)splitString {
    return [string componentsSeparatedByString:splitString];
}

/**
 *  创建路径
 *
 *  @param path 路径
 *
 *  @return 是否创建成功
 */
+ (BOOL)createDirectorysAtPath:(NSString *)path {
    @synchronized(self){
        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:path]) {
            NSError *error = nil;
            if (![manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
                return NO;
            }
        }
    }
    return YES;
}

/**
 *  获取文件所在的路径
 *
 *  @param filepath 文件路径
 *
 *  @return 获取文件所在的路径
 */
+ (NSString*)getDirectoryPathByFilePath:(NSString *)filepath {
    if(!filepath || [filepath length] == 0){
        return @"";
    }
    
    int pathLength = [filepath length];
    int fileLength = [[filepath lastPathComponent] length];
    return [filepath substringToIndex:(pathLength - fileLength - 1)];
}

/**
 *  计算行高
 *
 *  @param text 内容信息
 *  @param font 内容字体
 *  @param boundingSize 所有组件的最大尺寸
 *
 *  @return size
 */
+ (CGSize)getTextSize:(NSString *)text textFont:(UIFont *)font boundingRect:(CGSize)boundingSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    return [text boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
}



+ (CGSize)getTextSizeWithLineSpace:(NSString *)text textFont:(UIFont *)font boundingRect:(CGSize)boundingSize lineBreakMode:(NSLineBreakMode)lineBreakMode andLinespace:(CGFloat)space {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:space];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    return [text boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
}

/**
 *  计算行高(带换行)
 *
 *  @param text 内容信息
 *  @param font 内容字体
 *  @param boundingSize 所有组件的最大尺寸
 *
 *  @return size
 */
+ (CGFloat)getTextHeightWithReturn:(NSString *)text textFont:(UIFont *)font boundingRect:(CGSize)boundingSize lineBreakMode:(NSLineBreakMode)lineBreakMode andLinespace:(CGFloat)space {
    NSArray *arrText = [text componentsSeparatedByString:@"\n"];
    CGFloat totalHeight = 0;
    if (arrText.count > 0) {
        for (int i = 0; i<arrText.count; i++) {
            totalHeight += [self getTextSizeWithLineSpace:arrText[i] textFont:font boundingRect:boundingSize lineBreakMode:lineBreakMode andLinespace:space].height + space;
        }
    }
    return totalHeight;
}



/**
 *  添加确定按钮到keyboad
 *
 *  @param superController keyboard所在controller
 *  @param tv              keyboard所在控件
 */
+ (void)addConfirmToKeyborad : (UIViewController *)superController textField:(UITextField *)tf {
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.backgroundColor = [UIColor colorWithHexString:@"d1d5db"];
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    // toolbar上的2个按钮
    UIBarButtonItem *SpaceButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil  action:nil]; // 让完成按钮显示在右侧
    
    //    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"confirm", nil)
    //                                                                   style:UIBarButtonItemStyleBordered target:superController
    //                                                                  action:@selector(closeKeyboard)];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_bar_close", nil)
                                                                   style:UIBarButtonItemStyleBordered target:superController
                                                                  action:@selector(closeKeyboard)];
    
    doneButton.tintColor = [UIColor blackColor];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:SpaceButton, doneButton, nil]];
    tf.inputAccessoryView = keyboardDoneButtonView;
}

/**
 *  添加确定按钮到keyboad
 *
 *  @param superController keyboard所在controller
 *  @param tv              keyboard所在控件
 */
+ (void)addConfirmToKeyborad : (UIViewController *)superController textView:(UITextView *)tv {
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    //    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.backgroundColor = [UIColor colorWithHexString:@"d1d5db"];
    
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    // toolbar上的2个按钮
    UIBarButtonItem *SpaceButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil  action:nil]; // 让完成按钮显示在右侧
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_bar_close", nil)
                                                                   style:UIBarButtonItemStyleBordered target:superController
                                                                  action:@selector(closeKeyboard)];
    doneButton.tintColor = [UIColor blackColor];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:SpaceButton, doneButton, nil]];
    tv.inputAccessoryView = keyboardDoneButtonView;
}


/**
 *  添加确定按钮到keyboad
 *
 *  @param superController keyboard所在controller
 *  @param search              keyboard所在控件
 */
+ (void)addConfirmToKeyborad : (UIViewController *)superController searchBar:(UISearchBar *)search {
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    //    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.backgroundColor = [UIColor colorWithHexString:@"d1d5db"];
    
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    // toolbar上的2个按钮
    UIBarButtonItem *SpaceButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil  action:nil]; // 让完成按钮显示在右侧
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_bar_close", nil)
                                                                   style:UIBarButtonItemStyleBordered target:superController
                                                                  action:@selector(closeKeyboard)];
    doneButton.tintColor = [UIColor blackColor];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:SpaceButton, doneButton, nil]];
    search.inputAccessoryView = keyboardDoneButtonView;
}

/**
 *  view 转 image
 *
 *  @param v v description
 *
 *  @return <#return value description#>
 */
+ (UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    //    UIGraphicsBeginImageContext(s);
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 *  NSDictionary/NSArray to JSon
 *
 *  @param object NSDictionary Data
 *
 *  @return JSon String
 */
+ (NSString*)DataTOjsonString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


/**
 *  JSon to NSDictionary/NSArray
 *
 *  @param jsonData
 *
 *  @return NSDictionary/NSArray
 */
+ (id)StringtoArrayOrNSDictionary:(NSString *)strJson {
    if (!strJson || strJson == nil) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData =[strJson dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}


/**
 *  检测是否有Conf文件
 *
 *  @return return value description
 */
+ (NSString *)chacheConfigDir {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    
    
    NSString *chacheDir=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Resource"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:chacheDir]) {
        [fileManager createDirectoryAtPath:chacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return chacheDir;
}


/**
 *  控件添加点击事件
 *
 *  @param view     所在控件
 *  @param selector 事件
 */
+ (void)addTapGesture:(UIView *)view controller:(UIViewController *)controller selector:(SEL)selector {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:controller action:selector];
    [view addGestureRecognizer:tapGesture];
}



/**
 *  控件添加点击事件
 *
 *  @param view     操作控件
 *  @param operView 父控件
 *  @param selector 事件
 */
+ (void)addTapGesture:(UIView *)view operView:(UIView *)operView selector:(SEL)selector {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:operView action:selector];
    [view addGestureRecognizer:tapGesture];
}


/**
 *  控件添加滑动事件
 *
 *  @param view     操作控件
 *  @param operView 父控件
 *  @param selector 事件
 */
+ (void)addSwipeGesture:(UIView *)view operView:(UIView *)operView selector:(SEL)selector {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:operView action:selector];
    [view addGestureRecognizer:swipeGesture];
}

/**
 *  根据正则表达式获取相应内容的range
 *
 *  @param strMessage       显示内容
 *  @param regexFormat      正则表达式
 *
 *  @return range
 */
+ (NSRange)getMessageRangeByRegex:(NSString *)strMessage regex:(NSString *)regexFormat {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexFormat options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *matchRange = [regex firstMatchInString:strMessage options:0 range:NSMakeRange(0, strMessage.length)];
    
    return matchRange.range;
}



+ (NSArray *)getArrayByRegex:(NSString *)strMessage regex:(NSString *)regexFormat {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexFormat options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *arrRegex = [regex matchesInString:strMessage options:0 range:NSMakeRange(0, strMessage.length)];
    
    NSMutableArray *arrResule = [NSMutableArray array];
    for (NSTextCheckingResult* match in arrRegex)
    {
        NSRange range = match.range;
        NSString  *temp = [strMessage substringWithRange:range];
        [arrResule addObject:temp];
    }
    return  [arrResule copy];
}


/**
 *  裁剪图片
 *
 */
+ (UIImage *)reSizeImage:(UIImage *)image {
    
    if (image.size.width >= 1000 || image.size.height >= 1000) {
        //        @autoreleasepool {
        
        CGFloat iWidth = 0;
        CGFloat iHeihgt = 0;
        if (image.size.width > image.size.height) {
            iWidth = 1000;
            iHeihgt = iWidth * image.size.height / image.size.width;
        }
        else {
            iHeihgt = 1000;
            iWidth = iHeihgt * image.size.width / image.size.height;
        }
        
//        UIGraphicsBeginImageContext(CGSizeMake(image.size.width/3, image.size.height/3));
//        [image drawInRect:CGRectMake(0, 0, image.size.width/3, image.size.height/3)];
        UIGraphicsBeginImageContext(CGSizeMake(iWidth, iHeihgt));
        [image drawInRect:CGRectMake(0, 0, iWidth, iHeihgt)];
        UIImage *reSizeImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
        //        }
    }
    else {
        return image;
    }
}


/**
 *  获取提示框关闭时间
 *
 *  @param strMsg 提示信息
 *
 *  @return 时间
 */
+ (CGFloat)getWaitingCloseTime:(NSString *)strMsg {
    return MIN((float)strMsg.length*0.06 + 1, 5.0);
}


/**
 *  画线
 *
 *  @param frame frame
 *
 *  @return 线
 */
+ (UIView *)addLineView:(CGRect)frame {
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    return lineView;
}


+ (UILabel *)addLabel:(CGRect)frame font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment string:(NSString *)string{
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
    lbl.font = font;
    lbl.textAlignment = textAlignment;
    lbl.text = string;
    return lbl;
}

+ (UIView *)addView:(CGRect)frame bgColor:(UIColor *)bgColor alpha:(CGFloat)alpha {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    if (bgColor) {
        view.backgroundColor = bgColor;
    }
    
    if (alpha > 0) {
        view.alpha = alpha;
    }    
    return view;
}


/**
 *  当没有更多数据时，设置 UITableView 底部
 **/
+ (UIView *)addEndFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, footerView.height - 1 / 2, footerView.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    [footerView addSubview:lineView];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((footerView.width - 57) / 2, 0, 57, 44)];
    img.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    img.image = [UIImage imageNamed:@"end_onion.png"];
    [footerView addSubview:img];
    
    return footerView;
}


/**
 *  检查是否中文
 **/
+ (BOOL)checkChinese:(NSString *)str {
    NSLog(@"str:%@",str);
    
    const char *cString = [str UTF8String];
    if (strlen(cString) == 3){
        return YES;
    }
    else {
        return NO;
    }
}


static NSDateFormatter* s_dateFormatter = nil;
+ (NSDateFormatter *)sharedDateFormatter
{
    if (s_dateFormatter == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            s_dateFormatter = [[NSDateFormatter alloc] init];
        });
    }
    return s_dateFormatter;
}

/**
 *  转换 url 属性
 **/
+ (NSDictionary *)urlPorpertyConvertToDic:(NSString *)url  {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSArray *arrTmp = [url componentsSeparatedByString:@"?"];
    if (arrTmp.count > 1) {
        NSString *strProperty = arrTmp[1];
        
        arrTmp = [strProperty componentsSeparatedByString:@"&"];
        NSArray *arrProperty;
        
        for (int i = 0; i < arrTmp.count; i++) {
            arrProperty = [arrTmp[i] componentsSeparatedByString:@"="];
            [dic setObject:arrProperty[1] forKey:arrProperty[0]];
        }
    }
    
    return [dic copy];
}

/**
 *  复制到剪贴板
 **/
+ (void)addToClipboard:(NSString *)strInfo {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = strInfo;
}



@end
