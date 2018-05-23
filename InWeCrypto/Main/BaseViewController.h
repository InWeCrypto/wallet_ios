//
//  BaseViewController.h
//  InWeCrypto
//
//  Created by 赵旭瑞 on 2018/5/21.
//  Copyright © 2018年 赵旭瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController


/**
 返回到第几级
 */
@property (nonatomic, assign) NSInteger backIndex;

- (void)setNavigationBarTitleColor;
- (void)setNavigationTintColor;

- (void)redPacketNavigationBar;

@end
