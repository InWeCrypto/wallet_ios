//
//  DBHAllInformationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHAllInformationViewController.h"

#import "YCXMenu.h"

#import "DBHInformationDetailForDealViewController.h"
#import "DBHInformationDetailForCrowdfundingViewController.h"
#import "DBHEvaluatingIcoViewController.h"

#import "DBHSearchBarButton.h"
#import "DBHAllInformationTypeOneTableViewCell.h"
#import "DBHAllInformationTypeTwoTableViewCell.h"

#import "DBHAllInformationDataModels.h"

static NSString *const kDBHAllInformationTypeOneTableViewCellIdentifier = @"kDBHAllInformationTypeOneTableViewCellIdentifier";
static NSString *const kDBHAllInformationTypeTwoTableViewCellIdentifier = @"kDBHAllInformationTypeTwoTableViewCellIdentifier";

@interface DBHAllInformationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DBHSearchBarButton *searchBarButton;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHAllInformationViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"All the information", nil);
    self.view.backgroundColor = [UIColor colorWithHexString:@"171C27"];
    
    [self setUI];
    [self getInformationData];
}

#pragma mark ------ UI ------
- (void)setUI {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_market_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(repondsToRightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.searchBarButton];
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.searchBarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(24));
        make.height.offset(AUTOLAYOUTSIZE(32.5));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(5));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.searchBarButton.mas_bottom).offset(AUTOLAYOUTSIZE(22));
        make.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHAllInformationModelData *model = self.dataSource[indexPath.row];
    if (model.type != 1) {
        DBHAllInformationTypeOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHAllInformationTypeOneTableViewCellIdentifier forIndexPath:indexPath];
        cell.model = model;
        
        return cell;
    } else {
        DBHAllInformationTypeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHAllInformationTypeTwoTableViewCellIdentifier forIndexPath:indexPath];
        cell.model = model;
        
        return cell;
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        DBHInformationDetailForDealViewController *informationDetailForDealViewController = [[DBHInformationDetailForDealViewController alloc] init];
        [self.navigationController pushViewController:informationDetailForDealViewController animated:YES];
    } else {
        DBHInformationDetailForCrowdfundingViewController *informationDetailForCrowdfundingViewController = [[DBHInformationDetailForCrowdfundingViewController alloc] init];
        [self.navigationController pushViewController:informationDetailForCrowdfundingViewController animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHAllInformationModelData *model = self.dataSource[indexPath.row];
    return model.type != 1 ? AUTOLAYOUTSIZE(170) : AUTOLAYOUTSIZE(67);
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
 获取资讯数据
 */
- (void)getInformationData {
    WEAKSELF
    [PPNetworkHelper GET:@"https://dev.inwecrypto.com/article/all" parameters:nil hudString:@"" success:^(id responseObject) {
        for (NSDictionary *dic in responseObject) {
            DBHAllInformationModelData *model = [DBHAllInformationModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf.tableView reloadData];
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
    [YCXMenu setselectedIndex:1];
    [YCXMenu setselectedItemBackGroundColor:[UIColor colorWithHexString:@"FF7043"]];
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
    
}

#pragma mark ------ Getters And Setters ------
- (DBHSearchBarButton *)searchBarButton {
    if (!_searchBarButton) {
        _searchBarButton = [DBHSearchBarButton buttonWithType:UIButtonTypeCustom];
        [_searchBarButton addTarget:self action:@selector(respondsToSearchBarButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBarButton;
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
        
        [_tableView registerClass:[DBHAllInformationTypeOneTableViewCell class] forCellReuseIdentifier:kDBHAllInformationTypeOneTableViewCellIdentifier];
        [_tableView registerClass:[DBHAllInformationTypeTwoTableViewCell class] forCellReuseIdentifier:kDBHAllInformationTypeTwoTableViewCellIdentifier];
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
        YCXMenuItem *thirdMenuItem = [YCXMenuItem menuItem:NSLocalizedString(@"Evaluating the Ico", nil)
                                                      image:nil
                                                        tag:101
                                                   userInfo:@{@"title":@"Menu"}];
        [firstMenuItem setForeColor:[UIColor colorWithHexString:@"97BDDB"]];
        [secondMenuItem setForeColor:[UIColor whiteColor]];
        [thirdMenuItem setForeColor:[UIColor colorWithHexString:@"97BDDB"]];
        
        [_items addObject:firstMenuItem];
        [_items addObject:secondMenuItem];
        [_items addObject:thirdMenuItem];
    }
    return _items;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
