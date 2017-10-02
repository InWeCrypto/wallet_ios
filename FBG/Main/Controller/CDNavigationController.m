//
//  CDNavigationController.m
//  i-chengdu
//
//  Created by mac on 16/12/30.
//  Copyright © 2016年 lykj. All rights reserved.
//

#import "CDNavigationController.h"

@interface CDNavigationController ()<UINavigationControllerDelegate>

@end

@implementation CDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    //设置导航栏背景颜色
    UINavigationBar *bar = self.navigationBar;
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationBar setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"2f2f2f"]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
}

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
        [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backButton sizeToFit];
        // 注意:一定要在按钮内容有尺寸的时候,设置才有效果
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        // 设置返回按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return [super pushViewController:viewController animated:animated];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}
@end
