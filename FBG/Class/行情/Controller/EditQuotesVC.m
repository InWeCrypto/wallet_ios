//
//  EditQuotesVC.m
//  FBG
//
//  Created by mac on 2017/7/28.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "EditQuotesVC.h"
#import "EditQuotesCell.h"
#import "QuotationModel.h"

@interface EditQuotesVC ()<UITableViewDelegate, UITableViewDataSource>
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * market_ids;

@end

@implementation EditQuotesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Edit Quotes", nil);
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Complete", nil) style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
    [rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.coustromTableView.frame = CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45 - 64);
    self.coustromTableView.rowHeight = 100;
    [self addpull2RefreshWithTableView:self.coustromTableView WithIsInset:NO];
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.market_ids = [[NSMutableArray alloc] init];
    [self.view addSubview:self.coustromTableView];
    
    [self.coustromTableView setEditing:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)rightButton
{
    //保存
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:[self.market_ids toJSONStringForArray] forKey:@"market_ids"];
    
    [PPNetworkHelper POST:@"market-category" parameters:parametersDic hudString:@"设置中..." success:^(id responseObject)
     {
         [PPNetworkHelper GET:@"market-category" parameters:nil hudString:nil responseCache:^(id responseCache)
          {
          } success:^(id responseObject)
          {
              [self.navigationController popViewControllerAnimated:YES];
          } failure:^(NSString *error)
          {
          }];
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
}

- (void)loadData
{
    [PPNetworkHelper GET:@"market-category" parameters:nil hudString:@"获取中..." success:^(id responseObject)
     {
         //获取数据
         if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]])
         {
             [self.dataSource removeAllObjects];
             [self.market_ids removeAllObjects];
             
             for (NSDictionary * quotesDic in [responseObject objectForKey:@"list"])
             {
                 for (NSDictionary * dic in [quotesDic objectForKey:@"data"])
                 {
                     QuotationModel * quotesModel = [[QuotationModel alloc] initWithDictionary:dic];
                     [self.market_ids addObject:@(quotesModel.id)];
                     [self.dataSource addObject:quotesModel];
                 }
             }
             [self.coustromTableView reloadData];
             [self endRefreshing];
         }
         
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
}

//下拉刷新回调
- (void)pull2RefreshWithScrollerView:(UIScrollView *)scrollerView
{
    [self loadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditQuotesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditQuotesCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"EditQuotesCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

//对数据源进行重新排序
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // 取出要拖动的模型数据
     QuotationModel * quotesModel = self.dataSource[sourceIndexPath.row];
    id quotesId = self.market_ids[sourceIndexPath.row];
    //删除之前行的数据
    [self.dataSource removeObject:quotesModel];
    [self.market_ids removeObject:quotesId];
    // 插入数据到新的位置
    [self.dataSource insertObject:quotesModel atIndex:destinationIndexPath.row];
    [self.market_ids insertObject:quotesId atIndex:destinationIndexPath.row];
}
//如果是删除和添加的话,不过需要在style中返回要使用的cell的style
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        //添加操作
//        [self.dataSource insertObject:@"xxgxgxu" atIndex:indexPath.row];
    }
    else if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //删除操作
//        [self.dataSource removeObjectAtIndex:indexPath.row];
    }
    [self.coustromTableView reloadData];
}

#pragma mark -- get

@end
