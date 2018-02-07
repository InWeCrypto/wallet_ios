//
//  DBHProjectHomeViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectHomeViewController.h"

#import "FBG-Swift.h"

#import "DBHProjectLookViewController.h"
#import "DBHProjectOverviewViewController.h"
#import "DBHTradingMarketViewController.h"
#import "DBHHistoricalInformationViewController.h"
#import "DBHWebViewController.h"

#import "DBHProjectHomeHeaderView.h"
#import "DBHInputView.h"
#import "DBHProjectHomeMenuView.h"
#import "DBHProjectHomeTypeOneTableViewCell.h"
#import "DBHProjectHomeTypeTwoTableViewCell.h"

#import "DBHInformationDataModels.h"
#import "DBHProjectDetailInformationDataModels.h"
#import "DBHProjectHomeNewsDataModels.h"

static NSString *const kDBHProjectHomeTypeOneTableViewCellIdentifier = @"kDBHProjectHomeTypeOneTableViewCellIdentifier";
static NSString *const kDBHProjectHomeTypeTwoTableViewCellIdentifier = @"kDBHProjectHomeTypeTwoTableViewCellIdentifier";

@interface DBHProjectHomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *collectBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *personBarButtonItem;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHInputView *keyboardView;
@property (nonatomic, strong) DBHProjectHomeMenuView *projectHomeMenuView;

@property (nonatomic, strong) DBHProjectDetailInformationModelDataBase *projectDetailModel;
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
    
    [self getProjectDetailInfomation];
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
    return 1 + (self.projectDetailModel.lastArticle.categoryId != 0 ? 1 : 0);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        DBHProjectHomeTypeOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectHomeTypeOneTableViewCellIdentifier forIndexPath:indexPath];
        cell.projectModel = self.projectModel;
        
        WEAKSELF
        [cell clickButtonBlock:^(NSInteger type) {
            switch (type) {
                case 0: {
                    // 项目全览
                    DBHProjectOverviewViewController *projectOverviewViewController = [[DBHProjectOverviewViewController alloc] init];
                    projectOverviewViewController.projectDetailModel = weakSelf.projectDetailModel;
                    [weakSelf.navigationController pushViewController:projectOverviewViewController animated:YES];
                    break;
                }
                case 1: {
                    // 实时行情
                    DBHMarketDetailViewController *marketDetailViewController = [[DBHMarketDetailViewController alloc] init];
                    marketDetailViewController.yourOpinion = DBHGetStringWithKeyFromTable(@"Your Opinion", nil);
                    marketDetailViewController.chatRoomId = [NSString stringWithFormat:@"%ld", (NSInteger)weakSelf.projectDetailModel.roomId];
                    marketDetailViewController.title = weakSelf.projectDetailModel.unit;
                    [weakSelf.navigationController pushViewController:marketDetailViewController animated:YES];
                    break;
                }
                case 2: {
                    // 交易市场
                    DBHTradingMarketViewController *tradingMarketViewController = [[DBHTradingMarketViewController alloc] init];
                    tradingMarketViewController.title = weakSelf.projectDetailModel.unit;
                    tradingMarketViewController.chatRoomId = [NSString stringWithFormat:@"%ld", (NSInteger)weakSelf.projectDetailModel.roomId];
                    [weakSelf.navigationController pushViewController:tradingMarketViewController animated:YES];
                    break;
                }
                    
                default:
                    break;
            }
        }];
        
        return cell;
    } else {
        DBHProjectHomeTypeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectHomeTypeTwoTableViewCellIdentifier forIndexPath:indexPath];
        cell.lastModel = self.projectDetailModel.lastArticle;
        
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
        DBHProjectHomeHeaderView *headerView = [[DBHProjectHomeHeaderView alloc] init];
        headerView.time = self.projectDetailModel.lastArticle.createdAt;
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
 获取项目资讯
 */
