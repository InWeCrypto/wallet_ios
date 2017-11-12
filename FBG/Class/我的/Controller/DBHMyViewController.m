//
//  DBHMyViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/11.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHMyViewController.h"

#import "DBHBrowserViewController.h"
#import "MailListVC.h"
#import "ICOListVC.h"
#import "RateSettingTVC.h"
#import "MonetaryUnitVC.h"
#import "PersonDetailTVC.h"
#import "ChoseNetView.h"
#import "AboutVC.h"

#import "DBHMyHeaderView.h"
#import "DBHMyTableViewCell.h"

static NSString * const kDBHMyTableViewCellIdentifier = @"kDBHMyTableViewCellIdentifier";

@interface DBHMyViewController ()<UITableViewDataSource, UITableViewDelegate, ChoseNetViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHMyHeaderView *headerView;
@property (nonatomic, strong) ChoseNetView * choseNetView;

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *leftImageNameArray;

@end

@implementation DBHMyViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroudColor];
    
    [self setUI];
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

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHMyTableViewCellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.title = self.titleArray[indexPath.section];
    cell.leftImageName = self.leftImageNameArray[indexPath.section];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
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
    return 0;
}

#pragma mark ------ ChoseNetViewDelegate ------
/**
 切换网络代理
 */
- (void)sureButtonCilickWithTest:(BOOL)isNotTset
{
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

#pragma mark ------ Event Responds ------
/**
 编辑
 */
- (void)editButtonClick
{
    PersonDetailTVC * vc = [[UIStoryboard storyboardWithName:@"PersonDetailTVC" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonDetailTVC"];
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = self.headerView;
        
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = AUTOSIZE(60);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHMyTableViewCell class] forCellReuseIdentifier:kDBHMyTableViewCellIdentifier];
    }
    return _tableView;
}
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

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"浏览器",
                        @"通讯录",
                        @"货币单位",
                        @"网络切换",
                        @"关于我们"];
    }
    return _titleArray;
}
- (NSArray *)leftImageNameArray {
    if (!_leftImageNameArray) {
        _leftImageNameArray = @[@"btn_浏览器",
                        @"btn_cantacts",
                        @"btn_currency",
                        @"切换网络",
                        @"关于我们"];
    }
    return _leftImageNameArray;
}
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
