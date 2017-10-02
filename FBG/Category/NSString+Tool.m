//
//  NSString+Tool.m
//  Tool
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import "NSString+Tool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>
#import "NSDecimalNumber+Addtion.h"

@implementation NSString (Tool)

//当前时间
+ (NSString *)nowDate
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

//明天
+ (NSString *)nextDate
{
    NSDate * date = [NSDate date];//当前时间
    // NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:nextDay];
    return dateString;
}


//时间格式转换
/*
 G:         公元时代，例如AD公元
 yy:     年的后2位
 yyyy:     完整年
 MM:     月，显示为1-12,带前置0
 MMM:     月，显示为英文月份简写,如 Jan
 MMMM:     月，显示为英文月份全称，如 Janualy
 dd:     日，2位数表示，如02
 d:         日，1-2位显示，如2，无前置0
 EEE:     简写星期几，如Sun
 EEEE:     全写星期几，如Sunday
 aa:     上下午，AM/PM
 H:         时，24小时制，0-23
 HH:     时，24小时制，带前置0
 h:         时，12小时制，无前置0
 hh:     时，12小时制，带前置0
 m:         分，1-2位
 mm:     分，2位，带前置0
 s:         秒，1-2位
 ss:     秒，2位，带前置0
 S:         毫秒
 Z：        GMT（时区）
 
yy-MM-dd HH:mm:ss
 */
+ (NSString *)timeExchangeWithType:(NSString *)type timeString:(NSString *)timeString
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:type];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]]];
    return currentDateStr;
}

//md5加密
- (NSString *)md5WithString
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [NSString stringWithString:outputString];
}

//手机号码验证
+ (BOOL)isMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat: @"SELF MATCHES %@",phoneRegex];
    BOOL isMatch = [phoneTest evaluateWithObject:mobile];
    return isMatch;
}

//邮箱
+ (BOOL)isEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", emailRegex];
    BOOL isMatch = [emailTest evaluateWithObject:email];
    return isMatch;
}

