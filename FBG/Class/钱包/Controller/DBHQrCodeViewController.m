//
//  DBHQrCodeViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHQrCodeViewController.h"

#import "DBHWalletManagerForNeoDataModels.h"

@interface DBHQrCodeViewController ()

@property (nonatomic, strong) UIImageView *backGroundImageView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation DBHQrCodeViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Wallet QR Code", nil);
    
    [self setUI];
    [self createQrCodeImage];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : COLORFROM16(0xFFFFFF, 1)}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : COLORFROM16(0xFFFFFF, 1)}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : COLORFROM16(0x333333, 1)}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:[UIColor whiteColor] Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"分享-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToShareBarButtonItem)];
    
    [self.view addSubview:self.backGroundImageView];
    [self.view addSubview:self.boxView];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.qrCodeImageView];
    [self.view addSubview:self.addressLabel];
    
    WEAKSELF
    [self.backGroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(40));
        make.height.equalTo(weakSelf.boxView.mas_width).offset(AUTOLAYOUTSIZE(60));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(104) + STATUS_HEIGHT + 44);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(70));
        make.centerX.equalTo(weakSelf.boxView);
        make.centerY.equalTo(weakSelf.boxView.mas_top);
    }];
    [self.qrCodeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(weakSelf.boxView.mas_width).offset(- AUTOLAYOUTSIZE(54));
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(50));
    }];
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.qrCodeImageView.mas_bottom);
        make.bottom.equalTo(weakSelf.boxView);
    }];
}

#pragma mark ------ Event Responds ------
/**
 分享
 */
- (void)respondsToShareBarButtonItem {
    NSArray* activityItems = [[NSArray alloc] initWithObjects:self.walletModel.address, nil];
    
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
/**
 长按地址复制
 */
- (void)respondsToAddressLabel {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.walletModel.address;
    [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Copy success, you can send it to friends", nil)];
}

#pragma mark ------ Private Methods ------
- (void)createQrCodeImage
{
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3. 给过滤器添加数据
    
    NSData *data = [self.walletModel.address dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5. 显示二维码
    self.qrCodeImageView.image = [self creatNonInterpolatedUIImageFormCIImage:outputImage withSize:SCREENWIDTH - AUTOLAYOUTSIZE(182)];
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

#pragma mark ------ Getters And Setters ------
- (void)setWalletModel:(DBHWalletManagerForNeoModelList *)walletModel {
    _walletModel = walletModel;
    
    self.backGroundImageView.image = [UIImage imageNamed:_walletModel.category.categoryIdentifier == 1 ? @"Rectangle 4" : @"Rectangle 2"];
    self.iconImageView.image = [UIImage imageNamed:_walletModel.category.categoryIdentifier == 1 ? @"qianbaoxiangqing_yuan" : @"Group 21"];
}

- (UIImageView *)backGroundImageView {
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc] init];
    }
    return _backGroundImageView;
}
- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = [UIColor whiteColor];
    }
    return _boxView;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UIImageView *)qrCodeImageView {
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] init];
    }
    return _qrCodeImageView;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = FONT(13);
        _addressLabel.textColor = COLORFROM16(0x3D3D3D, 1);
        _addressLabel.text = self.walletModel.address;
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAddressLabel)];
        [_addressLabel addGestureRecognizer:longPressGR];
    }
    return _addressLabel;
}

@end
