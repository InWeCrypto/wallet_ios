//
//  TransactionRecordVCViewController.m
//  FBG
//
//  Created by mac on 2017/7/20.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "TransactionRecordVC.h"
#import "TransactionCell.h"
#import "TransactionInfoVC.h"
#import "WalletOrderModel.h"

@interface TransactionRecordVC () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isReceivables; //是否是收款
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeChangeSM;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;


@end

@implementation TransactionRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Transaction Record", nil);
    [self.typeChangeSM setTitle:NSLocalizedString(@"Transfer Accounts", nil) forSegmentAtIndex:0];
    [self.typeChangeSM setTitle:NSLocalizedString(@"Receivables", nil) forSegmentAtIndex:1];
    
    self.coustromTableView.frame = CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60 - 64);
    self.coustromTableView.rowHeight = 100;
    [self addpull2RefreshWithTableView:self.coustromTableView WithIsInset:NO];
    
    self.typeChangeSM.layer.borderWidth = 1;
    self.typeChangeSM.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.dataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.coustromTableView];
}
- (IBAction)TypeChange:(id)sender
{
    _isReceivables = !_isReceivables;
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(self.model.id) forKey:@"wallet_id"];
    [parametersDic setObject:_isReceivables ? @(2) : @(1) forKey:@"type"];
    [parametersDic setObject:self.tokenModel ? self.tokenModel.name : self.model.category_name forKey:@"flag"];
    
    [PPNetworkHelper GET:@"wallet-order" parameters:parametersDic hudString:@"加载中..." success:^(id responseObject)
     {
         if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]])
         {
             [self.dataSource removeAllObjects];
             for (NSDictionary * dic in [responseObject objectForKey:@"list"])
             {
                 WalletOrderModel * model = [[WalletOrderModel alloc] initWithDictionary:dic];
                 model.isReceivables = _isReceivables;
                 [self.dataSource addObject:model];
             }
             [self.coustromTableView reloadData];
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
    TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionCellident"];
    cell = nil;
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"TransactionCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_isReceivables)
    {
        //收款
        cell.typeImage.image = [UIImage imageNamed:@""];
    }
    else
    {
        //转账
        if (indexPath.row % 2 == 0)
        {
            cell.typeImage.image = [UIImage imageNamed:@"icon_complete"];
        }
        else
        {
            cell.typeImage.image = [UIImage imageNamed:@"icon_processing"];
        }
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //记录详情
    WalletOrderModel * model = self.dataSource[indexPath.row];
    TransactionInfoVC * vc = [[TransactionInfoVC alloc] init];
    vc.isTransfer = _isReceivables;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- get



@end
