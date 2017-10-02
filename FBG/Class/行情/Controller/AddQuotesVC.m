//
//  AddQuotesVC.m
//  FBG
//
//  Created by mac on 2017/7/28.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddQuotesVC.h"
#import "AddQuotesCell.h"
#import "QuotationModel.h"

@interface AddQuotesVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * keyArray;
@property (nonatomic, strong) NSMutableArray * market_ids;

@property (nonatomic, strong) UITextField * searchTF;
@end

@implementation AddQuotesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Add Quotes", nil);
    self.view.backgroundColor = [UIColor backgroudColor];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Complete", nil) style:UIBarButtonItemStyleDone target:self action:@selector(postEdit)];
    [rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.coustromTableView.frame = CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 55);
    self.coustromTableView.rowHeight = 100;
    [self addpull2RefreshWithTableView:self.coustromTableView WithIsInset:NO];
//    [self addPush2LoadMoreWithTableView:self.coustromTableView WithIsInset:NO];
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.keyArray = [[NSMutableArray alloc] init];
    self.market_ids = [[NSMutableArray alloc] init];
    [self.view addSubview:self.coustromTableView];
    [self.view addSubview:self.searchTF];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)loadData
{
    [PPNetworkHelper GET:[NSString stringWithFormat:@"market-category?is_all=1"] parameters:nil hudString:@"获取中..." responseCache:^(id responseCache)
     {
         //获取数据
         if (![NSString isNulllWithObject:[responseCache objectForKey:@"list"]])
         {
             [self.dataSource removeAllObjects];
             [self.market_ids removeAllObjects];
             [self.keyArray removeAllObjects];
             for (NSDictionary * quotesDic in [responseCache objectForKey:@"list"])
             {
                 [self.keyArray addObject:[quotesDic objectForKey:@"name"]];
                 NSMutableArray * infoArray = [[NSMutableArray alloc] init];
                 for (NSDictionary * dic in [quotesDic objectForKey:@"data"])
                 {
                     QuotationModel * quotesModel = [[QuotationModel alloc] initWithDictionary:dic];
                     [infoArray addObject:quotesModel];
                     if (quotesModel.relation_user_count == 1)
                     {
                         [self.market_ids addObject:@(quotesModel.id)];
                     }
                 }
                 [self.dataSource addObject:infoArray];
             }
             [self.coustromTableView reloadData];
             [self endRefreshing];
         }
         
     } success:^(id responseObject)
     {
         //获取数据
         if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]])
         {
             [self.dataSource removeAllObjects];
             [self.market_ids removeAllObjects];
             [self.keyArray removeAllObjects];
             for (NSDictionary * quotesDic in [responseObject objectForKey:@"list"])
             {
                 [self.keyArray addObject:[quotesDic objectForKey:@"name"]];
                 NSMutableArray * infoArray = [[NSMutableArray alloc] init];
                 for (NSDictionary * dic in [quotesDic objectForKey:@"data"])
                 {
                     QuotationModel * quotesModel = [[QuotationModel alloc] initWithDictionary:dic];
                     [infoArray addObject:quotesModel];
                     if (quotesModel.relation_user_count == 1)
                     {
                         [self.market_ids addObject:@(quotesModel.id)];
                     }
                 }
                 [self.dataSource addObject:infoArray];
             }
             [self.coustromTableView reloadData];
             [self endRefreshing];
         }
         
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
         [self endRefreshing];
     }];
}

- (void)postEdit
{
    //添加接口
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

//下拉刷新回调
- (void)pull2RefreshWithScrollerView:(UIScrollView *)scrollerView
{
    [self loadData];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //搜索数据
    for (int i = 0; i < self.dataSource.count; i ++)
    {
        for (int j = 0; j < [self.dataSource[i] count]; j ++)
        {
            QuotationModel * quotesModel = self.dataSource[i][j];
            if ([quotesModel.name caseInsensitiveCompare:self.searchTF.text] == NSOrderedSame)
            {
                [self.coustromTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
        }
    }
    
    [self.searchTF resignFirstResponder];
    return YES;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.keyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.keyArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddQuotesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddQuotesCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"AddQuotesCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuotationModel * quotesModel = self.dataSource[indexPath.section][indexPath.row];
    AddQuotesCell * cell = [self.coustromTableView cellForRowAtIndexPath:indexPath];
    if (quotesModel.relation_user_count == 1)
    {
        cell.statusImage.image = [UIImage imageNamed:@"list_btn_default"];
        quotesModel.relation_user_count = 0;
        [self.market_ids removeObject:@(quotesModel.id)];
    }
    else
    {
        cell.statusImage.image = [UIImage imageNamed:@"list_btn_selected"];
        quotesModel.relation_user_count = 1;
        [self.market_ids addObject:@(quotesModel.id)];
    }
}

#pragma mark -- get

- (UITextField *)searchTF
{
    if (!_searchTF)
    {
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, 35)];
        _searchTF.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
        _searchTF.layer.cornerRadius = 5;
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.delegate = self;
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        lineView.backgroundColor = [UIColor clearColor];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"搜索"];
        [lineView addSubview:imageView];
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.leftView = lineView;
    }
    return _searchTF;
}

@end
