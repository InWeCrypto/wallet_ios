//
//  DBHPersonalSettingViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHPersonalSettingViewController.h"

#import "DBHSetNicknameViewController.h"
#import "DBHChangePasswordViewController.h"

#import "DBHPersonalSettingForHeadTableViewCell.h"
#import "DBHPersonalSettingForTitleTableViewCell.h"
#import "DBHPersonalSettingForSwitchTableViewCell.h"

static NSString *const kDBHPersonalSettingForHeadTableViewCellIdentifier = @"kDBHPersonalSettingForHeadTableViewCellIdentifier";
static NSString *const kDBHPersonalSettingForTitleTableViewCellIdentifier = @"kDBHPersonalSettingForTitleTableViewCellIdentifier";
static NSString *const kDBHPersonalSettingForSwitchTableViewCellIdentifier = @"kDBHPersonalSettingForSwitchTableViewCellIdentifier";

@interface DBHPersonalSettingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation DBHPersonalSettingViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Personal Setting", nil);
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
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return !section ? 3 : 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section && !indexPath.row) {
        DBHPersonalSettingForHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHPersonalSettingForHeadTableViewCellIdentifier forIndexPath:indexPath];
        
        return cell;
    } else if (!indexPath.section || (indexPath.section && !indexPath.row)) {
        DBHPersonalSettingForTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHPersonalSettingForTitleTableViewCellIdentifier forIndexPath:indexPath];
        cell.title = NSLocalizedString(self.titleArray[indexPath.section][indexPath.row], nil);
        
        return cell;
    } else {
        DBHPersonalSettingForSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHPersonalSettingForSwitchTableViewCellIdentifier forIndexPath:indexPath];
        cell.title = @"Touch ID";
        
        return cell;
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        switch (indexPath.row) {
            case 0: {
                // 头像
                break;
            }
            case 1: {
                // 昵称
                DBHSetNicknameViewController *setNicknameViewController = [[DBHSetNicknameViewController alloc] init];
                [self.navigationController pushViewController:setNicknameViewController animated:YES];
                break;
            }
                
            default:
                break;
        }
    } else if (!indexPath.row) {
        // 修改密码
        DBHChangePasswordViewController *changePasswordViewController = [[DBHChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:changePasswordViewController animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return !indexPath.section && !indexPath.row ? AUTOLAYOUTSIZE(103.5) : AUTOLAYOUTSIZE(51);
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
        
        [_tableView registerClass:[DBHPersonalSettingForHeadTableViewCell class] forCellReuseIdentifier:kDBHPersonalSettingForHeadTableViewCellIdentifier];
        [_tableView registerClass:[DBHPersonalSettingForTitleTableViewCell class] forCellReuseIdentifier:kDBHPersonalSettingForTitleTableViewCellIdentifier];
        [_tableView registerClass:[DBHPersonalSettingForSwitchTableViewCell class] forCellReuseIdentifier:kDBHPersonalSettingForSwitchTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@[@"", @"Nickname", @"Account Number"], @[@"Change Password"]];
    }
    return _titleArray;
}

@end
