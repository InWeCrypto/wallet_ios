//
//  DBHAllInformationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHAllInformationViewController.h"

#import "YCXMenu.h"

#import "DBHEvaluatingIcoViewController.h"
#import "DBHSearchViewController.h"
#import "KKWebView.h"

#import "DBHAllInformationTypeOneTableViewCell.h"
#import "DBHAllInformationTypeTwoTableViewCell.h"

#import "DBHAllInformationDataModels.h"

static NSString *const kDBHAllInformationTypeOneTableViewCellIdentifier = @"kDBHAllInformationTypeOneTableViewCellIdentifier";
static NSString *const kDBHAllInformationTypeTwoTableViewCellIdentifier = @"kDBHAllInformationTypeTwoTableViewCellIdentifier";

@interface DBHAllInformationViewController ()<UITableViewDataSource, UITableViewDelegate>

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
    [self addRefresh];
    
    [self getInformationData];
}

#pragma mark ------ UI ------
- (void)setUI {
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_market_search"] style:UIBarButtonItemStylePlain target:self action:@selector(repondsToSearchBarButtonItem)];
    UIBarButtonItem *moreBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_market_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(repondsToRightBarButtonItem)];
    self.navigationItem.rightBarButtonItems = @[moreBarButtonItem, searchBarButtonItem];
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
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
    DBHAllInformationModelData *model = self.dataSource[indexPath.row];
    
    NSString *url;
    if ([model.url containsString:@"http"]) {
        url = model.url;
    } else {
        url = [NSString stringWithFormat:@"%@/%@", [APP_APIEHEAD isEqualToString:APIEHEAD] ? APIEHEADOTHER : APIEHEAD1OTHER, model.url];
    }
    
    KKWebView * vc = [[KKWebView alloc] initWithUrl:url];
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHAllInformationModelData *model = self.dataSource[indexPath.row];
    return model.type != 1 ? AUTOLAYOUTSIZE(170) : AUTOLAYOUTSIZE(67);
}

#pragma mark ------ Data ------
/**
 获取资讯数据
 */
- (void)getInformationData {
    WEAKSELF
    [PPNetworkHelper GET:@"article/all" isOtherBaseUrl:YES parameters:nil hudString:@"" success:^(id responseObject) {
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseObject) {
            DBHAllInformationModelData *model = [DBHAllInformationModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf endRefresh];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 右上角按钮
 */
- (void)repondsToRightBarButtonItem {
    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"D2D2D2"]];
    [YCXMenu setTintColor:[UIColor colorWithHexString:@"FFFFFF"]];
    [YCXMenu setTitleFont:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)]];
    [YCXMenu setSelectedColor:[UIColor colorWithHexString:@"FFFFFF"]];
    [YCXMenu setselectedIndex:1];
    [YCXMenu setselectedItemBackGroundColor:[UIColor colorWithHexString:@"DCDCDC"]];
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
- (void)repondsToSearchBarButtonItem {
    DBHSearchViewController *searchViewController = [[DBHSearchViewController alloc] init];
    searchViewController.title = @"搜索资讯";
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark ------ Private Methods ------
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getInformationData];
    }];
}
/**
 结束刷新
 */
- (void)endRefresh {
    if (self.tableView.mj_header.refreshing) {
        [self.tableView.mj_header endRefreshing];
    }
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
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
        YCXMenuItem *thirdMenuItem = [YCXMenuItem menuItem:NSLocalizedString(@"Business Project", nil)
                                                      image:nil
                                                        tag:101
                                                   userInfo:@{@"title":@"Menu"}];
        [firstMenuItem setForeColor:[UIColor colorWithHexString:@"3F3F3F"]];
        [secondMenuItem setForeColor:[UIColor colorWithHexString:@"3F3F3F"]];
        [thirdMenuItem setForeColor:[UIColor colorWithHexString:@"3F3F3F"]];
        
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
