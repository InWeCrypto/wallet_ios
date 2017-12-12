//
//  DBHInformationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationViewController.h"

#import "YCXMenu.h"
#import "AC_WaterCollectionViewLayout.h"
#import "MXNavigationBarManager.h"

#import "KKWebView.h"
#import "DBHInformationDetailForOnLineAfterViewController.h"
#import "DBHInformationDetailForDealViewController.h"
#import "DBHInformationDetailForCrowdfundingViewController.h"
#import "DBHAllInformationViewController.h"
#import "DBHEvaluatingIcoViewController.h"
#import "DBHSearchViewController.h"

#import "DBHInformationHeaderCollectionReusableView.h"
#import "DBHInformationForRoastingChartCollectionViewCell.h"
#import "DBHInformationForNewsCollectionViewCell.h"
#import "DBHInformationForProjectCollectionViewCell.h"

#import "DBHInformationForRoastingChartCollectionDataModels.h"
#import "DBHInformationForNewsCollectionDataModels.h"
#import "DBHInformationForProjectCollectionDataModels.h"
#import "DBHInformationForMoneyConditionDataModels.h"

#import "MJRefresh.h"

static NSString * const kDBHInformationHeaderCollectionReusableViewIdentifier = @"kDBHInformationHeaderCollectionReusableViewIdentifier";
static NSString * const kDBHInformationForRoastingChartCollectionViewCellIdentifier = @"kDBHInformationForRoastingChartCollectionViewCellIdentifier";
static NSString * const kDBHInformationForNewsCollectionViewCellIdentifier = @"kDBHInformationForNewsCollectionViewCellIdentifier";
static NSString * const kDBHInformationForProjectCollectionViewCellIdentifier = @"kDBHInformationForProjectCollectionViewCellIdentifier";

@interface DBHInformationViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, AC_WaterCollectionViewLayoutDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) DBHInformationHeaderCollectionReusableView *headerView;
@property (nonatomic, strong) AC_WaterCollectionViewLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *barImageView;

@property (nonatomic, assign) NSInteger requestCount; // 请求数量
@property (nonatomic, assign) BOOL isHideSearchBar; // 是否隐藏搜索栏
@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) NSMutableArray *roastingChartCollectionArray; // 轮播图数据
@property (nonatomic, strong) NSMutableArray *newsArray; // 新闻数据
@property (nonatomic, strong) NSMutableArray *projectArray; // 项目数据
@property (nonatomic, strong) NSMutableArray *moneyConditionArray; // 货币情况数据
//@property (nonatomic, strong) NSMutableArray *isBackSideArray; // 是否翻面

@end

@implementation DBHInformationViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:COLORFROM16(0xffffff, 0) Rect:CGRectMake(0, 0, SCREEN_WIDTH, 44 + STATUS_HEIGHT)]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self setUI];
    [self addRefresh];
    
    [self getRoastingChartData];
    [self getNewsData];
    [self getProjectData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initBarManager];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MXNavigationBarManager changeAlphaWithCurrentOffset:AUTOLAYOUTSIZE(100)];
}

#pragma mark ------ UI ------
- (void)setUI {
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_market_search"] style:UIBarButtonItemStylePlain target:self action:@selector(repondsToSearchBarButtonItem)];
    UIBarButtonItem *moreBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_market_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(repondsToRightBarButtonItem)];
    self.navigationItem.rightBarButtonItems = @[moreBarButtonItem, searchBarButtonItem];

    [self.view addSubview:self.collectionView];

    WEAKSELF
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(- (44 + STATUSBARHEIGHT));
    }];
}
- (void)initBarManager {
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:[UIColor whiteColor]];
//    [MXNavigationBarManager setTintColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1]];
    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
    [MXNavigationBarManager setZeroAlphaOffset:-20 - STATUS_HEIGHT];
    [MXNavigationBarManager setFullAlphaOffset:AUTOLAYOUTSIZE(100)];
