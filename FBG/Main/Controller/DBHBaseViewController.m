//
//  DBHBaseViewController.m
//  Trinity
//
//  Created by 邓毕华 on 2017/12/25.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHBaseViewController.h"

@interface DBHBaseViewController ()

@end

@implementation DBHBaseViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUNDCOLOR;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarTitleColor];
}

- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLORFROM16(0x333333, 1), NSFontAttributeName:FONT(20)}];
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
        [NSStringFromClass([self class]) isEqualToString:@"AddWalletSucessVC"]) {
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                }
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
