//
//  MyViewController.m
//  InWeCrypto
//
//  Created by 赵旭瑞 on 2018/5/23.
//  Copyright © 2018年 赵旭瑞. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)goToLoginBtnClick:(id)sender {
    
    if (![UserSignData share].user.isLogin) {
        
        [[AppDelegate delegate] goToLoginVC:self];
    }
    else {
        // 个人信息
//        DBHPersonalSettingViewController *personalSettingViewController = [[DBHPersonalSettingViewController alloc] init];
//        [self.navigationController pushViewController:personalSettingViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
