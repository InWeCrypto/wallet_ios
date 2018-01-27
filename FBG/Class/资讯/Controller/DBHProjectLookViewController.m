//
//  DBHProjectLookViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectLookViewController.h"

#import "KKWebView.h"

#import "DBHHistoricalInformationViewController.h"

#import "DBHProjectLookForProjectInfomationTableViewCell.h"
#import "DBHProjectLookForProjectCommunityTableViewCell.h"
#import "DBHPersonalSettingForSwitchTableViewCell.h"

#import "DBHInformationDataModels.h"
#import "DBHProjectDetailInformationDataModels.h"

static NSString *const kDBHProjectLookForProjectInfomationTableViewCellIdentifier = @"kDBHProjectLookForProjectInfomationTableViewCellIdentifier";
static NSString *const kDBHProjectLookForProjectCommunityTableViewCellIdentifier = @"kDBHProjectLookForProjectCommunityTableViewCellIdentifier";
static NSString *const kDBHPersonalSettingForSwitchTableViewCellIdentifier = @"kDBHPersonalSettingForSwitchTableViewCellIdentifier";

@interface DBHProjectLookViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *collectBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *shareBarButtonItem;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DBHProjectDetailInformationModelDataBase *projectDetailModel;

@end

@implementation DBHProjectLookViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.projectModel.unit;
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getProjectDetailInfomation];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItems = @[self.shareBarButtonItem, self.collectBarButtonItem];
    
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
            return self.projectModel.categoryUser.categoryId == 0 ? 1 : 2;
            break;
            
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            DBHProjectLookForProjectInfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectLookForProjectInfomationTableViewCellIdentifier forIndexPath:indexPath];
            cell.projectDetailModel = self.projectDetailModel;
            
            WEAKSELF
            [cell clickTypeButtonBlock:^(NSInteger type) {
                if (!type) {
                    // 项目官网
                    KKWebView * vc = [[KKWebView alloc] initWithUrl:weakSelf.projectDetailModel.website];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } else {
                    // 历史资讯
                    DBHHistoricalInformationViewController *historicalInformationViewController = [[DBHHistoricalInformationViewController alloc] init];
                    [weakSelf.navigationController pushViewController:historicalInformationViewController animated:YES];
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
            cell.title = !indexPath.row ? @"The project's website" : @"Project Stick";
            
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
    return !indexPath.section ? AUTOLAYOUTSIZE(324.5) + (self.projectDetailModel.categoryMedia.count ? 0 : - AUTOLAYOUTSIZE(37)) : AUTOLAYOUTSIZE(50.5);
}

#pragma mark ------ Data ------
/**
 获取项目详细信息
 */
- (void)getProjectDetailInfomation {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"category/%ld", (NSInteger)self.projectModel.dataIdentifier] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        if (weakSelf.projectDetailModel) {
            return ;
        }
        
        self.projectDetailModel = [DBHProjectDetailInformationModelDataBase modelObjectWithDictionary:responseCache];
        
        [weakSelf.tableView reloadData];
    } success:^(id responseObject) {
        self.projectDetailModel = [DBHProjectDetailInformationModelDataBase modelObjectWithDictionary:responseObject];
        
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
/**
 项目收藏
 */
- (void)projectCollet {
    NSDictionary *paramters = @{@"enable":self.projectModel.categoryUser.categoryId == 0 ? [NSNumber numberWithBool:true] : [NSNumber numberWithBool:false]};
    
    WEAKSELF
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"category/%ld/collect", (NSInteger)self.projectModel.dataIdentifier] baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
        weakSelf.projectModel.categoryUser.categoryId = weakSelf.projectModel.categoryUser.categoryId == 0 ? 1 : 0;
        weakSelf.collectBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:self.projectModel.categoryUser.categoryId == 0 ? @"xiangmugaikuang_xing" : @"xiangmuzhuye_xing_cio"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCollectBarButtonItem)];
        weakSelf.navigationItem.rightBarButtonItems = @[self.shareBarButtonItem, self.collectBarButtonItem];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 收藏
 */
- (void)respondsToCollectBarButtonItem {
    [self projectCollet];
}
/**
 项目查看
 */
- (void)respondsToPersonBarButtonItem {
    
}

#pragma mark ------ Getters And Setters ------
- (UIBarButtonItem *)collectBarButtonItem {
    if (!_collectBarButtonItem) {
        _collectBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:self.projectModel.categoryUser.categoryId == 0 ? @"xiangmugaikuang_xing" : @"xiangmuzhuye_xing_cio"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCollectBarButtonItem)];
    }
    return _collectBarButtonItem;
}
- (UIBarButtonItem *)shareBarButtonItem {
    if (!_shareBarButtonItem) {
        _shareBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fenxiang"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToPersonBarButtonItem)];
    }
    return _shareBarButtonItem;
}
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
        
        [_tableView registerClass:[DBHProjectLookForProjectInfomationTableViewCell class] forCellReuseIdentifier:kDBHProjectLookForProjectInfomationTableViewCellIdentifier];
        [_tableView registerClass:[DBHProjectLookForProjectCommunityTableViewCell class] forCellReuseIdentifier:kDBHProjectLookForProjectCommunityTableViewCellIdentifier];
        [_tableView registerClass:[DBHPersonalSettingForSwitchTableViewCell class] forCellReuseIdentifier:kDBHPersonalSettingForSwitchTableViewCellIdentifier];
    }
    return _tableView;
}

@end