- (void)getInfomation {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"article?cid=%ld", (NSInteger)self.projectModel.dataIdentifier] baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
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

#pragma mark ------ Getters And Setters ------
- (UIBarButtonItem *)collectBarButtonItem {
    if (!_collectBarButtonItem) {
        _collectBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:self.projectModel.categoryUser.isFavorite ? @"xiangmuzhuye_xing_cio" : @"xiangmugaikuang_xing"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCollectBarButtonItem)];
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
        
        _tableView.sectionHeaderHeight = 0;
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
                    if (weakSelf.projectHomeMenuView.superview) {
                        [weakSelf.projectHomeMenuView animationHide];
                    }
                    // 聊天室
                    if (!weakSelf.projectModel.roomId) {
                        // 聊天室不存在
                        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The project has no chat room", nil)];
                        return ;
                    }
                    EaseMessageViewController *chatViewController = [[EaseMessageViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%ld", (NSInteger)weakSelf.projectModel.roomId] conversationType:EMConversationTypeChatRoom];
                    chatViewController.title = weakSelf.projectModel.unit;
                    [weakSelf.navigationController pushViewController:chatViewController animated:YES];
                    break;
                }
                case 1: {
                    if (weakSelf.projectHomeMenuView.superview) {
                        [weakSelf.projectHomeMenuView animationHide];
                    } else {
                        // 项目概况
                        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.projectHomeMenuView];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.projectHomeMenuView animationShow];
                        });
                    }
                    break;
                }
                case 2: {
                    if (weakSelf.projectHomeMenuView.superview) {
                        [weakSelf.projectHomeMenuView animationHide];
                    }
                    // 历史资讯
                    DBHHistoricalInformationViewController *historicalInformationViewController = [[DBHHistoricalInformationViewController alloc] init];
                    historicalInformationViewController.projevtId = [NSString stringWithFormat:@"%ld", (NSInteger) weakSelf.projectModel.dataIdentifier];
                    [weakSelf.navigationController pushViewController:historicalInformationViewController animated:YES];
                    break;
                }
                case 3: {
                    if (weakSelf.projectHomeMenuView.superview) {
                        [weakSelf.projectHomeMenuView animationHide];
                    }
                    // 项目介绍
                    DBHWebViewController *webViewController = [[DBHWebViewController alloc] init];
                    webViewController.isHiddenYourOpinion = YES;
                    webViewController.title = self.projectDetailModel.unit;
                    webViewController.htmlString = self.projectDetailModel.categoryPresentation.content;
                    [weakSelf.navigationController pushViewController:webViewController animated:YES];
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
                    projectOverviewViewController.projectDetailModel = weakSelf.projectDetailModel;
                    [weakSelf.navigationController pushViewController:projectOverviewViewController animated:YES];
                    break;
                }
                case 1: {
                    // 实时行情
                    DBHMarketDetailViewController *marketDetailViewController = [[DBHMarketDetailViewController alloc] init];
                    marketDetailViewController.yourOpinion = DBHGetStringWithKeyFromTable(@"Your Opinion", nil);
                    marketDetailViewController.chatRoomId = [NSString stringWithFormat:@"%ld", (NSInteger)weakSelf.projectDetailModel.roomId];
                    marketDetailViewController.title = weakSelf.projectDetailModel.unit;
                    [weakSelf.navigationController pushViewController:marketDetailViewController animated:YES];
                    break;
                }
                case 2: {
                    // 交易市场
                    DBHTradingMarketViewController *tradingMarketViewController = [[DBHTradingMarketViewController alloc] init];
                    tradingMarketViewController.title = weakSelf.projectDetailModel.unit;
                    tradingMarketViewController.chatRoomId = [NSString stringWithFormat:@"%ld", (NSInteger)weakSelf.projectDetailModel.roomId];
                    [weakSelf.navigationController pushViewController:tradingMarketViewController animated:YES];
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
