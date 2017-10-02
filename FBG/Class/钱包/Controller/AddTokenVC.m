//
//  AddTokenVC.m
//  FBG
//
//  Created by mac on 2017/7/20.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddTokenVC.h"
#import "AddTokenCell.h"
#import "WalletInfoGntModel.h"

@interface AddTokenVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * gtnIdsDataSource;

@end

@implementation AddTokenVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Add Token", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Complete", nil) style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
    [rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 44)];
    label.text = NSLocalizedString(@"All tokens", nil);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.gtnIdsDataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.coustromTableView];
    [self loadData];
}

- (void)rightButton
{
    //完成
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(self.walletModel.id) forKey:@"wallet_id"];
    [parametersDic setObject:[self.gtnIdsDataSource toJSONStringForArray] forKey:@"gnt_category_ids"];
    
    [PPNetworkHelper POST:@"user-gnt" parameters:parametersDic hudString:@"添加中..." success:^(id responseObject)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSString *error)
    {
        [LCProgressHUD showFailure:error];
    }];
}

- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(self.walletModel.category_id) forKey:@"wallet_category_id"];
    [parametersDic setObject:@(self.walletModel.id) forKey:@"wallet_id"];
    
    [PPNetworkHelper GET:@"gnt-category" parameters:parametersDic hudString:@"加载中..." success:^(id responseObject)
    {
        if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]])
        {
            [self.dataSource removeAllObjects];
            for (NSDictionary * dic in [responseObject objectForKey:@"list"])
            {
                WalletInfoGntModel * model = [[WalletInfoGntModel alloc] initWithDictionary:dic];
                [self.dataSource addObject:model];
            }
            [self.coustromTableView reloadData];
        }
        
    } failure:^(NSString *error)
    {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddTokenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddTokenCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"AddTokenCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletInfoGntModel * model = self.dataSource[indexPath.row];
    AddTokenCell *cell = [self.coustromTableView cellForRowAtIndexPath:indexPath];
    if (model.isAdd)
    {
        //已添加
        [self.gtnIdsDataSource removeObject:@(model.id)];
        cell.seletedImage.image = [UIImage imageNamed:@"list_btn_default"];
        model.isAdd = NO;
    }
    else
    {
        //未添加
        [self.gtnIdsDataSource addObject:@(model.id)];
        cell.seletedImage.image = [UIImage imageNamed:@"list_btn_selected"];
        model.isAdd = YES;
    }
}

#pragma mark -- get

- (UITableView *)coustromTableView
{
    if (!_coustromTableView)
    {
        _coustromTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStylePlain];
        _coustromTableView.delegate = self;
        _coustromTableView.dataSource = self;
        _coustromTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableView.showsVerticalScrollIndicator = NO;
        _coustromTableView.showsHorizontalScrollIndicator = NO;
        _coustromTableView.rowHeight = 110;
    }
    return _coustromTableView;
}

@end
