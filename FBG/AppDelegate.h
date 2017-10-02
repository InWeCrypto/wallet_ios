//
//  AppDelegate.h
//  FBG
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype)delegate;

@property (strong, nonatomic) UIWindow *window;

-(void)showLoginController;
- (void)goToTabbar;

@end

