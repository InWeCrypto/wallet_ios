//
//  DBHInformationDetailForOnLineAfterViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/12/6.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForOnLineAfterViewController.h"

#import "YCXMenu.h"

#import "DBHAllInformationViewController.h"
#import "DBHEvaluatingIcoViewController.h"
#import "DBHSearchViewController.h"
#import "KKWebView.h"

#import "DBHInformationDetailHeaderButton.h"
#import "DBHInformationDetailForProjectFlashTableViewCell.h"
#import "DBHInformationDetailForDealInfomationTableViewCell.h"
#import "DBHInformationDetailForTradingMarketTableViewCell.h"
#import "DBHInformationDetailForInweReportTableViewCell.h"
#import "DBHInformationDetailForProjectBriefTableViewCell.h"
#import "DBHInformationDetailForTwitterTableViewCell.h"
#import "DBHInformationDetailForMoreTableViewCell.h"

#import "DBHInformationForProjectCollectionModelData.h"
#import "DBHInformationDetailDataModels.h"
#import "DBHInformationDetailForTradingMarketContentDataModels.h"
#import "DBHInformationDetailForInweDataModels.h"

static NSString *const kDBHInformationDetailForProjectFlashTableViewCellIdentifier = @"kDBHInformationDetailForProjectFlashTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForDealInfomationTableViewCellIdentifier = @"kDBHInformationDetailForDealInfomationTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForTradingMarketTableViewCellIdentifier = @"kDBHInformationDetailForTradingMarketTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForInweReportTableViewCellIdentifier = @"kDBHInformationDetailForInweReportTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForProjectBriefTableViewCellIdentifier = @"kDBHInformationDetailForProjectBriefTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForTwitterTableViewCellIdentifier = @"kDBHInformationDetailForTwitterTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForMoreTableViewCellIdentifier = @"kDBHInformationDetailForMoreTableViewCellIdentifier";

@interface DBHInformationDetailForOnLineAfterViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *stateView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DBHInformationDetailModelData *model;
@property (nonatomic, assign) NSInteger inweReportType; // 0:视频 1:图文
@property (nonatomic, strong) NSMutableArray * items; // 菜单
@property (nonatomic, strong) NSMutableArray *tradingMarketArray; // 交易市场数据
@property (nonatomic, strong) NSMutableArray * inweReportArray; // INWE报道
@property (nonatomic, strong) NSMutableArray *isExpansionArray; // 是否展开

@end

@implementation DBHInformationDetailForOnLineAfterViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Kyber network （KNC）";
    self.view.backgroundColor = [UIColor colorWithHexString:@"171C27"];
    
    [self setUI];
    [self getProjectData];
}

