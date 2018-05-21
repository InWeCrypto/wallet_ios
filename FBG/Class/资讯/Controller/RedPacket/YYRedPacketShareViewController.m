//
//  YYRedPacketShareViewController.m
//  FBG
//
//  Created by yy on 2018/4/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketShareViewController.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface YYRedPacketShareViewController ()<WXApiDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIImageView *qrImgView;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *getTokenLabel;

@property (nonatomic, strong) UIImage *sharedImg;

@end

@implementation YYRedPacketShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self createQrCodeImage];
}

#pragma mark ------ Private Methods ------
- (void)createQrCodeImage {
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3. 给过滤器添加数据
    NSString *tempURL = TEST_REDPACKET_CREATE_CODE;
    if ([APP_APIEHEAD isEqualToString:APIEHEAD1]) {
        tempURL = REDPACKET_CREATE_CODE;
    }
    
    NSString *user = [self.model.share_user stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *url = [tempURL stringByAppendingFormat:@"redbag/%@/%@?share_user=%@&lang=%@&target=%@&symbol=%@&inwe", @(self.model.redPacketId), self.model.redbag_addr, user, [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? @"zh" : @"en", @"draw2", self.model.redbag_symbol];
    
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5. 显示二维码
    UIImage *qrImg = [self creatNonInterpolatedUIImageFormCIImage:outputImage];
    self.qrImgView.image = qrImg;
}

- (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image {
    CGFloat size = self.qrImgView.width;
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (UIImage *)imageFromView:(UIView *)theView {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(theView.width, theView.height), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark ------- SetUI ---------
- (void)setUI {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Share", nil) style:UIBarButtonItemStylePlain target:self action:@selector(shareClicked)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
 
    self.senderNameLabel.text = [NSString stringWithFormat:@"%@：", self.model.share_user];
    self.bgImgView.image = [UIImage imageNamed:DBHGetStringWithKeyFromTable(@"redpacket_share_bg_en", nil)];
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"Long press the QR code", nil);
    self.getTokenLabel.text = [DBHGetStringWithKeyFromTable(@"and get ", nil) stringByAppendingString:self.model.redbag_symbol];
    
    NSString *msg = self.model.share_msg;
    if (msg.length > 0) {
        self.messgeLabel.superview.hidden = NO;
        self.messgeLabel.text = self.model.share_msg;
    } else {
        self.messgeLabel.superview.hidden = YES;
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)setNavigationTintColor {
    self.navigationController.navigationBar.tintColor = COLORFROM16(0x000000, 1);
}

#pragma mark - respondsToSelector
- (void)cancelClicked {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareClicked {
    self.sharedImg = [self imageFromView:self.view];
    if (self.index == 0) { // 朋友圈
        BOOL result = [WXApi sendReq:[self shareToWX:0]];
        NSLog(@"result = %d", result);
    } else if (self.index == 1) { // 微信
        BOOL result = [WXApi sendReq:[self shareToWX:1]];
        NSLog(@"result = %d", result);
    } else if (self.index == 2) { //QQ
        [self shareToQQ];
    } else { // 截图
        
    }
}

 - (void)shareToQQ {
    WEAKSELF
    [[AppDelegate delegate] setQqResultBlock:^(QQBaseResp *res) {
            if ([res isKindOfClass:[SendMessageToQQResp class]]) {
                if (res.type == ESENDMESSAGETOQQRESPTYPE) { // 手Q->第三方
                        if ([res.result intValue] == 0) { // 没有错误
                            [weakSelf shareSuccess:YES];
                        } else {
                            if (res.result.intValue == -4) { // 取消分享
                                [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Cancel share", nil)];
                            } else {
                                [weakSelf shareSuccess:NO];
                               }
                        }
                }
        }
    }];
     
     NSData *imgData = UIImagePNGRepresentation(self.sharedImg);
     CGSize imgSize = self.sharedImg.size;
     UIImage *img = [UIImage imageWithImage:self.sharedImg scaledToSize:CGSizeMake(imgSize.width, imgSize.height / 8)];
     NSData *previewImageData = UIImagePNGRepresentation(img);
     QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData previewImageData:previewImageData title:@"" description:@""];
     
     SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
     QQApiSendResultCode send = [QQApiInterface sendReq:req];
     [self handleSendResult:send];
 }


/**
 发送消息到微信
 
 @param index 0-朋友圈  1-好友
 @return 消息
 */
 - (SendMessageToWXReq *)shareToWX:(NSInteger)index {
    WEAKSELF
    [[AppDelegate delegate] setResultBlock:^(BaseResp *res) {
        if ([res isKindOfClass:[SendMessageToWXResp class]]) {
            if (res.errCode == 0) { // 没有错误
                [weakSelf shareSuccess:YES];
            } else {
                if (res.errCode == -2) {
                    // cancel
                    [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Cancel share", nil)];
                } else {
                    [weakSelf shareSuccess:NO];
                }
            }
        }
    }];
 
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;           // 指定为发送文本
 
    WXImageObject *obj = [[WXImageObject alloc] init];
 
    NSData *imageData = UIImagePNGRepresentation(self.sharedImg);
    obj.imageData = imageData;
    req.message = [[WXMediaMessage alloc] init];
 
    req.message.mediaObject = obj;
 
    if (index == 0) {
        req.scene = WXSceneTimeline;
    } else {
        req.scene =  WXSceneSession;
    }
    return req;
}

- (void)shareSuccess:(BOOL)isSuccess {
    if (isSuccess) {
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Share successfully", nil)];
    } else {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Share failed", nil)];
    }
}

- (void)handleSendResult:(QQApiSendResultCode)code {
    switch (code) {
        case EQQAPIAPPNOTREGISTED: // 未注册
            NSLog(@"未注册");
            break;
        case EQQAPIQQNOTINSTALLED:
            [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Please install QQ mobile", nil)]; // todo
            break;
        case EQQAPISENDFAILD:
            [self shareSuccess:NO];
            break;
        default:
            break;
    }
}

@end
