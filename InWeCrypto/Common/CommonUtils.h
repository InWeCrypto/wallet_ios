//
//  CommonUtils.h
//  InWeCrypto
//
//  Created by 赵旭瑞 on 2018/5/21.
//  Copyright © 2018年 赵旭瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject



+ (BOOL)createDirectorysAtPath:(NSString *)path;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (NSString*)getDirectoryPathByFilePath:(NSString *)filepath;

+ (NSArray *)convertStringToArray:(NSString *)string;

+ (CGSize)getTextSize:(NSString *)text textFont:(UIFont *)font boundingRect:(CGSize)boundingSize lineBreakMode:(NSLineBreakMode)lineBreakMode;
+ (CGSize)getTextSizeWithLineSpace:(NSString *)text textFont:(UIFont *)font boundingRect:(CGSize)boundingSize lineBreakMode:(NSLineBreakMode)lineBreakMode andLinespace:(CGFloat)space;
+ (CGFloat)getTextHeightWithReturn:(NSString *)text textFont:(UIFont *)font boundingRect:(CGSize)boundingSize lineBreakMode:(NSLineBreakMode)lineBreakMode andLinespace:(CGFloat)space;
+ (void)addConfirmToKeyborad : (UIViewController *)superController textField:(UITextField *)tv;
+ (void)addConfirmToKeyborad : (UIViewController *)superController textView:(UITextView *)tv;
+ (void)addConfirmToKeyborad : (UIViewController *)superController searchBar:(UISearchBar *)search;

+ (NSDate *)convertStringToDate:(NSString *)strDate;
+ (NSString *)convertDateToTimestamp:(NSDate *)date;
+ (NSString *) convertTimestampToDate :(NSTimeInterval)Timestamp;
+ (NSString *) convertTimestamp :(NSTimeInterval)Timestamp;
+ (NSString *) convertTimestampToSimpleDate :(NSTimeInterval)Timestamp;
+ (NSDateComponents *)calcuSendTime:(NSTimeInterval)estimateTimeStamp serverTime:(NSTimeInterval)serverTimeStamp;

+ (UIImage*)convertViewToImage:(UIView*)v;
+ (void)switchView:(UIView *)baseView view1:(UIView *)view1 toView:(UIView *)view2 direction:(NSString *)direction;
+ (NSString*)DataTOjsonString:(id)object;
+ (id)StringtoArrayOrNSDictionary:(NSString *)strJson;

//+ (CGRect)calcuBottomButtonoOriginY:(CGRect)buttonFrame
//                 initialButtonFrame:(CGRect)initialButtonFrame
//            scrollviewContentOffset:(CGFloat)scrollviewContentOffset;
+ (CGRect)calcuBottomButtonoOriginY:(CGRect)buttonFrame
                 initialButtonFrame:(CGRect)initialButtonFrame
              superViewFrameOriginY:(CGFloat)superViewFrameOriginY
        scrollViewRealContentHeight:(CGFloat)scrollViewRealContentHeight
                   movingScrollView:(UIScrollView *)scrollview;
+ (NSString *)chacheConfigDir;
+ (void)addTapGesture:(UIView *)view controller:(UIViewController *)controller selector:(SEL)selector;
+ (void)addTapGesture:(UIView *)view operView:(UIView *)operView selector:(SEL)selector;
+ (void)addSwipeGesture:(UIView *)view operView:(UIView *)operView selector:(SEL)selector;
+ (NSRange)getMessageRangeByRegex:(NSString *)strMessage regex:(NSString *)regexFormat;
+ (NSArray *)getArrayByRegex:(NSString *)strMessage regex:(NSString *)regexFormat;
+ (UIImage *)reSizeImage:(UIImage *)image;
+ (CGFloat)getWaitingCloseTime:(NSString *)strMsg;
+ (UIView *)addLineView:(CGRect)frame;
+ (UILabel *)addLabel:(CGRect)frame font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment string:(NSString *)string;
+ (UIView *)addView:(CGRect)frame bgColor:(UIColor *)bgColor alpha:(CGFloat)alpha;
+ (UIView *)addEndFooterView;
+ (BOOL)checkChinese:(NSString *)str;

+ (NSDictionary *)urlPorpertyConvertToDic:(NSString *)url;
+ (void)addToClipboard:(NSString *)strInfo;

@end