#pragma mark ------ UI ------
- (void)setUI {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_market_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(repondsToRightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.stateView];
    [self.view addSubview:self.stateLabel];
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(21));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(STATUSBARHEIGHT + 44);
    }];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.stateView);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.stateView.mas_bottom);
        make.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6 + self.model.projectDesc.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section > 3 && section < 4 + self.model.projectDesc.count) {
        return [self.isExpansionArray[section - 4] isEqualToString:@"1"] ? 1 : 0;
    } else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    if (indexPath.section == 6 + self.model.projectDesc.count - 2) {
        // Twitter
        DBHInformationDetailForTwitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForTwitterTableViewCellIdentifier forIndexPath:indexPath];
        if (self.model) {
            cell.twitter = self.model.desc;
        }
        
        [cell clickTwitterBlock:^{
            KKWebView * vc = [[KKWebView alloc] initWithUrl:weakSelf.model.desc];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        return cell;
    } else if (indexPath.section == 6 + self.model.projectDesc.count - 1) {
        // Social
        DBHInformationDetailForMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForMoreTableViewCellIdentifier forIndexPath:indexPath];
        cell.dataSouce = [self.model.projectMedias copy];
        
        [cell clickMoreButtonBlock:^(NSString *url) {
            KKWebView * vc = [[KKWebView alloc] initWithUrl:url];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        return cell;
    } else {
        switch (indexPath.section) {
            case 0: {
                // 项目快讯
                DBHInformationDetailForProjectFlashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForProjectFlashTableViewCellIdentifier forIndexPath:indexPath];
                
                return cell;
                break;
            }
            case 1: {
                // 行情
                DBHInformationDetailForDealInfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForDealInfomationTableViewCellIdentifier forIndexPath:indexPath];
                if (self.model) {
                    cell.dataSource = [self.model.projectTimePrices copy];
                }
                
                return cell;
                break;
            }
            case 2: {
                // 交易市场
                DBHInformationDetailForTradingMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForTradingMarketTableViewCellIdentifier forIndexPath:indexPath];
                if (self.model) {
                    cell.dataSource = [self.tradingMarketArray copy];
                }
                
                return cell;
                break;
            }
            case 3: {
                // INWE报道
                DBHInformationDetailForInweReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForInweReportTableViewCellIdentifier forIndexPath:indexPath];
                cell.inweReportType = self.inweReportType;
                cell.dataSource = [self.inweReportArray copy];
                
                [cell selectInweTypeBlock:^(NSInteger inweType) {
                    weakSelf.inweReportType = inweType;
                    
                    [weakSelf getInweReportData];
                }];
                
                return cell;
                break;
            }
                
            default: {
                // 项目简介、团队介绍等
                DBHInformationDetailForProjectBriefTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForProjectBriefTableViewCellIdentifier forIndexPath:indexPath];
                if (self.model) {
                    cell.model = self.model.projectDesc[indexPath.section - 4];
                }
                
                return cell;
                break;
            }
        }
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section > 3 && section < 4 + self.model.projectDesc.count) {
        DBHInformationDetailHeaderButton *headerView = [DBHInformationDetailHeaderButton buttonWithType:UIButtonTypeCustom];
        headerView.tag = 196 + section;
        DBHInformationDetailModelProjectDesc *model = self.model.projectDesc[section - 4];
        headerView.leftTitle = model.title;
        [headerView addTarget:self action:@selector(respondsToHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
        
        return headerView;
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section > 3 && section < 4 + self.model.projectDesc.count ? AUTOLAYOUTSIZE(40.5) : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 6 + self.model.projectDesc.count - 1) {
        // Twitter
        return AUTOLAYOUTSIZE(345);
    } else if (indexPath.section == 6 + self.model.projectDesc.count) {
        // Social
        return AUTOLAYOUTSIZE(60);
    } else {
        switch (indexPath.section) {
            case 0: {
                // 项目快讯
                return AUTOLAYOUTSIZE(47);
                break;
            }
            case 1: {
                // 行情
                return AUTOLAYOUTSIZE(159);
                break;
            }
            case 2: {
                // 交易市场
                return AUTOLAYOUTSIZE(57) + (self.tradingMarketArray.count ? self.tradingMarketArray.count * AUTOLAYOUTSIZE(60) : AUTOLAYOUTSIZE(30));
                break;
            }
            case 3: {
                // INWE报道
                return AUTOLAYOUTSIZE(103.5) + (self.inweReportArray.count ? self.inweReportArray.count * AUTOLAYOUTSIZE(94) : AUTOLAYOUTSIZE(30));
                break;
            }
                
            default: {
                // 项目简介、团队介绍等
                return AUTOLAYOUTSIZE(155);
                break;
            }
        }
    }
}

#pragma mark ------ Data ------
/**
 获取项目详细数据
 */
- (void)getProjectData {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"project/%ld", (NSInteger)self.projectModel.dataIdentifier] isOtherBaseUrl:YES parameters:nil hudString:nil success:^(id responseObject) {
        weakSelf.model = [DBHInformationDetailModelData modelObjectWithDictionary:responseObject];
        
        [weakSelf.isExpansionArray removeAllObjects];
        for (NSInteger i = 0; i < self.model.projectDesc.count; i++) {
            [weakSelf.isExpansionArray addObject:@"0"];
        }
        
        [weakSelf.tableView reloadData];
        
        [weakSelf getTradeInformationData];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
/**
 获取市场交易信息数据
 */
- (void)getTradeInformationData {
    WEAKSELF
    DBHInformationDetailModelProjectMarkets *btcModel;
    for (DBHInformationDetailModelProjectMarkets *model in self.model.projectMarkets) {
        if ([model.enName isEqualToString:@"BTC"]) {
            btcModel = model;
        }
    }
    
    if (!btcModel) {
        return;
    }
    
    [PPNetworkHelper GET:btcModel.url isOtherBaseUrl:YES parameters:nil hudString:nil success:^(id responseObject) {
        [weakSelf.tradingMarketArray removeAllObjects];
        for (NSDictionary *dic in responseObject) {
            if (weakSelf.tradingMarketArray.count > 3) {
                break ;
            }

            DBHInformationDetailForTradingMarketContentModelData *model = [DBHInformationDetailForTradingMarketContentModelData modelObjectWithDictionary:dic];

            [weakSelf.tradingMarketArray addObject:model];
        }
        
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
/**
 获取INWE报道数据
 */
- (void)getInweReportData {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"category/%ld/articles/%@", (NSInteger)self.projectModel.dataIdentifier, self.inweReportType ? @"img-txt" : @"video"] isOtherBaseUrl:YES parameters:nil hudString:nil success:^(id responseObject) {
        [weakSelf.inweReportArray removeAllObjects];
        
        for (NSDictionary *dic in responseObject) {
            if (weakSelf.inweReportArray.count > 3) {
                break ;
            }
            
            DBHInformationDetailForInweModelData *model = [DBHInformationDetailForInweModelData modelObjectWithDictionary:dic];
            
            [weakSelf.inweReportArray addObject:model];
        }
        
        DBHInformationDetailForInweReportTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        cell.dataSource = [weakSelf.inweReportArray copy];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 右上角按钮
 */
- (void)repondsToRightBarButtonItem {
    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"161F26"]];
    [YCXMenu setTintColor:[UIColor colorWithHexString:@"161F26"]];
    [YCXMenu setTitleFont:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)]];
    [YCXMenu setSelectedColor:[UIColor colorWithHexString:@"161F26"]];
    [YCXMenu setselectedIndex:-1];
    if ([YCXMenu isShow])
    {
        [YCXMenu dismissMenu];
    }
    else
    {
        WEAKSELF
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item)
         {
             
             switch (index)
             {
                 case 0:
                 {
                     // 首页
                     [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                     
                     break;
                 }
                 case 1:
                 {
                     // 所有资讯
                     DBHAllInformationViewController *allInformationViewController;
                     for (UIViewController *vc in self.navigationController.viewControllers) {
                         if ([vc isKindOfClass:[DBHAllInformationViewController class]]) {
                             allInformationViewController = (DBHAllInformationViewController *)vc;
                             break;
                         }
                     }
                     
                     if (!allInformationViewController) {
                         allInformationViewController = [[DBHAllInformationViewController alloc] init];
                         [weakSelf.navigationController pushViewController:allInformationViewController animated:YES];
                     } else {
                         [weakSelf.navigationController popToViewController:allInformationViewController animated:YES];
                     }
                     
                     break;
                 }
                 case 2:
                 {
                     // Ico评测
                     DBHEvaluatingIcoViewController *evaluatingIcoViewController;
                     for (UIViewController *vc in self.navigationController.viewControllers) {
                         if ([vc isKindOfClass:[DBHEvaluatingIcoViewController class]]) {
                             evaluatingIcoViewController = (DBHEvaluatingIcoViewController *)vc;
                             break;
                         }
                     }
                     
                     if (!evaluatingIcoViewController) {
                         evaluatingIcoViewController = [[DBHEvaluatingIcoViewController alloc] init];
                         [weakSelf.navigationController pushViewController:evaluatingIcoViewController animated:YES];
                     } else {
                         [weakSelf.navigationController popToViewController:evaluatingIcoViewController animated:YES];
                     }
                     
                     break;
                 }
                 default:
                     break;
             }
         }];
    }
}
/**
 搜索
 */
- (void)respondsToSearchBarButton {
    DBHSearchViewController *searchViewController = [[DBHSearchViewController alloc] init];
    searchViewController.title = @"搜索项目";
    [self.navigationController pushViewController:searchViewController animated:YES];
}
/**
 收缩/展开
 */
- (void)respondsToHeaderButton:(DBHInformationDetailHeaderButton *)headerButton {
    [self.isExpansionArray replaceObjectAtIndex:headerButton.tag - 200 withObject:[self.isExpansionArray[headerButton.tag - 200] isEqualToString:@"1"] ? @"0" : @"1"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:headerButton.tag - 196] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark ------ Getters And Setters ------
- (void)setProjectModel:(DBHInformationForProjectCollectionModelData *)projectModel {
    _projectModel = projectModel;
    
    switch ((NSInteger)projectModel.type) {
        case 5: {
            // 已上线
            self.stateLabel.text = @"上线交易中";
            break;
        }
        case 6: {
            // 待上线
            self.stateLabel.text = @"待上线";
            break;
        }
        case 7: {
            // 众筹中
            NSMutableAttributedString *stateAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"众筹中%@", _projectModel.score]];
            [stateAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xFF3232, 1) range:NSMakeRange(3, _projectModel.score.length)];
            
            self.stateLabel.attributedText = stateAttributedString;
            break;
        }
        case 8: {
            // 即将众筹中
            NSMutableAttributedString *stateAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"即将众筹%@", _projectModel.score]];
            [stateAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xFF3232, 1) range:NSMakeRange(4, _projectModel.score.length)];
            
            self.stateLabel.attributedText = stateAttributedString;
            break;
        }
            
            
        default:
            break;
    }
}

