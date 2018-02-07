//
//  DBHFunctionalUnitLookViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHFunctionalUnitLookViewController.h"

#import "KKWebView.h"

#import "DBHInWeHotHistoricalInformationViewController.h"
#import "DBHTradingViewHistoricalInformationViewController.h"
#import "DBHExchangeNoticeHistoricalInformationViewController.h"
#import "DBHCandyBowlHistoricalInformationViewController.h"
#import "DBHTraderClockHistoricalInformationViewController.h"
#import "DBHNotificationHistoricalInformationViewController.h"

#import "DBHFunctionalUnitLookTableViewCell.h"
#import "DBHProjectLookForProjectCommunityTableViewCell.h"
#import "DBHPersonalSettingForSwitchTableViewCell.h"

#import "DBHInformationDataModels.h"
#import "DBHProjectDetailInformationDataModels.h"

static NSString *const kDBHFunctionalUnitLookTableViewCellIdentifier = @"kDBHFunctionalUnitLookTableViewCellIdentifier";
static NSString *const kDBHProjectLookForProjectCommunityTableViewCellIdentifier = @"kDBHProjectLookForProjectCommunityTableViewCellIdentifier";
static NSString *const kDBHPersonalSettingForSwitchTableViewCellIdentifier = @"kDBHPersonalSettingForSwitchTableViewCellIdentifier";

@interface DBHFunctionalUnitLookViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DBHProjectDetailInformationModelDataBase *projectDetailModel;

@end

@implementation DBHFunctionalUnitLookViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = self.projectModel.unit;
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self getProjectDetailInfomation];
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
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.projectDetailModel.categoryMedia.count;
            break;
        case 2:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            DBHFunctionalUnitLookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHFunctionalUnitLookTableViewCellIdentifier forIndexPath:indexPath];
            cell.title = self.title;
            
            WEAKSELF
            [cell clickTypeButtonBlock:^() {
                // 历史资讯
                switch (weakSelf.functionalUnitType) {
                    case 0: {
                        // InWe热点
                        DBHInWeHotHistoricalInformationViewController *inWeHotHistoricalInformationViewController = [[DBHInWeHotHistoricalInformationViewController alloc] init];
                        [self.navigationController pushViewController:inWeHotHistoricalInformationViewController animated:YES];
                        break;
                    }
                    case 1: {
                        // TradingView
                        DBHTradingViewHistoricalInformationViewController *tradingViewHistoricalInformationViewController = [[DBHTradingViewHistoricalInformationViewController alloc] init];
                        [self.navigationController pushViewController:tradingViewHistoricalInformationViewController animated:YES];
                        break;
                    }
                    case 2: {
                        // 交易所公告
                        DBHExchangeNoticeHistoricalInformationViewController *exchangeNoticeHistoricalInformationViewController = [[DBHExchangeNoticeHistoricalInformationViewController alloc] init];
                        [self.navigationController pushViewController:exchangeNoticeHistoricalInformationViewController animated:YES];
                        break;
                    }
                    case 3: {
                        // CandyBowl
                        DBHCandyBowlHistoricalInformationViewController *candyBowlHistoricalInformationViewController = [[DBHCandyBowlHistoricalInformationViewController alloc] init];
                        [self.navigationController pushViewController:candyBowlHistoricalInformationViewController animated:YES];
                        break;
                    }
                    case 4: {
                        // 交易提醒
                        DBHTraderClockHistoricalInformationViewController *traderClockHistoricalInformationViewController = [[DBHTraderClockHistoricalInformationViewController alloc] init];
                        [self.navigationController pushViewController:traderClockHistoricalInformationViewController animated:YES];
                        break;
                    }
                    case 5: {
                        // 通知
                        DBHNotificationHistoricalInformationViewController *notificationHistoricalInformationViewController = [[DBHNotificationHistoricalInformationViewController alloc] init];
                        [self.navigationController pushViewController:notificationHistoricalInformationViewController animated:YES];
                        break;
                    }
                        
                    default:
                        break;
                }
            }];
            
            return cell;
            break;
        }
        case 1: {
            DBHProjectLookForProjectCommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectLookForProjectCommunityTableViewCellIdentifier forIndexPath:indexPath];
            cell.model = self.projectDetailModel.categoryMedia[indexPath.row];
            
            return cell;
            break;
        }
        case 2: {
            DBHPersonalSettingForSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHPersonalSettingForSwitchTableViewCellIdentifier forIndexPath:indexPath];
            cell.functionalUnitType = self.functionalUnitType;
            cell.title = @"The project's website";
            
            [cell changeSwitchBlock:^(BOOL isOpen) {
                
            }];
            
            return cell;
            break;
        }
            
        default: {
            return nil;
            break;
        }
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 2 ? AUTOLAYOUTSIZE(37) : AUTOLAYOUTSIZE(0);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return !indexPath.section ? AUTOLAYOUTSIZE(166.5) + (self.projectDetailModel.categoryMedia.count ? 0 : - AUTOLAYOUTSIZE(37)) : AUTOLAYOUTSIZE(50.5);
}

#pragma mark ------ Data ------
/**
 获取项目详细信息
 */
//- (void)getProjectDetailInfomation {
//    WEAKSELF
//    [PPNetworkHelper GET:[NSString stringWithFormat:@"category/%ld", (NSInteger)self.projectModel.dataIdentifier] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
//        if (weakSelf.projectDetailModel) {
//            return ;
//        }
//
//        self.projectDetailModel = [DBHProjectDetailInformationModelDataBase modelObjectWithDictionary:responseCache];
//
//        [weakSelf.tableView reloadData];
//    } success:^(id responseObject) {
//        self.projectDetailModel = [DBHProjectDetailInformationModelDataBase modelObjectWithDictionary:responseObject];
//
//        [weakSelf.tableView reloadData];
//    } failure:^(NSString *error) {
//        [LCProgressHUD showFailure:error];
//    }];
//}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLORFROM16(0xFAFAFA, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHFunctionalUnitLookTableViewCell class] forCellReuseIdentifier:kDBHFunctionalUnitLookTableViewCellIdentifier];
        [_tableView registerClass:[DBHProjectLookForProjectCommunityTableViewCell class] forCellReuseIdentifier:kDBHProjectLookForProjectCommunityTableViewCellIdentifier];
        [_tableView registerClass:[DBHPersonalSettingForSwitchTableViewCell class] forCellReuseIdentifier:kDBHPersonalSettingForSwitchTableViewCellIdentifier];
    }
    return _tableView;
}

@end
