//
//  AddWalletChoseTypeVC.m
//  FBG
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddWalletChoseTypeVC.h"
#import "AddEthOrBtcVC.h"
#import "WalletTypeModel.h"
#import "AddWalletChoseTypeCell.h"
#import "AddOtherWalletVC.h"

@interface AddWalletChoseTypeVC ()

/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UIButton * sureButton;
@property (assign, nonatomic) NSIndexPath *selIndex;//单选，当前选中的行
@property (nonatomic, strong) WalletTypeModel * selmodel;

@end

@implementation AddWalletChoseTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Add Wallet", nil);
    self.view.backgroundColor = [UIColor backgroudColor];
    
    self.coustromTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 75);
    self.coustromTableView.rowHeight = 85;
    self.coustromTableView.backgroundColor = [UIColor backgroudColor];
//    [self addpull2RefreshWithTableView:self.coustromTableView WithIsInset:NO];
    
    self.dataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.coustromTableView];
    [self.view addSubview:self.sureButton];
    
//    [self.sureButton setTitle:NSLocalizedString(@"Determine", nil) forState:UIControlStateNormal];
    [self loadData];
}

- (void)sureButtonCilick
{
    if ([NSString isNulllWithObject:_selmodel])
    {
        [LCProgressHUD showMessage:@"请选择相应的类型"];
        return;
    }
    if (![_selmodel.name isEqualToString:@"ETH"])
    {
        [LCProgressHUD showMessage:@"当前只能创建ETH钱包"];
        return;
    }
    if (self.isimport)
    {
        //导入钱包
        AddOtherWalletVC * vc = [[AddOtherWalletVC alloc] init];
        vc.model = _selmodel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        //添加钱包
        if ([_selmodel.name isEqualToString:@"ETH"])
        {
            //ETH
            AddEthOrBtcVC * vc = [[AddEthOrBtcVC alloc] init];
            vc.model = _selmodel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([_selmodel.name isEqualToString:@"BTC"])
        {
            //BTC
            AddEthOrBtcVC * vc = [[AddEthOrBtcVC alloc] init];
            vc.model = _selmodel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            //其他
            
        }
    }
    
}

- (void)loadData
{
    WalletTypeModel * model = [[WalletTypeModel alloc] init];
    model.id = 1;
    model.name = @"ETH";
    model.gas = @"21000";
    model.icon = @"ETH";
    [self.dataSource addObject:model];
    
    WalletTypeModel * model1 = [[WalletTypeModel alloc] init];
    model1.id = 3;
    model1.name = @"BTC";
    model1.gas = @"21000";
    model1.icon = @"BTC";
    [self.dataSource addObject:model1];
    
    [self.coustromTableView reloadData];

//    [PPNetworkHelper GET:@"wallet-category" parameters:nil hudString:nil responseCache:^(id responseCache)
//    {
//        if (![NSString isNulllWithObject:[responseCache objectForKey:@"list"]])
//        {
//            [self.dataSource removeAllObjects];
//            for (NSDictionary * dic in [responseCache objectForKey:@"list"])
//            {
//                WalletTypeModel * model = [[WalletTypeModel alloc] initWithDictionary:dic];
//                [self.dataSource addObject:model];
//            }
//            [self.coustromTableView reloadData];
//        }
//    } success:^(id responseObject)
//    {
//        if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]] && self.dataSource.count == 0)
//        {
//            [self.dataSource removeAllObjects];
//            for (NSDictionary * dic in [responseObject objectForKey:@"list"])
//            {
//                WalletTypeModel * model = [[WalletTypeModel alloc] initWithDictionary:dic];
//                [self.dataSource addObject:model];
//            }
//            [self.coustromTableView reloadData];
//        }
//    } failure:^(NSString *error)
//    {
//    }];
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
    AddWalletChoseTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddWalletChoseTypeCellident"];
    cell = nil;
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"AddWalletChoseTypeCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选择
    //之前选中的，取消选择
    AddWalletChoseTypeCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
    celled.statusImage.image = [UIImage imageNamed:@"list_btn_default"];
    //记录当前选中的位置索引
    _selIndex = indexPath;
    //当前选择的打勾
    AddWalletChoseTypeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.statusImage.image = [UIImage imageNamed:@"list_btn_selected"];
    
    _selmodel = self.dataSource[indexPath.row];
}

#pragma mark -- get

- (UIButton *)sureButton
{
    if (!_sureButton)
    {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(20, SCREEN_HEIGHT - 75 - 64, SCREEN_WIDTH - 40, 45);
        [_sureButton setTitle:@"确  定" forState: UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.backgroundColor = [UIColor colorWithHexString:@"232772"];
        _sureButton.layer.cornerRadius = 6;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton addTarget:self action:@selector(sureButtonCilick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

@end