- (UIView *)stateView {
    if (!_stateView) {
        _stateView = [[UIView alloc] init];
        _stateView.backgroundColor = COLORFROM16(0xFFFFFF, 1);
    }
    return _stateView;
}
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _stateLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _stateLabel;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLORFROM16(0xF2F2F2, 1);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = AUTOLAYOUTSIZE(8);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHInformationDetailForProjectFlashTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForProjectFlashTableViewCellIdentifier];
        [_tableView registerClass:[DBHInformationDetailForDealInfomationTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForDealInfomationTableViewCellIdentifier];
        [_tableView registerClass:[DBHInformationDetailForTradingMarketTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForTradingMarketTableViewCellIdentifier];
        [_tableView registerClass:[DBHInformationDetailForInweReportTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForInweReportTableViewCellIdentifier];
        [_tableView registerClass:[DBHInformationDetailForProjectBriefTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForProjectBriefTableViewCellIdentifier];
        [_tableView registerClass:[DBHInformationDetailForTwitterTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForTwitterTableViewCellIdentifier];
        [_tableView registerClass:[DBHInformationDetailForMoreTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForMoreTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)items
{
    if (!_items)
    {
        _items = [NSMutableArray array];
        
        YCXMenuItem *firstMenuItem = [YCXMenuItem menuItem:NSLocalizedString(@"Home page", nil)
                                                     image:nil
                                                       tag:100
                                                  userInfo:@{@"title":@"Menu"}];
        YCXMenuItem *secondMenuItem = [YCXMenuItem menuItem:NSLocalizedString(@"All the information", nil)
                                                      image:nil
                                                        tag:100
                                                   userInfo:@{@"title":@"Menu"}];
        YCXMenuItem *thirdMenuItem = [YCXMenuItem menuItem:NSLocalizedString(@"Business Project", nil)
                                                     image:nil
                                                       tag:101
                                                  userInfo:@{@"title":@"Menu"}];
        [firstMenuItem setForeColor:[UIColor colorWithHexString:@"97BDDB"]];
        [secondMenuItem setForeColor:[UIColor colorWithHexString:@"97BDDB"]];
        [thirdMenuItem setForeColor:[UIColor colorWithHexString:@"97BDDB"]];
        
        [_items addObject:firstMenuItem];
        [_items addObject:secondMenuItem];
        [_items addObject:thirdMenuItem];
    }
    return _items;
}
- (NSMutableArray *)tradingMarketArray {
    if (!_tradingMarketArray) {
        _tradingMarketArray = [NSMutableArray array];
    }
    return _tradingMarketArray;
}
- (NSMutableArray *)isExpansionArray {
    if (!_isExpansionArray) {
        _isExpansionArray = [NSMutableArray array];
    }
    return _isExpansionArray;
}

@end
