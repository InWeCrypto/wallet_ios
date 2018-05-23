//
//  AppDelegate.h
//  InWeCrypto
//
//  Created by 赵旭瑞 on 2018/5/21.
//  Copyright © 2018年 赵旭瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseResp;
@class QQBaseResp;
typedef void(^WXResultBlock)(BaseResp *);
typedef void(^QQResultBlock)(QQBaseResp *);


@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype)delegate;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) WXResultBlock resultBlock;
@property (nonatomic, copy) QQResultBlock qqResultBlock;

-(void)showLoginController;
- (void)goToTabbar;
- (void)emregister;
- (void)goToLoginVC:(UIViewController *)target;
- (void)showThirdLogin;

@end

