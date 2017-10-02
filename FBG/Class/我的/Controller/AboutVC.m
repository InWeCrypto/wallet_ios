//
//  AboutVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/29.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AboutVC.h"
#import "KKWebView.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
}

- (IBAction)userRuleButtonCilick:(id)sender
{
    //用户协议
    [self pushWebViewWithUrl:@"EULA.html" title:@"用户协议"];
}

- (IBAction)useRuleButtonCilick:(id)sender
{
    //使用条款
    [self pushWebViewWithUrl:@"EULA.html" title:@"使用条款"];
}

- (IBAction)openRuleButtonCilick:(id)sender
{
    //开源协议
    [self pushWebViewWithUrl:@"OpenSource.html" title:@"开源协议"];
}

- (IBAction)openTeamButtonCilick:(id)sender
{
    //开发团队
    [self pushWebViewWithUrl:@"Team.html" title:@"开发团队"];
}

- (void)pushWebViewWithUrl:(NSString *)url title:(NSString *)title
{
    NSString * api;
    if ([APP_APIEHEAD isEqualToString:@"https://ropsten.unichain.io/api/"])
    {
        //测试
        api = IMAGEHEAD;
    }
    else
    {
        //正式
        api = IMAGEHEAD1;
    }
    KKWebView * vc = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@%@",api,url]];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
