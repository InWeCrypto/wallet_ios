//
//  KKWebView.h
//  StomatologicalOfCustomer
//
//  Created by 吴灶洲 on 2017/6/30.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ICOListModel.h"

@interface KKWebView : UIViewController

@property(nonatomic,copy)NSString *urlStr;

//@property (nonatomic, strong) ICOListModel * icoModel;

@property (nonatomic, assign) BOOL isLogin; //登录页面协议

/**
 是否有分享
 */
@property (nonatomic, assign) BOOL isHaveShare;

/**
 是否隐藏刷新
 */
@property (nonatomic, assign) BOOL isHiddenRefresh;

- (instancetype)initWithUrl:(NSString *)url;

@end
