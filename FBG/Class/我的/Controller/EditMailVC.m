//
//  EditMailVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/3.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "EditMailVC.h"
#import "AddMailVC.h"
#import "ScanVC.h"

@interface EditMailVC () <ScanVCDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameTiLB;
@property (weak, nonatomic) IBOutlet UILabel *addressTiLB;
@property (weak, nonatomic) IBOutlet UILabel *remarkTiLB;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;

@end

@implementation EditMailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"联系人查看";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [PPNetworkHelper GET:[NSString stringWithFormat:@"contact/%@",self.id] parameters:nil hudString:@"获取中..." success:^(id responseObject)
    {
        NSDictionary * dic = [responseObject objectForKey:@"record"];
        self.nameTF.text = [dic objectForKey:@"name"];
        self.addressTF.text = [dic objectForKey:@"address"];
        if (![NSString isNulllWithObject:[dic objectForKey:@"remark"]])
        {
            self.remarkTF.text = [dic objectForKey:@"remark"];
        }
        
    } failure:^(NSString *error)
    {
        [LCProgressHUD showFailure:@"获取失败，请退出后重试"];
    }];
}

- (void)scanSucessWithObject:(id)object
{
    self.addressTF.text = object;
}

- (IBAction)scanButtonCilick:(id)sender
{
    //扫一扫
//    ScanVC * vc = [[ScanVC alloc] init];
//    vc.delegate = self;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)editButtonCilick:(id)sender
{
    //编辑
    AddMailVC * vc = [[AddMailVC alloc] init];
    vc.title = @"编辑联系人";
    vc.id = self.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)deleteButtonCilick:(id)sender
{
    //删除
    [PPNetworkHelper DELETE:[NSString stringWithFormat:@"contact/%@",self.id] parameters:nil hudString:@"删除中..." success:^(id responseObject)
     {
         [LCProgressHUD showSuccess:@"删除成功"];
         [self.navigationController popViewControllerAnimated:YES];
         
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
}


@end
