//
//  ZFTabBarViewController.m
//  ZFTabBar
//
//  Created by 任子丰 on 15/9/10.
//  Copyright (c) 2014年 任子丰. All rights reserved.
//

#import "ZFTabBarViewController.h"

#import "ZFTabBar.h"
#import "DBHBaseNavigationController.h"

#import "InformationViewController.h"
#import "ProjectViewController.h"
#import "RankingViewController.h"

#import "WalletViewController.h"
#import "MyViewController.h"
//#import "DBHCheckVersionModel.h"


@interface ZFTabBarViewController () <ZFTabBarDelegate>

@property (nonatomic, assign) BOOL isReview;

@end

@implementation ZFTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:WHITE_COLOR]];
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
    
    if ([UserSignData share].user.isFirstRegister) {
        [UserSignData share].user.isFirstRegister = NO;
        [[UserSignData share] storageData:[UserSignData share].user];
    }
}

#pragma mark ------ set ui ------

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
- (void)tabBar:(ZFTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to {
    
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
- (void)setupAllChildViewControllers {
    // 1.资讯
    InformationViewController *informationViewController = [[InformationViewController alloc] init];
    informationViewController.tabBarItem.badgeValue = @"";
    [self setupChildViewController:informationViewController title:nil imageName:@"zixun_ico_s" selectedImageName:@"zixun_ico"];
    
    // 2.项目
    ProjectViewController *projectViewController = [[ProjectViewController alloc] init];
    projectViewController.tabBarItem.badgeValue = @"";
    [self setupChildViewController:projectViewController title:DBHGetStringWithKeyFromTable(@"Project", nil) imageName:@"project_ico_s" selectedImageName:@"project_ico"];
    
    // 3.排行
    RankingViewController *rankingViewController = [[RankingViewController alloc] init];
    rankingViewController.tabBarItem.badgeValue = @"";
    [self setupChildViewController:rankingViewController title:DBHGetStringWithKeyFromTable(@"Ranking", nil) imageName:@"ranking_ico_s" selectedImageName:@"ranking_ico"];
    
    if (![self isReview]) { // 不在审核中
        // 4.钱包
        
        WalletViewController *walletViewController = [[WalletViewController alloc] init];
        
        walletViewController.tabBarItem.badgeValue = @"";
        [self setupChildViewController:walletViewController title:DBHGetStringWithKeyFromTable(@"Wallet", nil) imageName:@"qianbao_ico_s" selectedImageName:@"qianbao_ico"];
    }
    
    // 5.我的
    MyViewController * myVc = [[MyViewController alloc] init];
    myVc.tabBarItem.badgeValue = @"";
    [self setupChildViewController:myVc title:DBHGetStringWithKeyFromTable(@"My Profile", nil) imageName:@"wode_ico_s" selectedImageName:@"wode_ico"];
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
    
    NSLog(@"title  语言 -- %@", title);
    // 1.设置控制器的属性
    if ([title isEqualToString:DBHGetStringWithKeyFromTable(@"My Profile", nil)]) {
        childVc.title = title;
    } else {
        childVc.tabBarItem.title = title;
    }
    
    // 设置图标
    if (imageName) {
        childVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    // 设置选中的图标
    if (selectedImageName) {
        childVc.tabBarItem.selectedImage =  [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    // 2.包装一个导航控制器
    DBHBaseNavigationController *nav = [[DBHBaseNavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

- (BOOL)isReview {
    return [[NSUserDefaults standardUserDefaults] boolForKey:CHECK_STATUS];
}

/**
 设置状态栏颜色
 */
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

@end
