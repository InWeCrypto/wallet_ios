//
//  KKWebView.h
//  StomatologicalOfCustomer
//
//  Created by 吴灶洲 on 2017/6/30.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICOListModel.h"

@interface KKWebView : UIViewController
@property(nonatomic,copy)NSString *urlStr;
- (instancetype)initWithUrl:(NSString *)url;

@property (nonatomic, strong) ICOListModel * icoModel;
@property (nonatomic, assign) BOOL isLogin; //登录页面协议

@end
