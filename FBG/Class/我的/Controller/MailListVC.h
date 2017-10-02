//
//  MailListVC.h
//  FBG
//
//  Created by mac on 2017/7/22.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MailListDelegate <NSObject>

//选择通讯录
- (void)choasePersonWithData:(id)data;

@end

@interface MailListVC : UIViewController

@property (nonatomic, assign) BOOL isChose; //选择地址进入

@property (nonatomic, strong) id <MailListDelegate> delegate;

@end
