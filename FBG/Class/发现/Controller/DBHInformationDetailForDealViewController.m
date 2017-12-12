//
//  DBHInformationDetailViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForDealViewController.h"

#import "YCXMenu.h"

#import "DBHAllInformationViewController.h"
#import "DBHEvaluatingIcoViewController.h"
#import "DBHSearchViewController.h"
#import "KKWebView.h"

#import "DBHSearchBarButton.h"
#import "DBHInformationDetailForDealInfomationTableViewCell.h"
#import "DBHInformationDetailForDealInfomationChartTableViewCell.h"
#import "DBHInformationDetailForTradingMarketTableViewCell.h"
#import "DBHInformationDetailForProjectBriefTableViewCell.h"
#import "DBHInformationDetailForInweReportTableViewCell.h"
#import "DBHInformationDetailForExplorerAndWalletTableViewCell.h"
#import "DBHInformationDetailForTwitterTableViewCell.h"
#import "DBHInformationDetailForMoreTableViewCell.h"

#import "DBHInformationForProjectCollectionModelData.h"
#import "DBHInformationDetailDataModels.h"
#import "DBHInformationDetailForInweDataModels.h"

static NSString *const kDBHInformationDetailForDealInfomationTableViewCellIdentifier = @"kDBHInformationDetailForDealInfomationTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForDealInfomationChartTableViewCellIdentifier = @"kDBHInformationDetailForDealInfomationChartTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForTradingMarketTableViewCellIdentifier = @"kDBHInformationDetailForTradingMarketTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForProjectBriefTableViewCellIdentifier = @"kDBHInformationDetailForProjectBriefTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForInweReportTableViewCellIdentifier = @"kDBHInformationDetailForInweReportTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForExplorerAndWalletTableViewCellIdentifier = @"kDBHInformationDetailForExplorerAndWalletTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForTwitterTableViewCellIdentifier = @"kDBHInformationDetailForTwitterTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForMoreTableViewCellIdentifier = @"kDBHInformationDetailForMoreTableViewCellIdentifier";

@interface DBHInformationDetailForDealViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DBHSearchBarButton *searchBarButton;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) DBHInformationDetailModelData *model;
@property (nonatomic, assign) NSInteger inweReportType; // 0:视频 1:图文
@property (nonatomic, strong) NSMutableArray * inweReportArray; // INWE报道
@property (nonatomic, strong) NSMutableArray * items;

@end

@implementation DBHInformationDetailForDealViewController

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
    
    [self.view addSubview:self.searchBarButton];
    [self.view addSubview:self.stateLabel];
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.commentButton];
    
    WEAKSELF
    [self.searchBarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(24));
        make.height.offset(AUTOLAYOUTSIZE(32.5));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(5));
    }];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.searchBarButton.mas_bottom);
        make.bottom.equalTo(weakSelf.tableView.mas_top);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.searchBarButton.mas_bottom).offset(AUTOLAYOUTSIZE(22));
        make.bottom.equalTo(weakSelf.view);
    }];
//    [self.commentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.view);
//        make.centerY.equalTo(weakSelf.view).multipliedBy(1.8);
//    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    switch (indexPath.row) {
        case 0: {
            DBHInformationDetailForDealInfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForDealInfomationTableViewCellIdentifier forIndexPath:indexPath];
            if (self.model) {
                cell.dataSource = [self.model.projectTimePrices copy];
            }
            
            return cell;
            break;
        }
//        case 1: {
//            DBHInformationDetailForDealInfomationChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForDealInfomationChartTableViewCellIdentifier forIndexPath:indexPath];
//
//            return cell;
//            break;
//        }
        case 1: {
            DBHInformationDetailForTradingMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForTradingMarketTableViewCellIdentifier forIndexPath:indexPath];
//            if (self.model) {
//                cell.currencyTypeArray = [self.model.projectMarkets copy];
//            }
            
            return cell;
            break;
        }
        case 2: {
            DBHInformationDetailForProjectBriefTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForProjectBriefTableViewCellIdentifier forIndexPath:indexPath];
