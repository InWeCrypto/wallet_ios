//
//  LoginViewController.m
//  InWeCrypto
//
//  Created by 赵旭瑞 on 2018/5/21.
//  Copyright © 2018年 赵旭瑞. All rights reserved.
//

#import "LoginViewController.h"
#import "UserLogin.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField        *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField        *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 登录
 */
- (IBAction)loginBtnClick:(id)sender {
    
    [UserLogin userLogin:self.accountTextField.text password:self.passwordTextField.text target:self];
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