//验证码
+ (BOOL)isEmployeeNumber:(NSString *)number
{
    NSString *pattern = @"^[0-9]{6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

//金额
+ (BOOL)isMoneyNumber:(NSString *)number
{
    NSString *pattern = @"^[0-9]+(.[0-9]{4})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

//正则匹配用户密码6-20位数字和字母组合
+ (BOOL)isPassword:(NSString *)password
{
    // 同时包含 数字 大、小写字母 特殊字符
//    NSString *pattern =@"^(?:(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])).{10,20}$";
    //简单数字加字符判断
//    NSString *pattern =@"^[a-zA-Z0-9]{6,18}+$";
    NSString *pattern =@"^(?:(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])).{8,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

+ (BOOL)isAdress:(NSString *)adress
{
    if ([NSString isNulllWithObject:adress])
    {
        return NO;
    }
    if (![[adress substringToIndex:2] isEqualToString:@"0x"])
    {
        return NO;
    }
    NSString *regex = @"^[a-zA-Z0-9]{42}+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [predicate evaluateWithObject:adress];
    return isMatch;
}



//正则匹配用户昵称2-12位
+ (BOOL)isNickName:(NSString *)nickName
{
    NSString *pattern =@"^[\\u4e00-\\u9fa5_a-zA-Z0-9-]{2,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:nickName];
    return isMatch;
    
}

// 16进制 转10进制
+ (NSString *)numberHexString:(NSString *)aHexString
{
    JKBigInteger *int1 = [[JKBigInteger alloc] initWithString:aHexString andRadix:16];
    return [int1 stringValue];
}


// 10 进制转换16进制
+ (NSString *)getHexByDecimal:(NSInteger)decimal
{
    JKBigInteger *int1 = [[JKBigInteger alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)decimal]];
    return [int1 stringValueWithRadix:16];
    
    /*
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
     */
}

// data 转 json字符串
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

//data 转16
+ (NSString *)hexStringFromData:(NSData *)myD{
    
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    NSLog(@"hex = %@",hexStr);
    
    return hexStr;
}

+ (NSString *)DecimalFuncWithOperatorType:(NSInteger)operatorType first:(id)first secend:(id)secend value:(int)value
{
    /*
    JKBigDecimal *firstValue = [[JKBigDecimal alloc] initWithString:[NSString stringWithFormat:@"%@",first]];
    JKBigDecimal *secendValue = [[JKBigDecimal alloc] initWithString:[NSString stringWithFormat:@"%@",secend]];
    
    JKBigDecimal *resultNumber = [[JKBigDecimal alloc] initWithString:@"0.0000"];
    switch (operatorType)
    {
        case 0:
            resultNumber = [firstValue add:secendValue];
            break;
        case 1:
            resultNumber = [firstValue subtract:secendValue];
            break;
        case 2:
            resultNumber = [firstValue multiply:secendValue];
            break;
        case 3:
            resultNumber = [firstValue divide:secendValue];
            break;
    }
    
    switch (value) {
        case 2:
        {
            return [NSString stringWithFormat:@"%.2f",[[resultNumber stringValue] floatValue]];
            break;
        }
        case 4:
        {
            return [NSString stringWithFormat:@"%.4f",[[resultNumber stringValue] floatValue]];
            break;
        }
        default:
            return [NSString stringWithFormat:@"%f",[[resultNumber stringValue] floatValue]];
            break;
    }
     */
    
    NSDecimalNumber *resultNumber = [[NSDecimalNumber alloc]initWithString:@"0"];
    switch (operatorType)
    {
        case 0:
            resultNumber = SNAdd_handler(first, secend, NSRoundPlain, value);
            break;
        case 1:
            resultNumber = SNSub_handler(first, secend, NSRoundPlain, value);
            break;
        case 2:
            resultNumber = SNMul_handler(first, secend, NSRoundPlain, value);
            break;
        case 3:
            resultNumber = SNDiv_handler(first, secend, NSRoundPlain, value);
            break;
    }
     
    return [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",resultNumber]];

}

+ (NSComparisonResult)DecimalFuncComparefirst:(NSString *)first secend:(NSString *)secend
{
    NSDecimalNumber * discount1 = [NSDecimalNumber decimalNumberWithString:first];
    NSDecimalNumber * discount2 = [NSDecimalNumber decimalNumberWithString:secend];
    NSComparisonResult result = [discount1 compare:discount2];
    return result;
}

//转换显示单位
+ (NSString *)getDealNumwithstring:(NSString *)string
{
    NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *numberB ;
    if ([string intValue] < 10000)
    {
        numberB =  [NSDecimalNumber decimalNumberWithString:@"1"];
    }
    else if ([string intValue] >= 10000 && [string intValue] < 100000000)
    {
        numberB =  [NSDecimalNumber decimalNumberWithString:@"10000"];
    }
    else
    {
        numberB =  [NSDecimalNumber decimalNumberWithString:@"100000000"];
    }
    //NSDecimalNumberBehaviors对象的创建  参数 1.RoundingMode 一个取舍枚举值 2.scale 处理范围 3.raiseOnExactness  精确出现异常是否抛出原因 4.raiseOnOverflow  上溢出是否抛出原因  4.raiseOnUnderflow  下溢出是否抛出原因  5.raiseOnDivideByZero  除以0是否抛出原因。
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    /// 这里不仅包含Multiply还有加 减 乘。
    NSDecimalNumber *numResult = [numberA decimalNumberByDividingBy:numberB withBehavior:roundingBehavior];
    NSString *strResult = [numResult stringValue];
    
    if ([string intValue] < 10000)
    {
        return strResult;
    }
    else if ([string intValue] >= 10000 && [string intValue] < 100000000)
    {
        return [NSString stringWithFormat:@"%@万",strResult];
    }
    else
    {
        return [NSString stringWithFormat:@"%@亿",strResult];
    }
    
}


@end
