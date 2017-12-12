//
//  DBHInformationDetailForOnLineBeforeViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/12/6.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForOnLineBeforeViewController.h"

#import "YCXMenu.h"

#import "DBHAllInformationViewController.h"
#import "DBHEvaluatingIcoViewController.h"
#import "DBHSearchViewController.h"
#import "KKWebView.h"

#import "DBHInformationForProjectCollectionModelData.h"
#import "DBHInformationDetailDataModels.h"

@interface DBHInformationDetailForOnLineBeforeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *stateView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DBHInformationDetailModelData *model;
@property (nonatomic, assign) NSInteger inweReportType; // 0:视频 1:图文
@property (nonatomic, strong) NSMutableArray * items; // 菜单
@property (nonatomic, strong) NSMutableArray * inweReportArray; // INWE报道

@end

@implementation DBHInformationDetailForOnLineBeforeViewController

//#pragma mark ------ Lifecycle ------
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.title = @"Kyber network （KNC）";
//    self.view.backgroundColor = [UIColor colorWithHexString:@"171C27"];
//
//    [self setUI];
//    [self getProjectData];
//}
//
//#pragma mark ------ UI ------
//- (void)setUI {
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_market_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(repondsToRightBarButtonItem)];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//
//    [self.view addSubview:self.stateView];
//    [self.view addSubview:self.stateLabel];
//    [self.view addSubview:self.tableView];
//
//    WEAKSELF
//    [self.stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.view);
//        make.height.offset(AUTOLAYOUTSIZE(21));
//        make.centerX.top.equalTo(weakSelf.view);
//    }];
//    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.view);
//        make.top.equalTo(weakSelf.stateView);
//    }];
//    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.view);
//        make.centerX.equalTo(weakSelf.view);
//        make.top.equalTo(weakSelf.stateView.mas_bottom);
//        make.bottom.equalTo(weakSelf.view);
//    }];
//}
//
//#pragma mark ------ UITableViewDataSource ------
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 6 + self.model.projectDesc.count;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WEAKSELF
//    if (indexPath.section == 6 + self.model.projectDesc.count - 1) {
//        // Twitter
//    } else if (indexPath.section == 6 + self.model.projectDesc.count) {
//        // Social
//    } else {
//        switch (indexPath.row) {
//            case 0: {
//                // 项目快讯
//
//                break;
//            }
//            case 1: {
//                // ICO详情
//
//                break;
//            }
//            case 2: {
//                // 测评
//
//                break;
//            }
//            case 3: {
//                // INWE报道
//
//                break;
//            }
//
//            default: {
//                // 项目简介、团队介绍等
//
//                break;
//            }
//        }
//    }
//}
//
//#pragma mark ------ UITableViewDelegate ------
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 6 + self.model.projectDesc.count - 1) {
//        // Twitter
//    } else if (indexPath.section == 6 + self.model.projectDesc.count) {
//        // Social
//    } else {
//        switch (indexPath.row) {
//            case 0: {
//                // 项目快讯
//
//                break;
//            }
//            case 1: {
//                // ICO详情
//
//                break;
//            }
//            case 2: {
//                // 测评
//
//                break;
//            }
//            case 3: {
//                // INWE报道
//
//                break;
//            }
//
//            default: {
//                // 项目简介、团队介绍等
//
//                break;
//            }
//        }
//    }
//}
//
//#pragma mark ------ Data ------
///**
// 获取项目详细数据
// */
//- (void)getProjectData {
//    WEAKSELF
//    [PPNetworkHelper GET:[NSString stringWithFormat:@"project/%ld", (NSInteger)self.projectModel.dataIdentifier] isOtherBaseUrl:YES parameters:nil hudString:nil success:^(id responseObject) {
//        weakSelf.model = [DBHInformationDetailModelData modelObjectWithDictionary:responseObject];
//
//        [weakSelf.tableView reloadData];
//    } failure:^(NSString *error) {
//        [LCProgressHUD showFailure:error];
//    }];
//}
//
//#pragma mark ------ Event Responds ------
///**
// 右上角按钮
// */
//- (void)repondsToRightBarButtonItem {
//    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"161F26"]];
//    [YCXMenu setTintColor:[UIColor colorWithHexString:@"161F26"]];
//    [YCXMenu setTitleFont:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)]];
//    [YCXMenu setSelectedColor:[UIColor colorWithHexString:@"161F26"]];
//    [YCXMenu setselectedIndex:-1];
//    if ([YCXMenu isShow])
//    {
//        [YCXMenu dismissMenu];
//    }
//    else
//    {
//        WEAKSELF
//        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item)
//         {
//
//             switch (index)
//             {
//                 case 0:
//                 {
//                     // 首页
//                     [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//
//                     break;
//                 }
//                 case 1:
//                 {
//                     // 所有资讯
//                     DBHAllInformationViewController *allInformationViewController;
//                     for (UIViewController *vc in self.navigationController.viewControllers) {
//                         if ([vc isKindOfClass:[DBHAllInformationViewController class]]) {
//                             allInformationViewController = (DBHAllInformationViewController *)vc;
//                             break;
//                         }
//                     }
//
//                     if (!allInformationViewController) {
//                         allInformationViewController = [[DBHAllInformationViewController alloc] init];
//                         [weakSelf.navigationController pushViewController:allInformationViewController animated:YES];
//                     } else {
//                         [weakSelf.navigationController popToViewController:allInformationViewController animated:YES];
//                     }
//
//                     break;
//                 }
//                 case 2:
//                 {
//                     // Ico评测
//                     DBHEvaluatingIcoViewController *evaluatingIcoViewController;
//                     for (UIViewController *vc in self.navigationController.viewControllers) {
//                         if ([vc isKindOfClass:[DBHEvaluatingIcoViewController class]]) {
//                             evaluatingIcoViewController = (DBHEvaluatingIcoViewController *)vc;
//                             break;
//                         }
//                     }
//
//                     if (!evaluatingIcoViewController) {
//                         evaluatingIcoViewController = [[DBHEvaluatingIcoViewController alloc] init];
//                         [weakSelf.navigationController pushViewController:evaluatingIcoViewController animated:YES];
//                     } else {
//                         [weakSelf.navigationController popToViewController:evaluatingIcoViewController animated:YES];
//                     }
//
//                     break;
//                 }
//                 default:
//                     break;
//             }
//         }];
//    }
//}
///**
// 搜索
// */
//- (void)respondsToSearchBarButton {
//    DBHSearchViewController *searchViewController = [[DBHSearchViewController alloc] init];
//    searchViewController.title = @"搜索项目";
//    [self.navigationController pushViewController:searchViewController animated:YES];
//}
//
//#pragma mark ------ Getters And Setters ------
//- (void)setProjectModel:(DBHInformationForProjectCollectionModelData *)projectModel {
//    _projectModel = projectModel;
//
//    switch ((NSInteger)projectModel.type) {
//        case 5: {
//            // 已上线
//            self.stateLabel.text = @"上线交易中";
//            break;
//        }
//        case 6: {
//            // 待上线
//            self.stateLabel.text = @"待上线";
//            break;
//        }
//        case 7: {
//            // 众筹中
//            NSMutableAttributedString *stateAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"众筹中%@", _projectModel.score]];
//            [stateAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xFF3232, 1) range:NSMakeRange(3, _projectModel.score.length)];
//
//            self.stateLabel.attributedText = stateAttributedString;
//            break;
//        }
//        case 8: {
//            // 即将众筹中
//            NSMutableAttributedString *stateAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"即将众筹%@", _projectModel.score]];
//            [stateAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xFF3232, 1) range:NSMakeRange(4, _projectModel.score.length)];
//
//            self.stateLabel.attributedText = stateAttributedString;
//            break;
//        }
//
//
//        default:
//            break;
//    }
//}
//
//- (UIView *)stateView {
//    if (!_stateView) {
//        _stateView = [[UIView alloc] init];
//        _stateView.backgroundColor = COLORFROM16(0xFFFFFF, 1);
//    }
//    return _stateView;
//}
//- (UILabel *)stateLabel {
//    if (!_stateLabel) {
//        _stateLabel = [[UILabel alloc] init];
//        _stateLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
//        _stateLabel.textColor = [UIColor colorWithHexString:@"333333"];
//    }
//    return _stateLabel;
//}
//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.backgroundColor = COLORFROM16(0xF2F2F2, 1);
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
//        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
//
//        _tableView.sectionFooterHeight = 0;
//
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//
//        [_tableView registerClass:[DBHInformationDetailForDealInfomationTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForDealInfomationTableViewCellIdentifier];
//        [_tableView registerClass:[DBHInformationDetailForDealInfomationChartTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForDealInfomationChartTableViewCellIdentifier];
//        [_tableView registerClass:[DBHInformationDetailForTradingMarketTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForTradingMarketTableViewCellIdentifier];
//        [_tableView registerClass:[DBHInformationDetailForProjectBriefTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForProjectBriefTableViewCellIdentifier];
//        [_tableView registerClass:[DBHInformationDetailForInweReportTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForInweReportTableViewCellIdentifier];
//        [_tableView registerClass:[DBHInformationDetailForExplorerAndWalletTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForExplorerAndWalletTableViewCellIdentifier];
//        [_tableView registerClass:[DBHInformationDetailForTwitterTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForTwitterTableViewCellIdentifier];
//        [_tableView registerClass:[DBHInformationDetailForMoreTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForMoreTableViewCellIdentifier];
//    }
//    return _tableView;
//}
//
//- (NSMutableArray *)items
//{
//    if (!_items)
//    {
//        _items = [NSMutableArray array];
//
//        YCXMenuItem *firstMenuItem = [YCXMenuItem menuItem:NSLocalizedString(@"Home page", nil)
//                                                     image:nil
//                                                       tag:100
//                                                  userInfo:@{@"title":@"Menu"}];
//        YCXMenuItem *secondMenuItem = [YCXMenuItem menuItem:NSLocalizedString(@"All the information", nil)
//                                                      image:nil
//                                                        tag:100
//                                                   userInfo:@{@"title":@"Menu"}];
//        YCXMenuItem *thirdMenuItem = [YCXMenuItem menuItem:NSLocalizedString(@"Business Project", nil)
//                                                     image:nil
//                                                       tag:101
//                                                  userInfo:@{@"title":@"Menu"}];
//        [firstMenuItem setForeColor:[UIColor colorWithHexString:@"97BDDB"]];
//        [secondMenuItem setForeColor:[UIColor colorWithHexString:@"97BDDB"]];
//        [thirdMenuItem setForeColor:[UIColor colorWithHexString:@"97BDDB"]];
//
//        [_items addObject:firstMenuItem];
//        [_items addObject:secondMenuItem];
//        [_items addObject:thirdMenuItem];
//    }
//    return _items;
//}

@end
