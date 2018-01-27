//
//  DBHProjectHomeViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectHomeViewController.h"

#import "DBHProjectLookViewController.h"
#import "DBHProjectOverviewViewController.h"

#import "DBHProjectHomeHeaderView.h"
#import "DBHInputView.h"
#import "DBHProjectHomeMenuView.h"
#import "DBHProjectHomeTypeOneTableViewCell.h"
#import "DBHProjectHomeTypeTwoTableViewCell.h"

#import "DBHInformationDataModels.h"
#import "DBHProjectHomeNewsDataModels.h"

static NSString *const kDBHProjectHomeTypeOneTableViewCellIdentifier = @"kDBHProjectHomeTypeOneTableViewCellIdentifier";
static NSString *const kDBHProjectHomeTypeTwoTableViewCellIdentifier = @"kDBHProjectHomeTypeTwoTableViewCellIdentifier";

@interface DBHProjectHomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *collectBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *personBarButtonItem;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHInputView *keyboardView;
@property (nonatomic, strong) DBHProjectHomeMenuView *projectHomeMenuView;

@property (nonatomic, copy) NSString *price; // 价格
@property (nonatomic, copy) NSString *change; // 涨幅
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHProjectHomeViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.projectModel.unit;
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getInfomation];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItems = @[self.personBarButtonItem, self.collectBarButtonItem];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.keyboardView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.keyboardView.mas_top);
    }];
    [self.keyboardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(47));
        make.centerX.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        DBHProjectHomeTypeOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectHomeTypeOneTableViewCellIdentifier forIndexPath:indexPath];
        cell.projectModel = self.projectModel;
        
        return cell;
    } else {
        DBHProjectHomeTypeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectHomeTypeTwoTableViewCellIdentifier forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.section - 1];
        
        return cell;
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!section) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = COLORFROM10(235, 235, 235, 1);
        return headerView;
    } else {
        DBHProjectHomeNewsModelData *model = self.dataSource[section - 1];
        DBHProjectHomeHeaderView *headerView = [[DBHProjectHomeHeaderView alloc] init];
        headerView.time = model.updatedAt;
        return headerView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return !section ? AUTOLAYOUTSIZE(25) : AUTOLAYOUTSIZE(42);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return !indexPath.section ? AUTOLAYOUTSIZE(277.5) : AUTOLAYOUTSIZE(215.5);
}

#pragma mark ------ Data ------
/**
 项目收藏
 */
- (void)projectCollet {
    NSDictionary *paramters = @{@"enable":self.projectModel.categoryUser.categoryId == 0 ? [NSNumber numberWithBool:true] : [NSNumber numberWithBool:false]};
    
    WEAKSELF
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"category/%ld/collect", (NSInteger)self.projectModel.dataIdentifier] baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
        weakSelf.projectModel.categoryUser.categoryId = weakSelf.projectModel.categoryUser.categoryId == 0 ? 1 : 0;
        weakSelf.collectBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:self.projectModel.categoryUser.categoryId == 0 ? @"xiangmugaikuang_xing" : @"xiangmuzhuye_xing_cio"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCollectBarButtonItem)];
        weakSelf.navigationItem.rightBarButtonItems = @[self.personBarButtonItem, self.collectBarButtonItem];
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
    DBHProjectLookViewController *projectLookViewController = [[DBHProjectLookViewController alloc] init];
    projectLookViewController.projectModel = self.projectModel;
    [self.navigationController pushViewController:projectLookViewController animated:YES];
}

#pragma mark ------ Data ------
/**
 获取代币价格
 */
- (void)getPrice {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"ico/rank/%@/cny", self.projectModel.unit] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        NSString *price = [UserSignData share].user.walletUnitType == 1 ? responseCache[@"price_cny"] : responseCache[@"price_usd"];
        NSString *change = responseCache[@"percent_change_24h"];
        weakSelf.price = [NSString stringWithFormat:@"%@%.2lf", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", price.floatValue];
        weakSelf.change = [NSString stringWithFormat:@"%@%.2lf", change.floatValue >= 0 ? @"+" : @"", change.floatValue];
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } success:^(id responseObject) {
        NSString *price = [UserSignData share].user.walletUnitType == 1 ? responseObject[@"price_cny"] : responseObject[@"price_usd"];
        NSString *change = responseObject[@"percent_change_24h"];
        weakSelf.price = [NSString stringWithFormat:@"%@%.2lf", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", price.floatValue];
        weakSelf.change = [NSString stringWithFormat:@"%@%.2lf", change.floatValue >= 0 ? @"+" : @"", change.floatValue];
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSString *error) {
        //        [LCProgressHUD showFailure:error];
    }];
}
/**
 获取项目资讯
 */