//    [MXNavigationBarManager setFullAlphaTintColor:[UIColor whiteColor]];
    [MXNavigationBarManager setFullAlphaBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark ------ UICollectionViewDataSource ------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.projectArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
//    if (!indexPath.section) {
//        if (!indexPath.row) {
//            DBHInformationForRoastingChartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDBHInformationForRoastingChartCollectionViewCellIdentifier forIndexPath:indexPath];
//            cell.dataSource = [self.roastingChartCollectionArray copy];
//
//            [cell clickRoastingChartBlock:^(NSInteger clickRoastingChartBlockIndex) {
//                // 点击轮播图回调
//                DBHInformationForRoastingChartCollectionModelList *model = weakSelf.roastingChartCollectionArray[clickRoastingChartBlockIndex];
//
//                NSString *url;
//                if ([model.url containsString:@"http"]) {
//                    url = model.url;
//                } else {
//                    url = [NSString stringWithFormat:@"https://dev.inwecrypto.com/%@", model.url];
//                }
//
//                KKWebView * vc = [[KKWebView alloc] initWithUrl:url];
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//            }];
//
//            return cell;
//        } else {
//            DBHInformationForNewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDBHInformationForNewsCollectionViewCellIdentifier forIndexPath:indexPath];
//            cell.dataSource = [self.newsArray copy];
//
//            [cell clickNewsBlock:^(NSString *url) {
//                // 点击新闻回调
//                KKWebView * vc = [[KKWebView alloc] initWithUrl:url];
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//            }];
//
//            return cell;
//        }
//    } else {
        DBHInformationForProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDBHInformationForProjectCollectionViewCellIdentifier forIndexPath:indexPath];
//        cell.isBackSide = [self.isBackSideArray[indexPath.row] isEqualToString:@"1"];
        cell.model = self.projectArray[indexPath.row];
//        if (![self.moneyConditionArray[indexPath.row] isKindOfClass:[NSString class]]) {
//            cell.moneyModel = self.moneyConditionArray[indexPath.row];
//        }

//        [cell backSideBlock:^{
//            [weakSelf.isBackSideArray replaceObjectAtIndex:indexPath.row withObject:!cell.isBackSide ? @"1" : @"0"];
//
//            if (!cell.isBackSide) {
//                [weakSelf getMoneyConditionDataWithRow:indexPath.row];
//            }
//        }];
    
        return cell;
//    }
}

#pragma mark ------ UICollectionViewDelegate ------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationForProjectCollectionModelData *model = self.projectArray[indexPath.row];
    if (!indexPath.row/*model.type == 5 || model.type == 6*/) {
        DBHInformationDetailForOnLineAfterViewController *informationDetailForOnLineAfterViewController = [[DBHInformationDetailForOnLineAfterViewController alloc] init];
        informationDetailForOnLineAfterViewController.projectModel = model;
        [self.navigationController pushViewController:informationDetailForOnLineAfterViewController animated:YES];
    } else {
        DBHInformationDetailForCrowdfundingViewController *informationDetailForCrowdfundingViewController = [[DBHInformationDetailForCrowdfundingViewController alloc] init];
        informationDetailForCrowdfundingViewController.projectModel = model;
        [self.navigationController pushViewController:informationDetailForCrowdfundingViewController animated:YES];
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:AC_UICollectionElementKindSectionHeader]) {
        return self.headerView;
    }
    return nil;
}

#pragma mark ------ AC_WaterCollectionViewLayoutDelegate ------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AC_WaterCollectionViewLayout *)layout widthOfItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (!indexPath.section) {
//        return SCREEN_WIDTH;
//    } else {
        DBHInformationForProjectCollectionModelData *model = self.projectArray[indexPath.row];
        return model.gridType == 4 ? SCREEN_WIDTH * 0.5 - AUTOLAYOUTSIZE(4.5) : (SCREEN_WIDTH * 0.5 - AUTOLAYOUTSIZE(4.5)) * 0.5 - AUTOLAYOUTSIZE(1.5);
//    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AC_WaterCollectionViewLayout *)layout heightOfItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
//    if (!indexPath.section) {
//        return !indexPath.row ? AUTOLAYOUTSIZE(176.5) : AUTOLAYOUTSIZE(78.5);
////        return CGSizeMake(SCREEN_WIDTH, !indexPath.row ? AUTOLAYOUTSIZE(176.5) : AUTOLAYOUTSIZE(78.5));
//    } else {
        DBHInformationForProjectCollectionModelData *model = self.projectArray[indexPath.row];
        return model.gridType == 4 ? SCREEN_WIDTH * 0.5 - AUTOLAYOUTSIZE(4.5) : (SCREEN_WIDTH * 0.5 - AUTOLAYOUTSIZE(4.5)) * 0.5 - AUTOLAYOUTSIZE(1.5);
