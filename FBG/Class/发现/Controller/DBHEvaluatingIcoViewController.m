//
//  DBHEvaluatingIcoViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHEvaluatingIcoViewController.h"

#import "YCXMenu.h"

#import "DBHAllInformationViewController.h"
#import "DBHSearchViewController.h"
#import "KKWebView.h"

#import "DBHEvaluatingIcoTableViewCell.h"

#import "DBHEvaluatingIcoDataModels.h"

static NSString *const kDBHEvaluatingIcoTableViewCellIdentifier = @"kDBHEvaluatingIcoTableViewCellIdentifier";

@interface DBHEvaluatingIcoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHEvaluatingIcoViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Business Project", nil);
    self.view.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    [self setUI];
    [self addRefresh];
    
    [self getIcoData];
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
    DBHEvaluatingIcoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHEvaluatingIcoTableViewCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHEvaluatingIcoModelData *model = self.dataSource[indexPath.row];
    
    NSString *url;
    if ([model.url containsString:@"http"]) {
        url = model.url;
    } else {
        url = [NSString stringWithFormat:@"%@/%@", [APP_APIEHEAD isEqualToString:APIEHEAD] ? APIEHEADOTHER : APIEHEAD1OTHER, model.url];
    }
    
    KKWebView * vc = [[KKWebView alloc] initWithUrl:url];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------ Data ------
/**
 获取ICO评测数据
 */
- (void)getIcoData {
    WEAKSELF
    [PPNetworkHelper GET:@"article/ico" isOtherBaseUrl:YES parameters:nil hudString:@"" success:^(id responseObject) {
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseObject) {
            DBHEvaluatingIcoModelData *model = [DBHEvaluatingIcoModelData modelObjectWithDictionary:dic];
            
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
    [YCXMenu setselectedIndex:2];
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
    searchViewController.title = @"搜索Ico评测";
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark ------ Private Methods ------
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getIcoData];
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
        _tableView.backgroundColor = COLORFROM16(0xFFFFFF, 1);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.rowHeight = AUTOLAYOUTSIZE(290.5);
        
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHEvaluatingIcoTableViewCell class] forCellReuseIdentifier:kDBHEvaluatingIcoTableViewCellIdentifier];
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