- (void)getInfomation {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"article?cid=%ld", (NSInteger)self.projectModel.dataIdentifier] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        if (weakSelf.dataSource.count) {
            return ;
        }
        
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseCache[@"data"]) {
            DBHProjectHomeNewsModelData *model = [DBHProjectHomeNewsModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf.tableView reloadData];
    } success:^(id responseObject) {
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            DBHProjectHomeNewsModelData *model = [DBHProjectHomeNewsModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Getters And Setters ------
- (UIBarButtonItem *)collectBarButtonItem {
    if (!_collectBarButtonItem) {
        _collectBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:self.projectModel.categoryUser.categoryId == 0 ? @"xiangmugaikuang_xing" : @"xiangmuzhuye_xing_cio"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCollectBarButtonItem)];
    }
    return _collectBarButtonItem;
}
- (UIBarButtonItem *)personBarButtonItem {
    if (!_personBarButtonItem) {
        _personBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiangmuzhuye_ren_ico"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToPersonBarButtonItem)];
    }
    return _personBarButtonItem;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLORFROM10(235, 235, 235, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHProjectHomeTypeOneTableViewCell class] forCellReuseIdentifier:kDBHProjectHomeTypeOneTableViewCellIdentifier];
        [_tableView registerClass:[DBHProjectHomeTypeTwoTableViewCell class] forCellReuseIdentifier:kDBHProjectHomeTypeTwoTableViewCellIdentifier];
    }
    return _tableView;
}
- (DBHInputView *)keyboardView {
    if (!_keyboardView) {
        _keyboardView = [[DBHInputView alloc] init];
        _keyboardView.dataSource = @[@{@"value":@"Project Overview", @"isMore":@"1"},
                                     @{@"value":@"Historical Information", @"isMore":@"0"},
                                     @{@"value":@"Project Introduction", @"isMore":@"0"}];
        
        WEAKSELF
        [_keyboardView clickButtonBlock:^(NSInteger buttonType) {
            switch (buttonType) {
                case 0: {
                    // 聊天室
                    if (weakSelf.projectHomeMenuView.superview) {
                        [weakSelf.projectHomeMenuView animationHide];
                    }
                    break;
                }
                case 1: {
                    // 项目概况
                    if (weakSelf.projectHomeMenuView.superview) {
                        [weakSelf.projectHomeMenuView animationHide];
                    } else {
                        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.projectHomeMenuView];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.projectHomeMenuView animationShow];
                        });
                    }
                    break;
                }
                case 2: {
                    // 历史资讯
                    if (weakSelf.projectHomeMenuView.superview) {
                        [weakSelf.projectHomeMenuView animationHide];
                    }
                    break;
                }
                case 3: {
                    // 项目介绍
                    if (weakSelf.projectHomeMenuView.superview) {
                        [weakSelf.projectHomeMenuView animationHide];
                    }
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    return _keyboardView;
}
- (DBHProjectHomeMenuView *)projectHomeMenuView {
    if (!_projectHomeMenuView) {
        _projectHomeMenuView = [[DBHProjectHomeMenuView alloc] init];
        _projectHomeMenuView.line = 1;
        _projectHomeMenuView.maxLine = 3;
        _projectHomeMenuView.dataSource = @[@"Project overview",
                                            @"Real-Time Quotes",
                                            @"Trading Market"];
        
        WEAKSELF
        [_projectHomeMenuView selectedBlock:^(NSInteger index) {
            switch (index) {
                case 0: {
                    // 项目全览
                    DBHProjectOverviewViewController *projectOverviewViewController = [[DBHProjectOverviewViewController alloc] init];
                    projectOverviewViewController.projectModel = self.projectModel;
                    [weakSelf.navigationController pushViewController:projectOverviewViewController animated:YES];
                    break;
                }
                case 1: {
                    // 实时行情
                    break;
                }
                case 2: {
                    // 交易市场
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    return _projectHomeMenuView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
