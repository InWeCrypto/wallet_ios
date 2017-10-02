//
//  AddMailVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/3.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddMailVC.h"
#import "ScanVC.h"

@interface AddMailVC () <ScanVCDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameTiLB;
@property (weak, nonatomic) IBOutlet UILabel *addressTiLB;
@property (weak, nonatomic) IBOutlet UILabel *remarkTiLB;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;

@end

@implementation AddMailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.id)
    {
        self.title = @"添加联系人";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.id)
    {        
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
}

- (IBAction)scanButtonCilick:(id)sender
{
    //扫一扫
    ScanVC * vc = [[ScanVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)scanSucessWithObject:(id)object
{
    self.addressTF.text = object;
}

- (IBAction)commitButtoncilick:(id)sender
{
    //保存
    if ([NSString isNulllWithObject:self.nameTF.text])
    {
        [LCProgressHUD showMessage:@"请输入钱包名"];
        return;
    }
    if (![NSString isAdress:[self.addressTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]])
    {
        [LCProgressHUD showMessage:@"请输入正确的钱包地址"];
        return;
    }
    
    if (self.id)
    {
        //编辑
        NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
        [parametersDic setObject:@"1" forKey:@"category_id"];
        [parametersDic setObject:self.nameTF.text forKey:@"name"];
        [parametersDic setObject:[self.addressTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"address"];
        if (![NSString isNulllWithObject:self.remarkTF.text])
        {
            [parametersDic setObject:self.remarkTF.text forKey:@"remark"];
        }
        
        [PPNetworkHelper PUT:[NSString stringWithFormat:@"contact/%@",self.id] parameters:parametersDic hudString:@"修改中..." success:^(id responseObject)
         {
             [LCProgressHUD showSuccess:@"修改成功"];
             [self.navigationController popViewControllerAnimated:YES];
             
         } failure:^(NSString *error)
         {
             [LCProgressHUD showFailure:error];
         }];
    }
    else
    {
        NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
        [parametersDic setObject:@"1" forKey:@"category_id"];
        [parametersDic setObject:self.nameTF.text forKey:@"name"];
        [parametersDic setObject:self.addressTF.text forKey:@"address"];
        if (![NSString isNulllWithObject:self.remarkTF.text])
        {
            [parametersDic setObject:self.remarkTF.text forKey:@"remark"];
        }
        
        [PPNetworkHelper POST:@"contact" parameters:parametersDic hudString:@"保存中..." success:^(id responseObject)
         {
             [LCProgressHUD showSuccess:@"保存成功"];
             [self.navigationController popViewControllerAnimated:YES];
             
         } failure:^(NSString *error)
         {
             [LCProgressHUD showFailure:error];
         }];
    }
}

@end
