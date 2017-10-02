//
//  MailListVC.m
//  FBG
//
//  Created by mac on 2017/7/22.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "MailListVC.h"
#import "MailListCell.h"
#import "AddMailVC.h"
#import "EditMailVC.h"
#import "MailMdel.h"

@interface MailListVC () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    BOOL _isType; //默认 NO ==> ETH  YES ==> BTC
}

@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) NSMutableArray * ETHDataSource;
@property (nonatomic, strong) NSMutableArray * BTCDataSource;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeChangeSM;

@end

@implementation MailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    
    self.coustromTableView.emptyDataSetSource = self;
    self.coustromTableView.emptyDataSetDelegate = self;
    
    self.typeChangeSM.layer.borderWidth = 1;
    self.typeChangeSM.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_add-friends"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.coustromTableView];
    self.ETHDataSource = [[NSMutableArray alloc] init];
    self.BTCDataSource = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)loadData
{
    [PPNetworkHelper GET:@"contact" parameters:nil hudString:@"获取中..." responseCache:^(id responseCache)
     {
         [self.ETHDataSource removeAllObjects];
         if ([[responseCache objectForKey:@"list"] count] > 0)
         {
             int i = 1;
             for (NSDictionary * dic in [responseCache objectForKey:@"list"])
             {
                 MailMdel * model = [[MailMdel alloc] initWithDictionary:dic];
                 model.img = [NSString stringWithFormat:@"通讯录头像%d",i];
                 [self.ETHDataSource addObject:model];
                 
                 i ++;
                 if (i == 10)
                 {
                     i = 1;
                 }
             }
             [self.coustromTableView reloadData];
             
         }
         
     } success:^(id responseObject)
     {
         [self.ETHDataSource removeAllObjects];
         if ([[responseObject objectForKey:@"list"] count] > 0)
         {
             int i = 1;
             for (NSDictionary * dic in [responseObject objectForKey:@"list"])
             {
                 MailMdel * model = [[MailMdel alloc] initWithDictionary:dic];
                 model.img = [NSString stringWithFormat:@"通讯录头像%d",i];
                 [self.ETHDataSource addObject:model];
                 
                 i ++;
                 if (i == 10)
                 {
                     i = 1;
                 }
             }
             [self.coustromTableView reloadData];
         }
         
    } failure:^(NSString *error)
    {
        [LCProgressHUD showFailure:error];
    }];
}

- (void)rightButton
{
    //添加
    AddMailVC * vc = [[AddMailVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)TypeChange:(id)sender
{
    //改变类型
    [LCProgressHUD showMessage:@"敬请期待"];
    [self.typeChangeSM setSelectedSegmentIndex:0];
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
    return [UIColor whiteColor];
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
    return _isType ? self.BTCDataSource.count : self.ETHDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailListCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MailListCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = _isType ? self.BTCDataSource[indexPath.row] : self.ETHDataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailMdel * model = _isType ? self.BTCDataSource[indexPath.row] : self.ETHDataSource[indexPath.row];
    if (self.isChose)
    {
        //选择回调
        if ([self.delegate respondsToSelector:@selector(choasePersonWithData:)])
        {
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate choasePersonWithData:model];
        }
    }
    else
    {
        //通讯录查看
        EditMailVC * vc = [[EditMailVC alloc] init];
        vc.id = [NSString stringWithFormat:@"%d",model.id];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- get

- (UITableView *)coustromTableView
{
    if (!_coustromTableView)
    {
        _coustromTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60 - 64) style:UITableViewStylePlain];
        _coustromTableView.delegate = self;
        _coustromTableView.dataSource = self;
        _coustromTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableView.showsVerticalScrollIndicator = NO;
        _coustromTableView.showsHorizontalScrollIndicator = NO;
        _coustromTableView.rowHeight = 100;
    }
    return _coustromTableView;
}

@end
