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

#import "DBHInformationViewController.h"
#import "DBHHomePageViewController.h"
#import "DBHMyViewController.h"

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
    
//    [self setStatusBarBackgroundColor:[TESTAPIEHEAD1 isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"appNetWorkApi"]] ? [UIColor redColor] : [UIColor whiteColor]];
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
    // 1.资讯
    DBHInformationViewController *informationViewController = [[DBHInformationViewController alloc] init];
    informationViewController.tabBarItem.badgeValue = @"";
    [self setupChildViewController:informationViewController title:DBHGetStringWithKeyFromTable(@"Information", nil) imageName:@"zixun_ico_s" selectedImageName:@"zixun_ico"];
    
    // 2.钱包
    DBHHomePageViewController *homePageViewController = [[DBHHomePageViewController alloc] init];
    homePageViewController.tabBarItem.badgeValue = @"";
    [self setupChildViewController:homePageViewController title:DBHGetStringWithKeyFromTable(@"Wallet", nil) imageName:@"qianbao_ico_s" selectedImageName:@"qianbao_ico"];
    
    // 3.我的
    DBHMyViewController * my = [[DBHMyViewController alloc] init];
    my.tabBarItem.badgeValue = @"";
    [self setupChildViewController:my title:DBHGetStringWithKeyFromTable(@"My", nil) imageName:@"wode_ico_s" selectedImageName:@"wode_ico"];
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
    if ([title isEqualToString:DBHGetStringWithKeyFromTable(@"My", nil)]) {
        childVc.title = title;
    } else {
        childVc.tabBarItem.title = title;
    }
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
    DBHBaseNavigationController *nav = [[DBHBaseNavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
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
