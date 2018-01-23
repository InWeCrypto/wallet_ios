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
    
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    [self setUI];
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
    return section == 1 ? 4 : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        DBHMyForUserInfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHMyForUserInfomationTableViewCellIdentifier forIndexPath:indexPath];
        
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
                    // 资产账本
                    break;
                }
                case 1: {
                    // 通讯录
                    DBHAddressBookViewController *addressBookViewController = [[DBHAddressBookViewController alloc] init];
                    [self.navigationController pushViewController:addressBookViewController animated:YES];
                    break;
                }
                case 2: {
                    // 我的收藏
                    DBHMyFavoriteViewController *myFavoriteViewController = [[DBHMyFavoriteViewController alloc] init];
                    [self.navigationController pushViewController:myFavoriteViewController animated:YES];
                    break;
                }
                case 3: {
                    // 我的行情提醒
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case 2: {
            // 设置
            break;
        }
        case 3: {
            // 关于我们
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
        _iconImageNameArray = @[@[@"wode_zichanzhangben", @"wode_tongxunlu", @"wode_shoucang", @"wode_tixing"], @[@"wode_shezhi"], @[@"wode_guanyuwo"]];
    }
    return _iconImageNameArray;
}
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@[@"Assets Book", @"Address Book", @"My Favorite", @"My Quotation Reminder"], @[@"Setting Up"], @[@"About Us"]];
    }
    return _titleArray;
}

@end
