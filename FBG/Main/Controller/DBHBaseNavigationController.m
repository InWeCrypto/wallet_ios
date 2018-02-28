//
//  DBHBaseNavigationController.m
//  Trinity
//
//  Created by 邓毕华 on 2017/12/25.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHBaseNavigationController.h"

#import "DBHBaseViewController.h"

@interface DBHBaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation DBHBaseNavigationController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    //设置导航栏背景颜色
    UINavigationBar *bar = self.navigationBar;
    bar.tintColor = COLORFROM16(0x333333, 1);
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : COLORFROM16(0x333333, 1), NSFontAttributeName:FONT(20)}];
    [self.navigationBar setBackgroundImage:[UIImage getImageFromColor:[UIColor whiteColor] Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:FONT(14)} forState:UIControlStateNormal];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark ------ UINavigationControllerDelegate ------
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 删除系统自带的tabBarButton
    for (UIView *tabBar in self.tabBarController.tabBar.subviews)
    {
        if ([tabBar isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            [tabBar removeFromSuperview];
        }
    }
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        // 非根控制器才需要设置返回按钮
        // 设置返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *backImageName;
        if ([viewController isKindOfClass:NSClassFromString(@"DBHImportWalletViewController")] || [viewController isKindOfClass:NSClassFromString(@"DBHAddWalletViewController")]) {
            backImageName = @"关闭-3";
        } else if ([viewController isKindOfClass:NSClassFromString(@"DBHWalletDetailViewController")] || [viewController isKindOfClass:NSClassFromString(@"DBHWalletDetailWithETHViewController")] || [viewController isKindOfClass:NSClassFromString(@"DBHQrCodeViewController")] || [viewController isKindOfClass:NSClassFromString(@"DBHPaymentReceivedViewController")]) {
            backImageName = @"关闭-4";
        } else if ([viewController isKindOfClass:NSClassFromString(@"DBHTokenSwapViewController")]) {
            backImageName = @"whiteBack";
        } else {
            backImageName = @"返回-3";
        }
        [backButton setImage:[[UIImage imageNamed:backImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backButton sizeToFit];
        // 注意:一定要在按钮内容有尺寸的时候,设置才有效果
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        // 设置返回按钮
        
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        UIBarButtonItem *otherBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   " style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        
        if ([viewController isKindOfClass:NSClassFromString(@"DBHPersonalCenterViewController")]) {
            [viewController.navigationItem setHidesBackButton:YES];
            viewController.navigationItem.rightBarButtonItem = backBarButtonItem;
        } else if ([viewController isKindOfClass:NSClassFromString(@"DBHSelectFaceOrTouchViewController")] || [viewController isKindOfClass:NSClassFromString(@"DBHCheckFaceOrTouchViewController")] || [viewController isKindOfClass:NSClassFromString(@"DBHSearchViewController")]) {
            [viewController.navigationItem setHidesBackButton:YES];
        } else {
            viewController.navigationItem.leftBarButtonItems = @[backBarButtonItem, otherBarButtonItem];
        }
    }
    return [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if ([self.viewControllers.lastObject isKindOfClass:[DBHBaseViewController class]]) {
        DBHBaseViewController *currentVC = self.viewControllers.lastObject;
        if (!currentVC.backIndex) {
            return [super popViewControllerAnimated:animated];
        } else {
            return [self popToViewController:self.viewControllers[currentVC.backIndex - 1] animated:YES].lastObject;
        }
    }
    return [super popViewControllerAnimated:animated];
}

#pragma mark ------ Private Methods ------
- (void)back {
    if ([self.viewControllers.lastObject isKindOfClass:[DBHBaseViewController class]]) {
        DBHBaseViewController *currentVC = self.viewControllers.lastObject;
        if (currentVC.backIndex && currentVC.backIndex < self.viewControllers.count) {
            [self popToViewController:self.viewControllers[currentVC.backIndex - 1] animated:YES];
            
            return;
        }
    }
    [self popViewControllerAnimated:YES];
}

@end
