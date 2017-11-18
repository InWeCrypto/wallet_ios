//
//  DBHInformationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationViewController.h"

#import "YCXMenu.h"

#import "DBHInformationDetailForDealViewController.h"
#import "DBHInformationDetailForCrowdfundingViewController.h"
#import "DBHAllInformationViewController.h"
#import "DBHEvaluatingIcoViewController.h"

#import "DBHSearchBarButton.h"
#import "DBHInformationForRoastingChartCollectionViewCell.h"
#import "DBHInformationForNewsCollectionViewCell.h"
#import "DBHInformationForProjectCollectionViewCell.h"

#import "DBHInformationForRoastingChartCollectionDataModels.h"
#import "DBHInformationForNewsCollectionDataModels.h"
#import "DBHInformationForProjectCollectionDataModels.h"
#import "DBHInformationForMoneyConditionDataModels.h"

static NSString * const kDBHInformationForRoastingChartCollectionViewCellIdentifier = @"kDBHInformationForRoastingChartCollectionViewCellIdentifier";
static NSString * const kDBHInformationForNewsCollectionViewCellIdentifier = @"kDBHInformationForNewsCollectionViewCellIdentifier";
static NSString * const kDBHInformationForProjectCollectionViewCellIdentifier = @"kDBHInformationForProjectCollectionViewCellIdentifier";

@interface DBHInformationViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) DBHSearchBarButton *searchBarButton;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isHideSearchBar; // 是否隐藏搜索栏
@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) NSMutableArray *roastingChartCollectionArray; // 轮播图数据
@property (nonatomic, strong) NSMutableArray *newsArray; // 新闻数据
@property (nonatomic, strong) NSMutableArray *projectArray; // 项目数据
@property (nonatomic, strong) NSMutableArray *moneyConditionArray; // 货币情况数据
@property (nonatomic, strong) NSMutableArray *isBackSideArray; // 是否翻面

@end

@implementation DBHInformationViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"171C27"];
    
    [self setUI];
    
    [self getRoastingChartData];
    [self getNewsData];
    [self getProjectData];
}

#pragma mark ------ UI ------
- (void)setUI {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_market_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(repondsToRightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.searchBarButton];
    [self.view addSubview:self.collectionView];
    
    WEAKSELF
    [self.searchBarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(24));
        make.height.offset(AUTOLAYOUTSIZE(32.5));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(5));
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.searchBarButton.mas_bottom).offset(AUTOLAYOUTSIZE(5));
        make.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UICollectionViewDataSource ------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return !section ? 2 : self.projectArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    if (!indexPath.section) {
        if (!indexPath.row) {
            DBHInformationForRoastingChartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDBHInformationForRoastingChartCollectionViewCellIdentifier forIndexPath:indexPath];
            cell.dataSource = [self.roastingChartCollectionArray copy];
            
            return cell;
        } else {
            DBHInformationForNewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDBHInformationForNewsCollectionViewCellIdentifier forIndexPath:indexPath];
            cell.dataSource = [self.newsArray copy];
            
            [cell clickMoreButtonBlock:^{
                // 所有资讯
                DBHAllInformationViewController *allInformationViewController = [[DBHAllInformationViewController alloc] init];
                [weakSelf.navigationController pushViewController:allInformationViewController animated:YES];
            }];
            
            return cell;
        }
    } else {
        DBHInformationForProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDBHInformationForProjectCollectionViewCellIdentifier forIndexPath:indexPath];
        cell.isBackSide = [self.isBackSideArray[indexPath.row] isEqualToString:@"1"];
        cell.model = self.projectArray[indexPath.row];
        if (![self.moneyConditionArray[indexPath.row] isKindOfClass:[NSString class]]) {
            cell.moneyModel = self.moneyConditionArray[indexPath.row];
        }
        
        [cell backSideBlock:^{
            [weakSelf.isBackSideArray replaceObjectAtIndex:indexPath.row withObject:!cell.isBackSide ? @"1" : @"0"];
            
            if (!cell.isBackSide) {
                [weakSelf getMoneyConditionDataWithRow:indexPath.row];
            }
        }];
        
        return cell;
    }
}

#pragma mark ------ UICollectionViewDelegate ------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        DBHInformationForProjectCollectionModelData *model = self.projectArray[indexPath.row];
        if (model.type == 5) {
            DBHInformationDetailForDealViewController *informationDetailForDealViewController = [[DBHInformationDetailForDealViewController alloc] init];
            informationDetailForDealViewController.projectModel = model;
            [self.navigationController pushViewController:informationDetailForDealViewController animated:YES];
        } else {
            DBHInformationDetailForCrowdfundingViewController *informationDetailForCrowdfundingViewController = [[DBHInformationDetailForCrowdfundingViewController alloc] init];
            informationDetailForCrowdfundingViewController.projectModel = model;
            [self.navigationController pushViewController:informationDetailForCrowdfundingViewController animated:YES];
        }
    }
}