//        if (model.gridType == 4) {
//            return CGSizeMake(SCREEN_WIDTH * 0.5 - AUTOLAYOUTSIZE(4.5), SCREEN_WIDTH * 0.5 - AUTOLAYOUTSIZE(4.5));
//        } else {
//            return CGSizeMake((SCREEN_WIDTH * 0.5 - AUTOLAYOUTSIZE(4.5)) * 0.5 - AUTOLAYOUTSIZE(1.5), (SCREEN_WIDTH * 0.5 - AUTOLAYOUTSIZE(4.5)) * 0.5 - AUTOLAYOUTSIZE(1.5));
//        }
//    }
}

#pragma mark ------ UICollectionViewDelegateFlowLayout ------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return CGSizeMake(SCREEN_WIDTH, !indexPath.row ? AUTOLAYOUTSIZE(176.5) : AUTOLAYOUTSIZE(78.5));
    } else {
        DBHInformationForProjectCollectionModelData *model = self.projectArray[indexPath.row];
        if (model.gridType == 4) {
            return CGSizeMake(SCREEN_WIDTH * 0.5 - AUTOLAYOUTSIZE(4.5), SCREEN_WIDTH * 0.5 - AUTOLAYOUTSIZE(4.5));
        } else {
            return CGSizeMake((SCREEN_WIDTH * 0.5 - AUTOLAYOUTSIZE(4.5)) * 0.5 - AUTOLAYOUTSIZE(1.5), (SCREEN_WIDTH * 0.5 - AUTOLAYOUTSIZE(4.5)) * 0.5 - AUTOLAYOUTSIZE(1.5));
        }
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (!section) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        return UIEdgeInsetsMake(AUTOLAYOUTSIZE(3), AUTOLAYOUTSIZE(3), AUTOLAYOUTSIZE(3), AUTOLAYOUTSIZE(3));
    }
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [MXNavigationBarManager changeAlphaWithCurrentOffset:scrollView.contentOffset.y];
}

#pragma mark ------ Data ------
/**
 获取轮播图数据
 */
