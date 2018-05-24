//
//  BaseViewController.m
//  InWeCrypto
//
//  Created by 赵旭瑞 on 2018/5/21.
//  Copyright © 2018年 赵旭瑞. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUNDCOLOR;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarTitleColor];
    [self setNavigationTintColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)setNavigationTintColor {
    self.navigationController.navigationBar.tintColor = COLORFROM16(0x333333, 1);
}

- (void)redPacketNavigationBar {
    NSArray *colors = @[COLORFROM16(0xD9725B, 1), COLORFROM16(0xB23E2E, 1)];
    UIImage *image = [UIImage imageWithGradients:colors];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLORFROM16(0x333333, 1), NSFontAttributeName:FONT(18)}];
}

- (void)dealloc {
    NSLog(@"💣💣💣dealloc----   %@ 💣💣💣", [self class]);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([NSStringFromClass([self class]) isEqualToString:@"DBHInformationViewController"] ||
        [NSStringFromClass([self class]) isEqualToString:@"DBHHomePageViewController"] ||
        [NSStringFromClass([self class]) isEqualToString:@"DBHWalletPageViewController"] ||
        [NSStringFromClass([self class]) isEqualToString:@"DBHMyViewController"] ||
        [NSStringFromClass([self class]) isEqualToString:@"DBHWalletDetailViewController"] ||
        [NSStringFromClass([self class]) isEqualToString:@"DBHWalletDetailWithETHViewController"] ||
        [NSStringFromClass([self class]) isEqualToString:@"AddWalletSucessVC"] ||
        [NSStringFromClass([self class]) isEqualToString:@"YYRedPacketPackagingViewController"] ||
        [NSStringFromClass([self class]) isEqualToString:@"YYRedPacketSendSecondViewController"]) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    } else {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO; //YYTODO
        }
    }
}


/**
 *  navigationBar 增加 图片 按钮 (left / right)
 *
 *  @param imageName    图片名称
 *  @param target       所有 controller
 *  @param sel          执行方法
 *  @param direction    在navigationBar的位置, left or right
 *  @param isWithNotice 是否有新通知提示
 */
- (void)setupItemWithImage:(NSString *)imageName target:(UIViewController *)target action:(SEL)sel direction:(NavBarDirection) direction isWithNotice:(BOOL)isWithNotice {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 28, 28);
    if (isWithNotice) {
        UIImageView *imgNotice = [[UIImageView alloc]initWithFrame:CGRectMake(33, 5, 8, 8)];
        imgNotice.backgroundColor = [UIColor redColor];
        imgNotice.layer.cornerRadius = 4;
        
        
        UIView *normalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 51, 44)];
        UIImageView *imgNormal = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 51, 44)];
        imgNormal.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_n.png",imageName]];
        [normalView addSubview:imgNormal];
        [normalView addSubview:imgNotice];
        [btn setBackgroundImage:[CommonUtils convertViewToImage:normalView] forState:UIControlStateNormal];
        
        
        UIView *heightlightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 51, 44)];
        UIImageView *imgHeightLight = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 51, 44)];
        imgHeightLight.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_h.png",imageName]];
        [heightlightView addSubview:imgHeightLight];
        [heightlightView addSubview:imgNotice];
        [btn setBackgroundImage:[CommonUtils convertViewToImage:heightlightView] forState:UIControlStateNormal];
    }
    else {
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_n.png",imageName]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_h.png",imageName]] forState:UIControlStateHighlighted];
    }
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    if (direction == NavBarDirectionLeft ) {
        self.navigationItem.leftBarButtonItems = @[negativeSpacer,item];
    }
    else {
        self.navigationItem.rightBarButtonItems = @[negativeSpacer,item];
    }
}

- (void)setupItemWithImage:(NSString *)imageName imageSize:(CGSize)imamgeSize target:(UIViewController *)target action:(SEL)sel direction:(NavBarDirection) direction {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    
    
    UIView *normalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imgNormal = [[UIImageView alloc]initWithFrame:CGRectMake(0, (44 - imamgeSize.height)/2, imamgeSize.width, imamgeSize.height)];
    if (direction == NavBarDirectionRight) {
        imgNormal.frame = CGRectMake(44 - imamgeSize.width, (44 - imamgeSize.height)/2, imamgeSize.width, imamgeSize.height);
    }
    imgNormal.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_n.png",imageName]];
    [normalView addSubview:imgNormal];
    [btn setBackgroundImage:[CommonUtils convertViewToImage:normalView] forState:UIControlStateNormal];
    
    
    
    UIView *heightlightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imgHeightLight = [[UIImageView alloc]initWithFrame:CGRectMake(0, (44 - imamgeSize.height)/2, imamgeSize.width, imamgeSize.height)];
    if (direction == NavBarDirectionRight) {
        imgHeightLight.frame = CGRectMake(44 - imamgeSize.width, (44 - imamgeSize.height)/2, imamgeSize.width, imamgeSize.height);
    }
    imgHeightLight.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_h.png",imageName]];
    [heightlightView addSubview:imgHeightLight];
    [btn setBackgroundImage:[CommonUtils convertViewToImage:heightlightView] forState:UIControlStateHighlighted];
    
    
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    if (direction == NavBarDirectionLeft ) {
        self.navigationItem.leftBarButtonItems = @[negativeSpacer,item];
    }
    else {
        self.navigationItem.rightBarButtonItems = @[negativeSpacer,item];
    }
}




@end