#pragma mark ------ UICollectionViewDelegateFlowLayout ------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return CGSizeMake(SCREEN_WIDTH, !indexPath.row ? AUTOLAYOUTSIZE(153.5) : AUTOLAYOUTSIZE(107.5));
    } else {
        DBHInformationForProjectCollectionModelData *model = self.projectArray[indexPath.row];
        switch ((NSInteger)model.gridType) {
            case 1:
                return CGSizeMake(SCREEN_WIDTH * 0.5 - AUTOLAYOUTSIZE(18), AUTOLAYOUTSIZE(170));
                break;
            case 2:
            case 3:
                return CGSizeMake(SCREEN_WIDTH - AUTOLAYOUTSIZE(23), AUTOLAYOUTSIZE(170));
                break;
                
            default:
                return CGSizeMake(SCREEN_WIDTH - AUTOLAYOUTSIZE(23), AUTOLAYOUTSIZE(340));
                break;
        }
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (!section) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        return UIEdgeInsetsMake(AUTOLAYOUTSIZE(12), AUTOLAYOUTSIZE(11.5), AUTOLAYOUTSIZE(12), AUTOLAYOUTSIZE(11.5));
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
 获取轮播图数据
 */
- (void)getRoastingChartData {
    WEAKSELF
    [PPNetworkHelper GET:@"https://dev.inwecrypto.com/home/ad" parameters:nil hudString:@"" success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[@"list"]) {
            DBHInformationForRoastingChartCollectionList *model = [DBHInformationForRoastingChartCollectionList modelObjectWithDictionary:dic];
            
            [weakSelf.roastingChartCollectionArray addObject:model];
        }
        
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
/**
 获取新闻数据
 */
- (void)getNewsData {
    WEAKSELF
    [PPNetworkHelper GET:@"https://dev.inwecrypto.com/home/news" parameters:nil hudString:@"" success:^(id responseObject) {
        for (NSDictionary *dic in responseObject) {
            DBHInformationForNewsCollectionData *model = [DBHInformationForNewsCollectionData modelObjectWithDictionary:dic];
            
            [weakSelf.newsArray addObject:model];
        }
        
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
/**
 获取项目数据
 */
- (void)getProjectData {
    WEAKSELF
    [PPNetworkHelper GET:@"https://dev.inwecrypto.com/home/project" parameters:nil hudString:@"" success:^(id responseObject) {
        [weakSelf.projectArray removeAllObjects];
        [weakSelf.moneyConditionArray removeAllObjects];
        [weakSelf.isBackSideArray removeAllObjects];
        
        NSArray *dataArray = responseObject;
        NSInteger tag = 0;
        for (NSInteger i = 0; i < dataArray.count; i++) {
            NSDictionary *dic = dataArray[i];
            DBHInformationForProjectCollectionModelData *model = [DBHInformationForProjectCollectionModelData modelObjectWithDictionary:dic];
            
            if (model.gridType == 1) {
                if (!tag) {
                    [weakSelf.projectArray insertObject:model atIndex:tag];
                    [weakSelf.isBackSideArray insertObject:@"0" atIndex:tag];
                    tag = 0;
                } else {
                    [weakSelf.projectArray addObject:model];
                    [weakSelf.isBackSideArray addObject:@"0"];
                    tag = i + 1;
                }
            } else {
                [weakSelf.projectArray addObject:model];
                [weakSelf.isBackSideArray addObject:@"0"];
            }
            [weakSelf.moneyConditionArray addObject:@"0"];
        }
        
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
/**
 获取货币情况数据
 */
- (void)getMoneyConditionDataWithRow:(NSInteger)row {
    WEAKSELF
    DBHInformationForProjectCollectionModelData *model = self.projectArray[row];
    
    [PPNetworkHelper GET:[NSString stringWithFormat:@"https://dev.inwecrypto.com/%@", model.url] parameters:nil hudString:@"" success:^(id responseObject) {
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
                     // 所有资讯
                     DBHAllInformationViewController *allInformationViewController = [[DBHAllInformationViewController alloc] init];
                     [weakSelf.navigationController pushViewController:allInformationViewController animated:YES];
                     break;
                 }
                 case 1:
                 {
                     // Ico评测
                     DBHEvaluatingIcoViewController *evaluatingIcoViewController = [[DBHEvaluatingIcoViewController alloc] init];
                     [weakSelf.navigationController pushViewController:evaluatingIcoViewController animated:YES];
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
    
}

#pragma mark ------ Getters And Setters ------
- (DBHSearchBarButton *)searchBarButton {
    if (!_searchBarButton) {
        _searchBarButton = [DBHSearchBarButton buttonWithType:UIButtonTypeCustom];
        [_searchBarButton addTarget:self action:@selector(respondsToSearchBarButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBarButton;
}
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(SCREEN_WIDTH, AUTOLAYOUTSIZE(170));
    }
    return _layout;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[DBHInformationForRoastingChartCollectionViewCell class] forCellWithReuseIdentifier:kDBHInformationForRoastingChartCollectionViewCellIdentifier];
        [_collectionView registerClass:[DBHInformationForNewsCollectionViewCell class] forCellWithReuseIdentifier:kDBHInformationForNewsCollectionViewCellIdentifier];
        [_collectionView registerClass:[DBHInformationForProjectCollectionViewCell class] forCellWithReuseIdentifier:kDBHInformationForProjectCollectionViewCellIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)items
{
    if (!_items)
    {
        _items = [NSMutableArray array];
        
        YCXMenuItem *firstMenuItem = [YCXMenuItem menuItem:NSLocalizedString(@"All the information", nil)
                                          image:nil
                                            tag:100
                                       userInfo:@{@"title":@"Menu"}];
        YCXMenuItem *secondMenuItem = [YCXMenuItem menuItem:NSLocalizedString(@"Evaluating the Ico", nil)
                                                      image:nil
                                                        tag:101
                                                   userInfo:@{@"title":@"Menu"}];
        [firstMenuItem setForeColor:[UIColor colorWithHexString:@"97BDDB"]];
        [secondMenuItem setForeColor:[UIColor colorWithHexString:@"97BDDB"]];
        
        [_items addObject:firstMenuItem];
        [_items addObject:secondMenuItem];
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
- (NSMutableArray *)isBackSideArray {
    if (!_isBackSideArray) {
        _isBackSideArray = [NSMutableArray array];
    }
    return _isBackSideArray;
}

@end
