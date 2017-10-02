//
//  ReceivablesVC.m
//  FBG
//
//  Created by mac on 2017/7/19.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "ReceivablesVC.h"
#import "ConfirmationReceivableVC.h"
#import "PayPriceView.h"
#import <CoreImage/CoreImage.h>
#import <Social/Social.h>

@interface ReceivablesVC () <PayPriceViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIImageView *addressImage;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;

@property (nonatomic, strong) PayPriceView * alertView;

@end

@implementation ReceivablesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Receivables", nil);
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_share"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.headImage sdsetImageWithHeaderimg:[UserSignData share].user.img];
    [self.sureButton setTitle:NSLocalizedString(@"Copy collection address", nil) forState:UIControlStateNormal];
    self.addressLB.text = self.tokenModel ? self.tokenModel.address : self.model.address;
    [self creatCIQRCodeImage];
}

- (void)rightButton
{
    //分享
    NSArray* activityItems = [[NSArray alloc] initWithObjects:self.model.address,nil];
    
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

- (IBAction)copyAddressButtonCilick:(id)sender
{
    //复制地址
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.tokenModel ? self.tokenModel.address : self.model.address;
    [LCProgressHUD showMessage:@"复制成功"];
    //模拟收款确认
//    ConfirmationReceivableVC * vc = [[ConfirmationReceivableVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)editButtonCilick:(id)sender
{
    //编辑金额
    [self.alertView showWithView:self.view];
}

- (void)sureButtonCilickWithPrice:(NSString *)price remark:(NSString *)remark
{
    [self.editButton setTitle:price forState:UIControlStateNormal];
}

- (PayPriceView *)alertView
{
    if (!_alertView)
    {
        _alertView = [[PayPriceView alloc] initWithFrame:[AppDelegate delegate].window.bounds];
        _alertView.delegate = self;
    }
    return _alertView;
}

- (void)creatCIQRCodeImage
{
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3. 给过滤器添加数据
    
    NSString *dataString = self.tokenModel ? self.tokenModel.address : self.model.address;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5. 显示二维码
    self.addressImage.image = [self creatNonInterpolatedUIImageFormCIImage:outputImage withSize:300];
}

- (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
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

@end
