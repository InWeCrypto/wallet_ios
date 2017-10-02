//
//  RateSettingTVC.m
//  FBG
//
//  Created by mac on 2017/7/24.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "RateSettingTVC.h"

@interface RateSettingTVC ()

@property (weak, nonatomic) IBOutlet UIImageView *typeImage1;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage2;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage3;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage4;

@property (nonatomic, strong) UIButton * sureButton;

@end

@implementation RateSettingTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手续费率设置";
    
    [self.view addSubview:self.sureButton];
}

- (void)sureButtonClicked
{
    //保存
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

#pragma mark --UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sec = indexPath.section;
    NSInteger row = indexPath.row;
    if (sec == 0 && row == 0)
    {
        //10倍
        self.typeImage1.image = [UIImage imageNamed:@"list_btn_selected"];
        self.typeImage2.image = [UIImage imageNamed:@"list_btn_default"];
        self.typeImage3.image = [UIImage imageNamed:@"list_btn_default"];
        self.typeImage4.image = [UIImage imageNamed:@"list_btn_default"];
    }
    else if (sec == 1 && row == 0)
    {
        //更高
        self.typeImage1.image = [UIImage imageNamed:@"list_btn_default"];
        self.typeImage2.image = [UIImage imageNamed:@"list_btn_selected"];
        self.typeImage3.image = [UIImage imageNamed:@"list_btn_default"];
        self.typeImage4.image = [UIImage imageNamed:@"list_btn_default"];
    }
    else if (sec == 2 && row == 0)
    {
        //高
        self.typeImage1.image = [UIImage imageNamed:@"list_btn_default"];
        self.typeImage2.image = [UIImage imageNamed:@"list_btn_default"];
        self.typeImage3.image = [UIImage imageNamed:@"list_btn_selected"];
        self.typeImage4.image = [UIImage imageNamed:@"list_btn_default"];
    }
    else if (sec == 3 && row == 0)
    {
        //标准
        self.typeImage1.image = [UIImage imageNamed:@"list_btn_default"];
        self.typeImage2.image = [UIImage imageNamed:@"list_btn_default"];
        self.typeImage3.image = [UIImage imageNamed:@"list_btn_default"];
        self.typeImage4.image = [UIImage imageNamed:@"list_btn_selected"];
    }
    
    
}

- (UIButton *)sureButton
{
    if (!_sureButton)
    {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(25, SCREEN_HEIGHT - 75 - 64, SCREEN_WIDTH - 50, 45);
        [_sureButton setTitle:@"保 存" forState: UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _sureButton.backgroundColor = [UIColor colorWithHexString:@"232772"];
        _sureButton.layer.cornerRadius = 6;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton addTarget:self action:@selector(sureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

@end
