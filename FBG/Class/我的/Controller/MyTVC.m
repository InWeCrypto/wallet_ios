//
//  MyTVC.m
//  FBG
//
//  Created by mac on 2017/7/22.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "MyTVC.h"
//#import "MyHeaderView.h"
#import "DBHBrowserViewController.h"
#import "MailListVC.h"
#import "ICOListVC.h"
#import "RateSettingTVC.h"
#import "MonetaryUnitVC.h"
#import "PersonDetailTVC.h"
#import "ChoseNetView.h"
#import "AboutVC.h"

#import "DBHMyHeaderView.h"

@interface MyTVC () <ChoseNetViewDelegate>

@property (nonatomic, strong) DBHMyHeaderView *headerView;
//@property (nonatomic, strong) MyHeaderView * headerView;
@property (nonatomic, strong) ChoseNetView * choseNetView;

@end

@implementation MyTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroudColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    self.tableView.tableHeaderView = self.headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self.headerView.headImageView sdsetImageWithHeaderimg:[UserSignData share].user.img];
    self.headerView.nameLabel.text = [UserSignData share].user.nickname;
    
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
}

- (void)editButtonClick
{
    //编辑
    PersonDetailTVC * vc = [[UIStoryboard storyboardWithName:@"PersonDetailTVC" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonDetailTVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor backgroudColor];
    
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark --UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sec = indexPath.section;
    NSInteger row = indexPath.row;
    if (sec == 0 && row == 0)
    {
        //浏览器
        DBHBrowserViewController *browserViewController = [[DBHBrowserViewController alloc] init];
        [self.navigationController pushViewController:browserViewController animated:YES];
    }
    else if (sec == 1 && row == 0)
    {
        //通讯录
        MailListVC * vc = [[MailListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    else if (sec == 1 && row == 0)
//    {
//        //ico订单详情
//        ICOListVC * vc = [[ICOListVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }
    else if (sec == 2 && row == 0)
    {
        //货币单位
        MonetaryUnitVC * vc = [[MonetaryUnitVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sec == 3 && row == 0)
    {
        //网络切换
        [self.choseNetView showWithView:nil];
        //btc费率设置
//        RateSettingTVC * vc = [[UIStoryboard storyboardWithName:@"RateSettingTVC" bundle:nil] instantiateViewControllerWithIdentifier:@"RateSettingTVC"];
//        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sec == 4 && row == 0)
    {
        //关于
        AboutVC * vc = [[AboutVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    //    else if (sec == 3 && row == 0)
    //    {
    //        //签名认证
    //        
    //    }
}

- (void)sureButtonCilickWithTest:(BOOL)isNotTset
{
    //切换网络代理
    if (isNotTset)
    {
        //正式
        [[NSUserDefaults standardUserDefaults] setObject:APIEHEAD1 forKey:@"appNetWorkApi"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        //测试
        [[NSUserDefaults standardUserDefaults] setObject:APIEHEAD forKey:@"appNetWorkApi"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[AppDelegate delegate] showLoginController];
}

#pragma mark ------ Private Methdos ------
/**
 设置状态栏颜色
 */
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark -- get
- (DBHMyHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DBHMyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZE(170))];
        
        WEAKSELF
        [_headerView clickButtonBlock:^() {
            [weakSelf editButtonClick];
        }];
    }
    return _headerView;
}
//- (MyHeaderView *)headerView
//{
//    if (!_headerView)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyHeaderView" owner:self options:nil];
//        _headerView = [nib objectAtIndex:0];
//        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 170);
//        [_headerView.editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editButtonClick)];
//        singleRecognizer.numberOfTapsRequired = 1; // 单击
//        [_headerView.headImage addGestureRecognizer:singleRecognizer];
//        _headerView.headImage.userInteractionEnabled = YES;
//    }
//    return _headerView;
//}

- (ChoseNetView *)choseNetView
{
    if (!_choseNetView)
    {
        _choseNetView = [[ChoseNetView alloc] initWithFrame:[AppDelegate delegate].window.bounds];
        _choseNetView.delegate = self;
    }
    return _choseNetView;
}

@end
