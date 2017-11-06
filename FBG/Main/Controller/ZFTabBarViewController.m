//
//  ZFTabBarViewController.m
//  ZFTabBar
//
//  Created by 任子丰 on 15/9/10.
//  Copyright (c) 2014年 任子丰. All rights reserved.
//

#import "ZFTabBarViewController.h"
#import "ZFTabBar.h"
#import "FindVC.h"
#import "CDNavigationController.h"
#import "WalletHomeVC.h"
#import "MyTVC.h"
#import "QuotationVC.h"

@interface ZFTabBarViewController () <ZFTabBarDelegate>
/**
 *  自定义的tabbar
 */
@property (nonatomic, weak) ZFTabBar *customTabBar;
@end

@implementation ZFTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    ZFTabBar *customTabBar = [[ZFTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(ZFTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    if ([UserSignData share].user.isCode && to != 0)
    {
        //冷钱包进入
        [LCProgressHUD showMessage:@"冷钱包"];
    }
    else
    {
        //热钱包
        self.selectedIndex = to;
    }
    
}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
    // 1.钱包
    WalletHomeVC *home = [[WalletHomeVC alloc] init];
    home.tabBarItem.badgeValue = @"";
    [self setupChildViewController:home title:@"我的资产" imageName:@"tab_qianbao_nor" selectedImageName:@"tab_qianbao_pre"];
    
    // 2.行情
    QuotationVC * quotation = [[QuotationVC alloc] init];
    quotation.tabBarItem.badgeValue = @"";
    [self setupChildViewController:quotation title:NSLocalizedString(@"Quotation", nil) imageName:@"tab_hangqing_nor" selectedImageName:@"tab_hangqing_pre"];
    
    // 3.发现
    FindVC *home1 = [[FindVC alloc] init];
    home1.tabBarItem.badgeValue = @"";
    [self setupChildViewController:home1 title:NSLocalizedString(@"Find", nil) imageName:@"tab_faxian_nor" selectedImageName:@"tab_faxian_pre"];
    
    // 4.我的
    MyTVC * my = [[UIStoryboard storyboardWithName:@"MyTVC" bundle:nil] instantiateViewControllerWithIdentifier:@"MyTVC"];
    my.tabBarItem.badgeValue = @"";
    [self setupChildViewController:my title:NSLocalizedString(@"My", nil) imageName:@"tab_wode_nor" selectedImageName:@"tab_wode_pre"];
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (iOS7) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
    // 2.包装一个导航控制器
    CDNavigationController *nav = [[CDNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

@end