- (void)getRoastingChartData {
    WEAKSELF
    [PPNetworkHelper GET:@"home/ad" isOtherBaseUrl:YES parameters:nil hudString:@"" success:^(id responseObject) {
        [weakSelf.roastingChartCollectionArray removeAllObjects];
        for (NSDictionary *dic in responseObject[@"list"]) {
            DBHInformationForRoastingChartCollectionModelList *model = [DBHInformationForRoastingChartCollectionModelList modelObjectWithDictionary:dic];
            
            [weakSelf.roastingChartCollectionArray addObject:model];
        }
        
        [weakSelf endRefresh];
        
        self.headerView.dataSource = [weakSelf.roastingChartCollectionArray copy];
//        [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    }];
}
/**
 获取新闻数据
 */
- (void)getNewsData {
    WEAKSELF
    [PPNetworkHelper GET:@"home/news" isOtherBaseUrl:YES parameters:nil hudString:@"" success:^(id responseObject) {
        [weakSelf.newsArray removeAllObjects];
        for (NSDictionary *dic in responseObject) {
            DBHInformationForNewsCollectionModelData *model = [DBHInformationForNewsCollectionModelData modelObjectWithDictionary:dic];
            
            [weakSelf.newsArray addObject:model];
        }
        
        [weakSelf endRefresh];
        
        weakSelf.headerView.newsDataSource = [weakSelf.newsArray copy];
//        [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    }];
}
/**
 获取项目数据
 */
- (void)getProjectData {
    WEAKSELF
    [PPNetworkHelper GET:@"home/project/is_mobile" isOtherBaseUrl:YES parameters:nil hudString:@"" success:^(id responseObject) {
        [weakSelf.projectArray removeAllObjects];
        [weakSelf.moneyConditionArray removeAllObjects];
//        [weakSelf.isBackSideArray removeAllObjects];
        
        NSArray *dataArray = responseObject;
        NSInteger tag = 0;
        NSMutableArray *centerArray = [NSMutableArray array];
        for (NSInteger i = 0; i < dataArray.count; i++) {
            NSDictionary *dic = dataArray[i];
            DBHInformationForProjectCollectionModelData *model = [DBHInformationForProjectCollectionModelData modelObjectWithDictionary:dic];
            
            if (model.gridType != 4) {
                if (!centerArray.count) {
                    tag = i;
                }
                
                [centerArray addObject:model];
                
                if (centerArray.count == 4) {
                    [weakSelf.projectArray insertObjects:[centerArray copy] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(tag, 4)]];
                    [centerArray removeAllObjects];
                }
            } else {
                [weakSelf.projectArray addObject:model];
            }
        }
        
        if (centerArray.count) {
            [weakSelf.projectArray insertObjects:[centerArray copy] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(tag, centerArray.count)]];
        }
        
        [weakSelf endRefresh];
        
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    }];
}
/**
 获取货币情况数据
 */
- (void)getMoneyConditionDataWithRow:(NSInteger)row {
    WEAKSELF
    DBHInformationForProjectCollectionModelData *model = self.projectArray[row];
    
    [PPNetworkHelper GET:model.url isOtherBaseUrl:YES parameters:nil hudString:@"" success:^(id responseObject) {
        DBHInformationForMoneyConditionModelData *model = [DBHInformationForMoneyConditionModelData modelObjectWithDictionary:responseObject];
        
        [weakSelf.moneyConditionArray replaceObjectAtIndex:row withObject:model];
        
        DBHInformationForProjectCollectionViewCell *cell = (DBHInformationForProjectCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:1]];
        cell.moneyModel = model;
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 更多选项
 */
- (void)repondsToRightBarButtonItem {
    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"D2D2D2"]];
    [YCXMenu setTintColor:[UIColor colorWithHexString:@"FFFFFF"]];
    [YCXMenu setTitleFont:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)]];
    [YCXMenu setSelectedColor:[UIColor colorWithHexString:@"FFFFFF"]];
    [YCXMenu setselectedIndex:-1];
    if ([YCXMenu isShow])
    {
        [YCXMenu dismissMenu];
    }
    else
    {
        WEAKSELF
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(SCREEN_WIDTH - 50, STATUSBARHEIGHT + 44, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item)
         {
             
             switch (index)
             {
                 case 0:
                 {
                     // 项目精品
                     DBHEvaluatingIcoViewController *evaluatingIcoViewController = [[DBHEvaluatingIcoViewController alloc] init];
                     [weakSelf.navigationController pushViewController:evaluatingIcoViewController animated:YES];
                     
                     break;
                 }
                 case 1:
                 {
                     // 所有资讯
                     DBHAllInformationViewController *allInformationViewController = [[DBHAllInformationViewController alloc] init];
                     [weakSelf.navigationController pushViewController:allInformationViewController animated:YES];
                     
                     break;
                 }
                     
                 default: {
                    // 糖果盒
                     
                     break;
                 }
             }
         }];
    }
}
/**
 搜索
 */
- (void)repondsToSearchBarButtonItem {
    DBHSearchViewController *searchViewController = [[DBHSearchViewController alloc] init];
    searchViewController.title = @"搜索项目";
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark ------ Private Methods ------
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.requestCount = 0;
        [weakSelf getRoastingChartData];
        [weakSelf getNewsData];
        [weakSelf getProjectData];
    }];
}
/**
 结束刷新
 */
- (void)endRefresh {
    self.requestCount += 1;
    if (self.requestCount < 3) {
        return;
    }
    
    if (self.collectionView.mj_header.refreshing) {
        [self.collectionView.mj_header endRefreshing];
    }
}

