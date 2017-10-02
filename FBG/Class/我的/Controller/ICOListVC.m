 //
//  ICOListVC.m
//  FBG
//
//  Created by mac on 2017/7/24.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "ICOListVC.h"
#import "ICOInfoVC.h"
#import "ICOListCell.h"
#import "ICOOrderListModel.h"

@interface ICOListVC ()

/** 页数 */
@property (nonatomic, assign) int page;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation ICOListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ico订单";
    self.coustromTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.coustromTableView.rowHeight = 100;
    [self addpull2RefreshWithTableView:self.coustromTableView WithIsInset:NO];
    [self addPush2LoadMoreWithTableView:self.coustromTableView WithIsInset:NO];
    
    self.dataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.coustromTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.page = 1;
    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(self.page) forKey:@"page"];
    [parametersDic setObject:@(10) forKey:@"per_page"];
    
    [PPNetworkHelper GET:@"ico-order" parameters:parametersDic hudString:@"获取中..." success:^(id responseObject)
    {
        if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]])
        {
            if (self.page == 1)
            {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary * dic in [responseObject objectForKey:@"list"])
            {
                ICOOrderListModel * model = [[ICOOrderListModel alloc] initWithDictionary:dic];
                model.title = [[dic objectForKey:@"ico"] objectForKey:@"title"];
                model.cny = [[dic objectForKey:@"ico"] objectForKey:@"cny"];
                [self.dataSource addObject:model];
            }
        }
        else
        {
            if (self.page != 1)
            {
                self.page --;
                [LCProgressHUD showMessage:@"没有更多了"];
            }
        }
    } failure:^(NSString *error)
    {
        [LCProgressHUD showFailure:error];
        self.page = 1;
    }];
}

//下拉刷新回调
- (void)pull2RefreshWithScrollerView:(UIScrollView *)scrollerView
{
    self.page = 1;
    [self loadData];
}

//上提加载回调
- (void)push2LoadMoreWithScrollerView:(UIScrollView *)scrollerView
{
    self.page ++;
    [self loadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICOListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ICOListCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"ICOListCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //订单
    ICOOrderListModel * model = self.dataSource[indexPath.row];
    ICOInfoVC * vc = [[ICOInfoVC alloc] init];
    vc.id = [NSString stringWithFormat:@"%d",model.id];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
