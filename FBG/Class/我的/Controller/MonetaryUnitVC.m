//
//  MonetaryUnitVC.m
//  FBG
//
//  Created by mac on 2017/7/24.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "MonetaryUnitVC.h"
#import "MonetaryUnitCell.h"
#import "MonetaryUnitModel.h"

@interface MonetaryUnitVC () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UIButton * sureButton;

@property (assign, nonatomic) NSIndexPath *selIndex;//单选，当前选中的行

@end

@implementation MonetaryUnitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"货币单位";
    self.view.backgroundColor = [UIColor backgroudColor];
    
    self.coustromTableView.emptyDataSetSource = self;
    self.coustromTableView.emptyDataSetDelegate = self;
    
    [self.view addSubview:self.coustromTableView];
    self.dataSource = [[NSMutableArray alloc] init];
    
    MonetaryUnitModel * model = [[MonetaryUnitModel alloc] init];
    model.id = 1;
    model.name = @"人民币";
    if ([UserSignData share].user.walletUnitType == 1)
    {
        model.user_unit_count = 1;
    }
    else
    {
        model.user_unit_count = 0;
    }
    [self.dataSource addObject:model];
    
    MonetaryUnitModel * model1 = [[MonetaryUnitModel alloc] init];
    model1.id = 2;
    model1.name = @"美元";
    if ([UserSignData share].user.walletUnitType == 2)
    {
        model1.user_unit_count = 1;
    }
    else
    {
        model1.user_unit_count = 0;
    }
    [self.dataSource addObject:model1];
    [self.coustromTableView reloadData];
    
    /*
    [PPNetworkHelper GET:@"monetary-unit" parameters:nil hudString:@"获取中..." success:^(id responseObject)
     {
         if ([[responseObject objectForKey:@"list"] count] > 0)
         {
             for (NSDictionary * dic in [responseObject objectForKey:@"list"])
             {
                 MonetaryUnitModel * model = [[MonetaryUnitModel alloc] initWithDictionary:dic];
                 [self.dataSource addObject:model];
             }
             [self.coustromTableView reloadData];
         }
         
    } failure:^(NSString *error)
    {
        [LCProgressHUD showFailure:error];
    }];
     */
}

- (void)sureButtonClicked
{
    //保存
}

#pragma mark - DZNEmptyDataSetSource Methods

//图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return Default_NoData_Image;
}

//属性字符串
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:text attributes:nil];
}

//背景色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor backgroudColor];
}

//此外，你还可以调整内容视图的垂直对齐（即：有用的时候，有tableheaderview可见）：
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -40.0;
}

//最后，您可以将组件彼此分离（默认分离为11个点）：
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MonetaryUnitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonetaryUnitCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MonetaryUnitCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MonetaryUnitModel * model = self.dataSource[indexPath.row];
    if (model.user_unit_count == 1)
    {
        _selIndex = indexPath;
        cell.statusImage.image = [UIImage imageNamed:@"list_btn_selected"];
    }
    else
    {
        cell.statusImage.image = [UIImage imageNamed:@"list_btn_default"];
    }
    cell.model = model;
    //当上下拉动的时候，因为cell的复用性，我们需要重新判断一下哪一行是打勾的
    if (_selIndex == indexPath)
    {
        cell.statusImage.image = [UIImage imageNamed:@"list_btn_selected"];
    }
    else
    {
        cell.statusImage.image = [UIImage imageNamed:@"list_btn_default"];
    }
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选择
    //之前选中的，取消选择
    MonetaryUnitCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
    celled.statusImage.image = [UIImage imageNamed:@"list_btn_default"];
    //记录当前选中的位置索引
    _selIndex = indexPath;
    //当前选择的打勾
    MonetaryUnitCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.statusImage.image = [UIImage imageNamed:@"list_btn_selected"];
    
    MonetaryUnitModel * model = self.dataSource[_selIndex.row];
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(model.id) forKey:@"monetary_unit_id"];
    
    [LCProgressHUD showMessage:@"设置成功"];
    [UserSignData share].user.walletUnitType = model.id;
    [[UserSignData share] storageData:[UserSignData share].user];
    
    /*
    [PPNetworkHelper POST:@"monetary-unit" parameters:parametersDic hudString:@"设置中..." success:^(id responseObject)
    {
        [LCProgressHUD showMessage:@"设置成功"];
        [UserSignData share].user.walletUnitType = model.id;
        [[UserSignData share] storageData:[UserSignData share].user];
    } failure:^(NSString *error)
    {
        [LCProgressHUD showFailure:error];
    }];
     */
}

#pragma mark -- get

- (UITableView *)coustromTableView
{
    if (!_coustromTableView)
    {
        _coustromTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 75 - 64) style:UITableViewStylePlain];
        _coustromTableView.delegate = self;
        _coustromTableView.dataSource = self;
        _coustromTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableView.showsVerticalScrollIndicator = NO;
        _coustromTableView.showsHorizontalScrollIndicator = NO;
        _coustromTableView.rowHeight = 90;
        _coustromTableView.backgroundColor = [UIColor backgroudColor];
    }
    return _coustromTableView;
}

- (UIButton *)sureButton
{
    if (!_sureButton)
    {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(20, SCREEN_HEIGHT - 75, SCREEN_WIDTH - 40, 45);
        [_sureButton setTitle:@"保  存" forState: UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.backgroundColor = [UIColor colorWithHexString:@"232772"];
        _sureButton.layer.cornerRadius = 6;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton addTarget:self action:@selector(sureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

@end