#pragma mark ------ Getters And Setters ------
- (AC_WaterCollectionViewLayout *)layout {
    if (!_layout) {
        _layout = [[AC_WaterCollectionViewLayout alloc] init];
        _layout.numberOfColumns = 2;
        _layout.cellDistance = AUTOLAYOUTSIZE(3);
        _layout.delegate = self;
        _layout.headerViewHeight = AUTOLAYOUTSIZE(255);
    }
    return _layout;
}
- (DBHInformationHeaderCollectionReusableView *)headerView {
    if (!_headerView) {
        _headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:AC_UICollectionElementKindSectionHeader withReuseIdentifier:kDBHInformationHeaderCollectionReusableViewIdentifier forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        WEAKSELF
        [_headerView clickRoastingChartBlock:^(NSInteger clickRoastingChartBlockIndex) {
            // 点击轮播图回调
            DBHInformationForRoastingChartCollectionModelList *model = weakSelf.roastingChartCollectionArray[clickRoastingChartBlockIndex];
            
            NSString *url;
            if ([model.url containsString:@"http"]) {
                url = model.url;
            } else {
                url = [NSString stringWithFormat:@"https://dev.inwecrypto.com/%@", model.url];
            }
            
            KKWebView * vc = [[KKWebView alloc] initWithUrl:url];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [_headerView clickNewsBlock:^(NSString *url) {
            // 点击新闻回调
            KKWebView * vc = [[KKWebView alloc] initWithUrl:url];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _headerView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[DBHInformationHeaderCollectionReusableView class] forSupplementaryViewOfKind:AC_UICollectionElementKindSectionHeader withReuseIdentifier:kDBHInformationHeaderCollectionReusableViewIdentifier];
        [_collectionView registerClass:[DBHInformationForRoastingChartCollectionViewCell class] forCellWithReuseIdentifier:kDBHInformationForRoastingChartCollectionViewCellIdentifier];
        [_collectionView registerClass:[DBHInformationForNewsCollectionViewCell class] forCellWithReuseIdentifier:kDBHInformationForNewsCollectionViewCellIdentifier];
        [_collectionView registerClass:[DBHInformationForProjectCollectionViewCell class] forCellWithReuseIdentifier:kDBHInformationForProjectCollectionViewCellIdentifier];
    }
    return _collectionView;
}
- (UIImageView *)barImageView {
    if (!_barImageView) {
        _barImageView = self.navigationController.navigationBar.subviews.firstObject;
        _barImageView.alpha = 0;
    }
    return _barImageView;
}

- (NSMutableArray *)items
{
    if (!_items)
    {
        _items = [NSMutableArray array];
        
        YCXMenuItem *firstMenuItem = [YCXMenuItem menuItem:NSLocalizedString(@"Business Project", nil)
                                          image:nil
                                            tag:100
                                       userInfo:@{@"title":@"Menu"}];
        YCXMenuItem *secondMenuItem = [YCXMenuItem menuItem:NSLocalizedString(@"All the information", nil)
                                                      image:nil
                                                        tag:101
                                                   userInfo:@{@"title":@"Menu"}];
//        YCXMenuItem *thirdMenuItem = [YCXMenuItem menuItem:NSLocalizedString(@"Bonbonniere", nil)
//                                                      image:nil
//                                                        tag:102
//                                                   userInfo:@{@"title":@"Menu"}];
        [firstMenuItem setForeColor:[UIColor colorWithHexString:@"3F3F3F"]];
        [secondMenuItem setForeColor:[UIColor colorWithHexString:@"3F3F3F"]];
//        [thirdMenuItem setForeColor:[UIColor colorWithHexString:@"3F3F3F"]];
        
        [_items addObject:firstMenuItem];
        [_items addObject:secondMenuItem];
//        [_items addObject:thirdMenuItem];
    }
    return _items;
}
- (NSMutableArray *)roastingChartCollectionArray {
    if (!_roastingChartCollectionArray) {
        _roastingChartCollectionArray = [NSMutableArray array];
    }
    return _roastingChartCollectionArray;
}
- (NSMutableArray *)newsArray {
    if (!_newsArray) {
        _newsArray = [NSMutableArray array];
    }
    return _newsArray;
}
- (NSMutableArray *)projectArray {
    if (!_projectArray) {
        _projectArray = [NSMutableArray array];
    }
    return _projectArray;
}
- (NSMutableArray *)moneyConditionArray {
    if (!_moneyConditionArray) {
        _moneyConditionArray = [NSMutableArray array];
    }
    return _moneyConditionArray;
}
//- (NSMutableArray *)isBackSideArray {
//    if (!_isBackSideArray) {
//        _isBackSideArray = [NSMutableArray array];
//    }
//    return _isBackSideArray;
//}

@end