//            if (self.model) {
//                cell.projectIntroductionArray = [self.model.projectDesc copy];
//            }
            
            return cell;
            break;
        }
        case 3: {
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
        case 4: {
            DBHInformationDetailForExplorerAndWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForExplorerAndWalletTableViewCellIdentifier forIndexPath:indexPath];
            cell.leftDataSource = [self.model.projectExplorers copy];
            cell.rightDataSource = [self.model.projectWallets copy];
            
            [cell clickExplorerOrWalletBlock:^(NSString *url) {
                KKWebView * vc = [[KKWebView alloc] initWithUrl:url];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            
            return cell;
            break;
        }
        case 5: {
            DBHInformationDetailForTwitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForTwitterTableViewCellIdentifier forIndexPath:indexPath];
            if (self.model) {
                cell.twitter = self.model.desc;
            }
            
            [cell clickTwitterBlock:^{
                KKWebView * vc = [[KKWebView alloc] initWithUrl:weakSelf.model.desc];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            
            return cell;
            break;
        }
            
            
        default: {
            DBHInformationDetailForMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForMoreTableViewCellIdentifier forIndexPath:indexPath];
            cell.dataSouce = [self.model.projectMedias copy];
            
            [cell clickMoreButtonBlock:^(NSString *url) {
                KKWebView * vc = [[KKWebView alloc] initWithUrl:url];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            
            return cell;
            break;
        }
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return AUTOLAYOUTSIZE(255);
            break;
//        case 1:
//            return AUTOLAYOUTSIZE(215);
//            break;
        case 1:
            return AUTOLAYOUTSIZE(183);
            break;
        case 2:
            return AUTOLAYOUTSIZE(184);
            break;
        case 3:
            return AUTOLAYOUTSIZE(437);
            break;
        case 4:
            return AUTOLAYOUTSIZE(147);
            break;
        case 5:
            return AUTOLAYOUTSIZE(203.5);
            break;
            
        default:
            return AUTOLAYOUTSIZE(37) + ceilf((self.model.projectMedias.count ? self.model.projectMedias.count : 1) / 6.0) * AUTOLAYOUTSIZE(52.5);
            break;
    }
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    UIPanGestureRecognizer *panGR = scrollView.panGestureRecognizer;
    CGFloat velocity = [panGR velocityInView:scrollView].y;
    
    if (velocity >= -15 && velocity <= 15) {
        return;
    }
    
    WEAKSELF
    [self.searchBarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(24));
        make.height.offset(AUTOLAYOUTSIZE(32.5));
        make.centerX.equalTo(weakSelf.view);
        if (velocity < - 15) {
            make.top.offset(- AUTOLAYOUTSIZE(59.5));
        } else if (velocity > 15) {
            make.top.offset(AUTOLAYOUTSIZE(5));
        }
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

#pragma mark ------ Data ------
/**
 获取项目详细数据
 */
- (void)getProjectData {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"project/%ld", (NSInteger)self.projectModel.dataIdentifier] isOtherBaseUrl:YES parameters:nil hudString:nil success:^(id responseObject) {
        weakSelf.model = [DBHInformationDetailModelData modelObjectWithDictionary:responseObject];
        
        [weakSelf.tableView reloadData];
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
            DBHInformationDetailForInweModelData *model = [DBHInformationDetailForInweModelData modelObjectWithDictionary:dic];
            
            [weakSelf.inweReportArray addObject:model];
        }
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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
 评论
 */
- (void)repondsToCommentButton {
    
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

- (DBHSearchBarButton *)searchBarButton {
    if (!_searchBarButton) {
        _searchBarButton = [DBHSearchBarButton buttonWithType:UIButtonTypeCustom];
        _searchBarButton.title = @"搜索项目";
        [_searchBarButton addTarget:self action:@selector(respondsToSearchBarButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBarButton;
}
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _stateLabel.textColor = [UIColor colorWithHexString:@"97BDDB"];
    }
    return _stateLabel;
}
- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BG"]];
    }
    return _backImageView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundView = self.backImageView;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHInformationDetailForDealInfomationTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForDealInfomationTableViewCellIdentifier];
        [_tableView registerClass:[DBHInformationDetailForDealInfomationChartTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForDealInfomationChartTableViewCellIdentifier];
        [_tableView registerClass:[DBHInformationDetailForTradingMarketTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForTradingMarketTableViewCellIdentifier];
        [_tableView registerClass:[DBHInformationDetailForProjectBriefTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForProjectBriefTableViewCellIdentifier];
        [_tableView registerClass:[DBHInformationDetailForInweReportTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForInweReportTableViewCellIdentifier];
        [_tableView registerClass:[DBHInformationDetailForExplorerAndWalletTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForExplorerAndWalletTableViewCellIdentifier];
        [_tableView registerClass:[DBHInformationDetailForTwitterTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForTwitterTableViewCellIdentifier];
        [_tableView registerClass:[DBHInformationDetailForMoreTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForMoreTableViewCellIdentifier];
    }
    return _tableView;
}
- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImage:[UIImage imageNamed:@"button_messige"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(repondsToCommentButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
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
- (NSMutableArray *)inweReportArray {
    if (!_inweReportArray) {
        _inweReportArray = [NSMutableArray array];
    }
    return _inweReportArray;
}

@end
