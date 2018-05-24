//
//  UserLogin.m
//  FBG
//
//  Created by yy on 2018/3/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "UserLogin.h"
#import "LoginFingerprintViewController.h"
#import "LoginFaceViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface UserLogin()

@end

@implementation UserLogin

+ (void)userLogin:(NSString *)email password:(NSString *)password target:(UIViewController *)target {
    NSDictionary *paramters = @{@"email":email,
                                @"password":password};
    
    [PPNetworkHelper POST:@"login" baseUrlType:3 parameters:paramters hudString:[NSString stringWithFormat:@"%@...", DBHGetStringWithKeyFromTable(@"Log in", nil)] success:^(id responseObject) {
        EMError *error = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"%@", responseObject[@"id"]] password:password];
        int i = 0;
        while (error && i < 3) {
            i ++;
            [[EMClient sharedClient] logout:YES];
            error = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"%@", responseObject[@"id"]] password:password];
        }
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [LCProgressHUD hide];
                [LCProgressHUD showFailure:error.errorDescription];
            });
            return ;
        }
        // 环信登录成功
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_LOGIN_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 开启自动登录
        [[EMClient sharedClient].options setIsAutoLogin:YES];
        
        UserModel *user = [UserSignData share].user;
        if (![UserSignData share].user) {
            user = [[UserModel alloc] init];
        }
        
        user.token = responseObject[@"token"];
        user.language = responseObject[@"lang"];
        user.open_id = [NSString stringWithFormat:@"%@", responseObject[@"id"]];
        user.email = responseObject[@"email"];
        user.nickname = responseObject[NAME];
        user.img = responseObject[@"img"];
        
        // 货币单位跟随语言
        user.walletUnitType = [user.language isEqualToString:@"zh"] ? 1 : 2;
        user.isLogin = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:user.email forKey:LAST_USER_EMAIL];
        
        user.sortedTokenFlags = responseObject[@"wallet_gnt_sort"];
        
        [[UserSignData share] storageData:user];
        
        if (target) {
            [UserLogin goHome:target];
        }
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

/**
 去主页或开启FaceID/TouchID
 */
+ (void)goHome:(UIViewController *)target {
    NSError *error = nil;
    LAContext *context = [[LAContext alloc] init];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        
        [[UserSignData share] storageData:[UserSignData share].user];
        
        if ([[NSString deviceType] isEqualToString:@"iPhone X"]) { // Face ID
            [UserSignData share].user.canUseUnlockType = DBHCanUseUnlockTypeFaceID;
            
            LoginFaceViewController *loginFaceViewController = [[UIStoryboard storyboardWithName:LOGIN_STORYBOARD_NAME bundle:nil] instantiateViewControllerWithIdentifier:LOGIN_FACE_STORYBOARD_VC_ID];
            
            [target.navigationController pushViewController:loginFaceViewController animated:NO];
            
        } else { // Touch ID
            [UserSignData share].user.canUseUnlockType = DBHCanUseUnlockTypeTouchID;
            
           LoginFingerprintViewController *loginFingerprintViewController = [[UIStoryboard storyboardWithName:LOGIN_STORYBOARD_NAME bundle:nil] instantiateViewControllerWithIdentifier:LOGIN_FINGERPRINT_STORYBOARD_VC_ID];
            loginFingerprintViewController.target = target;
             [target.navigationController pushViewController:loginFingerprintViewController animated:NO];
        }
        
       
    } else {
        // 不支持Touch ID / Face ID
        [target dismissViewControllerAnimated:YES completion:nil];
        [UserSignData share].user.canUseUnlockType = DBHCanUseUnlockTypeNone;
        [[UserSignData share] storageData:[UserSignData share].user];
        [[AppDelegate delegate] goToTabbar];
    }
    

}

@end
