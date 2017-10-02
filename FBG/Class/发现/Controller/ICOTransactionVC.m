//
//  ICOTransactionVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/3.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "ICOTransactionVC.h"
#import "ICOCell.h"
#import "ICOListModel.h"
#import "KKWebView.h"

@interface ICOTransactionVC () <UITableViewDelegate, UITableViewDataSource>

/** 页数 */
@property (nonatomic, assign) int page;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation ICOTransactionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ico交易";
    self.view.backgroundColor = [UIColor backgroudColor];
    
    self.coustromTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.coustromTableView.rowHeight = SCREEN_WIDTH * 206 / 375 + 68;
    
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
    
    [PPNetworkHelper GET:@"ico" parameters:parametersDic hudString:@"获取中..." success:^(id responseObject)
     {
         if (self.page == 1)
         {
             [self.dataSource removeAllObjects];
         }
         if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]])
         {
             for (NSDictionary * icoDic in [responseObject objectForKey:@"list"])
             {
                 ICOListModel * model = [[ICOListModel alloc] initWithDictionary:icoDic];
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
         [self.coustromTableView reloadData];
         [self endRefreshing];
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
         self.page = 1;
         [self endRefreshing];
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
    ICOCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ICOCellident"];
    cell = nil;
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"ICOCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICOListModel * model = self.dataSource[indexPath.row];
    KKWebView *webView = [[KKWebView alloc] initWithUrl:model.url];
    webView.icoModel = model;
    webView.title = model.title;
    [self.navigationController pushViewController:webView animated:YES];
}

@end
