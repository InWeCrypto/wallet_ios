//
//  DBHPaymentReceivedViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHPaymentReceivedViewController.h"

#import "PPNetworkCache.h"

#import "DBHSelectWalletViewController.h"

#import "DBHWalletManagerForNeoDataModels.h"

@interface DBHPaymentReceivedViewController ()

@property (nonatomic, strong) UIImageView *backGroundImageView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *moreImageView;
@property (nonatomic, strong) UIButton *walletButton;

@property (nonatomic, assign) NSInteger currentSelectedRow; // 当前选中行数
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHPaymentReceivedViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Payment Received", nil);
    
    [self setUI];
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
    
    [self getWalletList];
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
    [self.view addSubview:self.qrCodeImageView];
    [self.view addSubview:self.grayLineView];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.moreImageView];
    [self.view addSubview:self.walletButton];
    
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
    [self.qrCodeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(weakSelf.boxView.mas_width).offset(- AUTOLAYOUTSIZE(54));
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(50));
    }];
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.boxView);
        make.bottom.equalTo(weakSelf.walletButton.mas_top);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(21.5));
        make.left.equalTo(weakSelf.walletButton).offset(AUTOLAYOUTSIZE(15));
        make.top.equalTo(weakSelf.walletButton).offset(AUTOLAYOUTSIZE(10.5));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(7));
        make.right.equalTo(weakSelf.moreImageView.mas_left).offset(- AUTOLAYOUTSIZE(10));
        make.top.equalTo(weakSelf.walletButton).offset(AUTOLAYOUTSIZE(7));
    }];
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.nameLabel);
        make.left.equalTo(weakSelf.nameLabel);
        make.bottom.equalTo(weakSelf.walletButton).offset(- AUTOLAYOUTSIZE(7.5));
    }];
    [self.moreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(5));
        make.height.offset(AUTOLAYOUTSIZE(9.5));
        make.right.equalTo(weakSelf.walletButton).offset(- AUTOLAYOUTSIZE(16.5));
        make.centerY.equalTo(weakSelf.walletButton);
    }];
    [self.walletButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.height.offset(AUTOLAYOUTSIZE(50));
        make.centerX.equalTo(weakSelf.boxView);
        make.bottom.equalTo(weakSelf.boxView);
    }];
}

#pragma mark ------ Data ------
/**
 获取钱包列表
 */
- (void)getWalletList {
    WEAKSELF
    [PPNetworkHelper GET:@"wallet" baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
        [weakSelf.dataSource removeAllObjects];
        for (NSDictionary *dic in responseCache[@"list"]) {
            DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList modelObjectWithDictionary:dic];
            
            if (model.categoryId != 2) {
                continue;
            }
            
            model.isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:model.address]];
            model.isBackUpMnemonnic = [[UserSignData share].user.walletIdsArray containsObject:@(model.listIdentifier)];
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf refreshData];
    } success:^(id responseObject) {
        [weakSelf.dataSource removeAllObjects];
        for (NSDictionary *dic in responseObject[@"list"]) {
            DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList modelObjectWithDictionary:dic];
            
            if (model.categoryId != 2) {
                continue;
            }
            
            model.isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:model.address]];
            model.isBackUpMnemonnic = [[UserSignData share].user.walletIdsArray containsObject:@(model.listIdentifier)];
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf refreshData];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure: error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 分享
 */
- (void)respondsToShareBarButtonItem {
    if (!self.dataSource.count) {
        return;
    }
    
    DBHWalletManagerForNeoModelList *model = self.dataSource.firstObject;
    
    NSArray* activityItems = [[NSArray alloc] initWithObjects:model.address, nil];
    
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
 更换钱包
 */
- (void)respondsToWalletButton {
    DBHSelectWalletViewController *selectWalletViewController = [[DBHSelectWalletViewController alloc] init];
    selectWalletViewController.currentSelectedRow = self.currentSelectedRow;
    
    WEAKSELF
    [selectWalletViewController selectdWalletBlock:^(NSInteger selectdRow) {
        // 选择钱包回调
        weakSelf.currentSelectedRow = selectdRow;
        [weakSelf refreshData];
    }];
    
    [self.navigationController pushViewController:selectWalletViewController animated:YES];
}

#pragma mark ------ Private Methods ------
/**
 刷新数据
 */
- (void)refreshData {
    if (!self.dataSource.count) {
        return;
    }
    
    DBHWalletManagerForNeoModelList *model = self.dataSource[self.currentSelectedRow];
    self.nameLabel.text = model.name;
    self.addressLabel.text = model.address;
    [self createQrCodeImage];
}
- (void)createQrCodeImage {
    DBHWalletManagerForNeoModelList *model = self.dataSource.firstObject;
    
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3. 给过滤器添加数据
    
    NSData *data = [model.address dataUsingEncoding:NSUTF8StringEncoding];
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
- (UIImageView *)backGroundImageView {
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle 3"]];
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
- (UIImageView *)qrCodeImageView {
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] init];
    }
    return _qrCodeImageView;
}
- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xEEEEEE, 1);
    }
    return _grayLineView;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"卡片logo"]];
    }
    return _iconImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(13);
        _nameLabel.textColor = COLORFROM16(0x3D3D3D, 1);
    }
    return _nameLabel;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = FONT(12);
        _addressLabel.textColor = COLORFROM16(0xB2B1B1, 1);
    }
    return _addressLabel;
}
- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fanhui"]];
    }
    return _moreImageView;
}
- (UIButton *)walletButton {
    if (!_walletButton) {
        _walletButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_walletButton addTarget:self action:@selector(respondsToWalletButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _walletButton;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
