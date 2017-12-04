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
#import "AddQuotesVCDataModels.h"

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
    [PPNetworkHelper GET:[NSString stringWithFormat:@"user/ticker/options"] isOtherBaseUrl:YES parameters:nil hudString:@"获取中..." responseCache:^(id responseCache)
     {
         //获取数据
         NSArray *dataArray = responseCache;
         if (dataArray.count)
         {
             [self.dataSource removeAllObjects];
             [self.keyArray removeAllObjects];
             [self.market_ids removeAllObjects];
             
             for (NSDictionary *dic in dataArray) {
                 AddQuotesVCModelData *quotesModel = [AddQuotesVCModelData modelObjectWithDictionary:dic];
                 
                 [self.dataSource addObject:quotesModel];
                 
                 if (![NSObject isNulllWithObject:quotesModel.userTicker.icoId]) {
                     [self.market_ids addObject:quotesModel.userTicker];
                 }
             }
//             for (NSDictionary * quotesDic in dataArray)
//             {
//                 [self.keyArray addObject:[quotesDic objectForKey:@"name"]];
//                 NSMutableArray * infoArray = [[NSMutableArray alloc] init];
//                 for (NSDictionary * dic in [quotesDic objectForKey:@"data"])
//                 {
//                     AddQuotesVCModelData * quotesModel = [AddQuotesVCModelData modelObjectWithDictionary:dic];
//                     [infoArray addObject:quotesModel];
//                     if (quotesModel.userTicker.integerValue == 1)
//                     {
//                         [self.market_ids addObject:@(quotesModel.userTicker.integerValue)];
//                     }
//                 }
//                 [self.dataSource addObject:infoArray];
//             }
             [self.coustromTableView reloadData];
             [self endRefreshing];
         }
         
     } success:^(id responseObject)
     {
         NSArray *dataArray = responseObject;
         //获取数据
         if (dataArray.count)
         {
             [self.dataSource removeAllObjects];
             [self.keyArray removeAllObjects];
             [self.market_ids removeAllObjects];
             
             for (NSDictionary *dic in dataArray) {
                 AddQuotesVCModelData *quotesModel = [AddQuotesVCModelData modelObjectWithDictionary:dic];
                 
                 [self.dataSource addObject:quotesModel];
                 
                 if (![NSObject isNulllWithObject:quotesModel.userTicker.icoId]) {
                     [self.market_ids addObject:quotesModel.userTicker];
                 }
             }
//             for (NSDictionary * quotesDic in dataArray)
//             {
////                 [self.keyArray addObject:[quotesDic objectForKey:@"name"]];
//                 NSMutableArray * infoArray = [[NSMutableArray alloc] init];
//                 for (NSDictionary * dic in [quotesDic objectForKey:@"data"])
//                 {
//                     AddQuotesVCModelData *quotesModel = [AddQuotesVCModelData modelObjectWithDictionary:dic];
//                     [infoArray addObject:quotesModel];
//                     if (quotesModel.userTicker.integerValue == 1)
//                     {
//                         [self.market_ids addObject:@(quotesModel.userTicker.integerValue)];
//                     }
//                 }
//                 [self.dataSource addObject:infoArray];
//             }
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
    NSMutableArray *markArray = [NSMutableArray array];
    for (AddQuotesVCModelUserTicker *ticker in self.market_ids) {
        [markArray addObject:@{@"id":ticker.icoId, @"sort":ticker.sort}];
    }
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:[markArray toJSONStringForArray] forKey:@"market_ids"];
    
    [PPNetworkHelper PUT:@"user/ticker" isOtherBaseUrl:YES parameters:parametersDic hudString:@"设置中..." success:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
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
        AddQuotesVCModelData * quotesModel = self.dataSource[i];
        if ([[quotesModel.enName uppercaseString] caseInsensitiveCompare:self.searchTF.text] == NSOrderedSame)
        {
            [self.coustromTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
//        for (int j = 0; j < [self.dataSource[i] count]; j ++)
//        {
//            QuotationModel * quotesModel = self.dataSource[i][j];
//            if ([quotesModel.name caseInsensitiveCompare:self.searchTF.text] == NSOrderedSame)
//            {
//                [self.coustromTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//            }
//        }
    }
    
    [self.searchTF resignFirstResponder];
    return YES;
}

#pragma mark UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.keyArray.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;//[self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return self.keyArray[section];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddQuotesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddQuotesCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"AddQuotesCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    AddQuotesVCModelData * quotesModel = self.dataSource[indexPath.row];
    cell.model = quotesModel;//self.dataSource[indexPath.section][indexPath.row];
    cell.statusImage.image = [UIImage imageNamed: [self.market_ids containsObject:quotesModel.userTicker] ?  @"list_btn_selected" : @"list_btn_default"];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddQuotesVCModelData * quotesModel = self.dataSource[indexPath.row];//self.dataSource[indexPath.section][indexPath.row];
    AddQuotesCell * cell = [self.coustromTableView cellForRowAtIndexPath:indexPath];
    if ([self.market_ids containsObject:quotesModel.userTicker]) {
        [self.market_ids removeObject:quotesModel.userTicker];
        cell.statusImage.image = [UIImage imageNamed:@"list_btn_default"];
    } else {
        AddQuotesVCModelUserTicker *mark = quotesModel.userTicker;
        if ([NSObject isNulllWithObject:mark.icoId]) {
            mark.icoId = [NSString stringWithFormat:@"%ld", (NSInteger)quotesModel.dataIdentifier];
            mark.sort = [NSString stringWithFormat:@"%ld", (NSInteger)quotesModel.sort];
        }
        [self.market_ids addObject:mark];
        cell.statusImage.image = [UIImage imageNamed:@"list_btn_selected"];
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
