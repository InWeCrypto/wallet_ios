//
//  Modify nicknameVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/3.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "ModifyNicknameVC.h"

@interface ModifyNicknameVC ()

@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;

@end

@implementation ModifyNicknameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"昵称";
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
    [rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.nickNameTF.text = [UserSignData share].user.nickname;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.nickNameTF becomeFirstResponder];
}

- (void)rightButton
{
    //保存
    [self upUserWithImg:[UserSignData share].user.img nickName:self.nickNameTF.text sex:[UserSignData share].user.sex];
}

- (void)upUserWithImg:(NSString *)img nickName:(NSString *)nickName sex:(NSString *)sex
{
    if (![NSString isNickName:nickName])
    {
        [LCProgressHUD showFailure:@"请输入2~12位非特殊字符的昵称"];
        return;
    }
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:nickName forKey:@"nickname"];
    [dic setObject:img forKey:@"img"];
    [dic setObject:sex forKey:@"sex"];
    
    [PPNetworkHelper POST:@"user" parameters:dic hudString:nil success:^(id responseObject)
     {
         //更新本地数据
         [UserSignData share].user.img = img;
         [UserSignData share].user.nickname = nickName;
         [UserSignData share].user.sex = sex;
         [[UserSignData share] storageData:[UserSignData share].user];
         
         [self.navigationController popViewControllerAnimated:YES];
         
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
}

@end
