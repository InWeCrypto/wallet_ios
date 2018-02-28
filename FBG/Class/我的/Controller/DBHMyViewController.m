//
//  DBHMyViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/19.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHMyViewController.h"

#import "DBHPersonalSettingViewController.h"
#import "DBHAddressBookViewController.h"
#import "DBHMyFavoriteViewController.h"
#import "DBHMyQuotationReminderViewController.h"
#import "DBHSettingUpViewController.h"
#import "AboutVC.h"

#import "DBHMyForUserInfomationTableViewCell.h"
#import "DBHMyTableViewCell.h"

static NSString *const kDBHMyForUserInfomationTableViewCellIdentifier = @"kDBHMyForUserInfomationTableViewCellIdentifier";
static NSString *const kDBHMyTableViewCellIdentifier = @"kDBHMyTableViewCellIdentifier";

@interface DBHMyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *iconImageNameArray;
@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation DBHMyViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLORFROM16(0xF8F8F8, 1);
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
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
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 1 ? 5 : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        DBHMyForUserInfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHMyForUserInfomationTableViewCellIdentifier forIndexPath:indexPath];
        [cell.headImageView sdsetImageWithURL:[UserSignData share].user.img placeholderImage:[UIImage imageNamed:@"touxiang"]];
        cell.nameLabel.text = [UserSignData share].user.nickname;
        cell.accountLabel.text = [NSString stringWithFormat:@"%@：%@", DBHGetStringWithKeyFromTable(@"My account", nil), [UserSignData share].user.email];
        
        return cell;
    } else {
        DBHMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHMyTableViewCellIdentifier forIndexPath:indexPath];
        cell.iconImageName = self.iconImageNameArray[indexPath.section - 1][indexPath.row];
        cell.title = self.titleArray[indexPath.section - 1][indexPath.row];
        
        return cell;
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            // 个人信息
            DBHPersonalSettingViewController *personalSettingViewController = [[DBHPersonalSettingViewController alloc] init];
            [self.navigationController pushViewController:personalSettingViewController animated:YES];
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    // 邀请码
//                    if ([UserSignData share].user.invitationCode.length) {
//                        KKWebView *webView = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@%@&token=%@", [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD5 : TESTAPIEHEAD5, [UserSignData share].user.invitationCode, [[UserSignData share].user.token stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
//                        webView.title = DBHGetStringWithKeyFromTable(@"Invitation Code", nil);
//                        webView.isHiddenRefresh = NO;
//                        [self.navigationController pushViewController:webView animated:YES];
//                    } else {
                        [self getInvitationCode];
//                    }
                    break;
                }
                case 1: {
                    // 资产账本
                    [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
                    break;
                }
                case 2: {
                    // 通讯录
                    DBHAddressBookViewController *addressBookViewController = [[DBHAddressBookViewController alloc] init];
                    [self.navigationController pushViewController:addressBookViewController animated:YES];
                    break;
                }
                case 3: {
                    // 我的收藏
                    DBHMyFavoriteViewController *myFavoriteViewController = [[DBHMyFavoriteViewController alloc] init];
                    [self.navigationController pushViewController:myFavoriteViewController animated:YES];
                    break;
                }
                case 4: {
                    // 我的行情提醒
                    DBHMyQuotationReminderViewController *myQuotationReminderViewController = [[DBHMyQuotationReminderViewController alloc] init];
                    [self.navigationController pushViewController:myQuotationReminderViewController animated:YES];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case 2: {
            // 设置
            DBHSettingUpViewController *settingUpViewController = [[DBHSettingUpViewController alloc] init];
            [self.navigationController pushViewController:settingUpViewController animated:YES];
            break;
        }
        case 3: {
            // 关于我们
            AboutVC *aboutVC = [[AboutVC alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
            break;
        }
            
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return !indexPath.section ? AUTOLAYOUTSIZE(95) : AUTOLAYOUTSIZE(50.5);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(11.5);
}

#pragma mark ------ Data ------
- (void)getInvitationCode {
    WEAKSELF
    [PPNetworkHelper GET:@"user/ont_candy_bow" baseUrlType:3 parameters:nil hudString:nil success:^(id responseObject) {
        NSString *start = [NSString stringWithFormat:@"%@", responseObject[@"candy_bow_stat"]];
        if ([start isEqualToString:@"0"]) {
            [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
            return ;
        }
        [UserSignData share].user.invitationCode = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        [[UserSignData share] storageData:[UserSignData share].user];
        
        KKWebView *webView = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@%@&token=%@", [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD5 : TESTAPIEHEAD5, [UserSignData share].user.invitationCode, [[UserSignData share].user.token stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        webView.title = DBHGetStringWithKeyFromTable(@"Invitation Code", nil);
        [weakSelf.navigationController pushViewController:webView animated:YES];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;

        _tableView.dataSource = self;
        _tableView.delegate = self;

        [_tableView registerClass:[DBHMyForUserInfomationTableViewCell class] forCellReuseIdentifier:kDBHMyForUserInfomationTableViewCellIdentifier];
        [_tableView registerClass:[DBHMyTableViewCell class] forCellReuseIdentifier:kDBHMyTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)iconImageNameArray {
    if (!_iconImageNameArray) {
        _iconImageNameArray = @[@[@"wode_yaoqingma", @"wode_zichanzhangben", @"wode_tongxunlu", @"wode_shoucang", @"wode_tixing"], @[@"wode_shezhi"], @[@"wode_guanyuwo"]];
    }
    return _iconImageNameArray;
}
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@[@"Invitation Code", @"Book of Assets", @"Contacts", @"My Reserves", @"My notifications"], @[@"Settings"], @[@"About Us"]];
    }
    return _titleArray;
}

@end
