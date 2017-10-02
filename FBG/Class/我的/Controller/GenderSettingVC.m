//
//  GenderSettingVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/3.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "GenderSettingVC.h"

@interface GenderSettingVC ()

@property (weak, nonatomic) IBOutlet UILabel *boyLB;
@property (weak, nonatomic) IBOutlet UILabel *girlLB;


@property (weak, nonatomic) IBOutlet UIImageView *boyImage;
@property (weak, nonatomic) IBOutlet UIImageView *girlImage;

@end

@implementation GenderSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"性别";
    
    if ([[UserSignData share].user.sex intValue] == 1)
    {
        self.boyImage.hidden = NO;
        self.girlImage.hidden = YES;
    }
    else
    {
        self.boyImage.hidden = YES;
        self.girlImage.hidden = NO;
    }
}

- (IBAction)boyButtonCilick:(id)sender
{
    //男
    self.boyImage.hidden = NO;
    self.girlImage.hidden = YES;
    
    [self upUserWithImg:[UserSignData share].user.img nickName:[UserSignData share].user.nickname sex:@"1"];
}

- (IBAction)girlButtonCilick:(id)sender
{
    //女
    self.boyImage.hidden = YES;
    self.girlImage.hidden = NO;
    
    [self upUserWithImg:[UserSignData share].user.img nickName:[UserSignData share].user.nickname sex:@"2"];
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
